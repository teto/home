{ stdenv
, fetchFromGitHub, fetchurl
, python

# for binding generation
, castxml ? null, pygccxml ? null

# for documentation
, doxygen ? null, graphviz ? null, imagemagick ? null

# for manual, tetex is used to get the eps2pdf binary
, dia, tetex ? null, ghostscript ? null

, withDoc ? false
, withManual ? false
, withGsl ? false

# --enable-examples
, withExamples ? false

# --enable-tests
, withTests ? true
, generateBindings ? false

# All modules can be enabled by choosing 'all_modules'.
# included here the DCE mandatory ones
, modules ? [ "core" "network" "internet" "point-to-point"]
, pkgs
, lib
}:

stdenv.mkDerivation rec {
  name = "ns-3.${version}";
  version = "27";

  # the all in one fetches netanim etc.
  # https://www.nsnam.org/release/ns-allinone-3.27.tar.bz2;
  src = fetchFromGitHub {
    owner  = "nsnam";
    repo   = "ns-3-dev-git";
    rev = "${name}";
    sha256 = "1w25qazsi4n35wzpxrfc1pdrid43gan3166c0bif196apras5phd";
  };

  buildInputs = lib.optionals generateBindings [ pkgs.castxml pygccxml ]
    ++ stdenv.lib.optional withDoc [ doxygen graphviz imagemagick python ]
    ++ stdenv.lib.optional withManual [ python.pkgs.sphinx dia tetex ];

  propagatedBuildInputs = with python.pythonPackages; with pkgs; [ gcc6 python ]
    ++ stdenv.lib.optional withGsl [ gsl-bin libgsl2 libgsl ]
    ;

  postPatch = ''
    patchShebangs doc/ns3_html_theme/get_version.sh
  '';

  configurePhase = ''
    runHook preConfigure

    ./waf configure --prefix=$out \
      --enable-modules="${stdenv.lib.concatStringsSep "," modules}" \
      '' + stdenv.lib.optionalString withExamples " --enable-examples "
      + stdenv.lib.optionalString withTests " --enable-tests " + ''

    runHook preConfigure
  '' ;

  postBuild = with stdenv.lib; let flags = concatStringsSep ";" (
       optional generateBindings "./waf --apiscan=all "
       ++ optional withDoc "./waf doxygen"
       ++ optional withManual "./waf sphinx"
      );
      in "${flags}"
    ;

  checkPhase =  ''
    ./test.py
    '';
  doCheck = withTests || withExamples;

  # installPhase = ''
  #   mkdir -p $out/bin $out/share/man/man1
  #   cp sl $out/bin
  #   cp sl.1 $out/share/man/man1
  #   nativeBuildInputs = [gcc g++ python python-dev
  #   ];
  # uncrustify

  #
  # '';

  meta = {
    homepage = http://www.nsnam.org;
    license = stdenv.lib.licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with stdenv.lib.platforms; unix;
  };
}
# https://www.nsnam.org/wiki/Installation#Ubuntu.2FDebian
  # ns3-dev = super.stdenv.mkDerivation({

  #   name = "ns-3";
  #   version = "26";
  #   doCheck=false; # doesn't work, checkPhase still happens
  #   checkPhase="echo 'ignored'";
  #   # we need keyring to retreive passwords etc
  #   # propagatedBuildInputs = oldAttrs.propagatedBuildInputs
  #   ++ (with super.pkgs.python3Packages; [ requests_oauthlib keyring secretstorage ]) ++ [ super.pkgs.liboauth ];
  # });
