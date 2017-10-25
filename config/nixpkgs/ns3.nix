{ stdenv
, fetchFromGitHub, fetchurl
, python
# TODO remove once merged upstream
, castxml ? null, pygccxml ? null
# for documentation
, doxygen ? null, graphviz ? null, imagemagick ? null
# for manual
, dia

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
    ++ stdenv.lib.optional withDoc [ doxygen graphviz imagemagick ]
    ++ stdenv.lib.optional withManual [ python.pkgs.sphinx dia ];

  propagatedBuildInputs = with python.pythonPackages; with pkgs; [ gcc6 python ]
    ++ stdenv.lib.optional withGsl [ gsl-bin libgsl2 libgsl ]
    ;

  configurePhase = ''
    runHook preConfigure

    ./waf configure --prefix=$out \
      --enable-modules="${stdenv.lib.concatStringsSep "," modules}" \
      '' + stdenv.lib.optionalString withExamples " --enable-examples "
      + stdenv.lib.optionalString withTests " --enable-tests " + ''

    runHook preConfigure
  '' ;

  postBuild = with stdenv.lib; ''
    '' + builtins.toString(builtins.concatStringsSep "\\" [ optionalString generateBindings "./waf --apiscan=all "
       stdenv.lib.optionalString withDoc "./waf doxygen"
       stdenv.lib.optionalString withManual "./waf sphinx"
       " toto "
      ])
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
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
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
