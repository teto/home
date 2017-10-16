{ stdenv
, fetchFromGitHub, fetchurl
, python
# TODO remove once merged upstream
, pygccxml

, withNetanim ? false
, withDoc ? false
, withManual ? false
, withGsl ? false

# --enable-examples
, withExamples ? false

# --enable-tests
, withTests ? false
, generateBindings ? false

# All modules can be enabled by choosing 'all_modules'.
, modules ? [ "core" ]
, pkgs
, lib
}:

stdenv.mkDerivation rec {
  name = "ns-3.${version}";
  version = "27";

  # the all in one fetches netanim etc.
  # src = fetchurl {
  #   url = https://www.nsnam.org/release/ns-allinone-3.27.tar.bz2;
  #   sha256 = "0988rxaxw9lykm9igxk9ignd76pq3pi5xrqhm34rngpayksm6b0r";
  # };
  # in case we fetch form github
  src = fetchFromGitHub {
    owner  = "nsnam";
    repo   = "ns-3-dev-git";
    rev = "${name}";
    sha256 = "1w25qazsi4n35wzpxrfc1pdrid43gan3166c0bif196apras5phd";
  };

  # src = /home/teto/ns-3-dev-git;

  # buildInputs = lib.optionals generateBindings [ pkgs.castxml pygccxml ];
  propagatedBuildInputs = with python.pythonPackages; with pkgs; [ gcc6 python ]
    ++ lib.optionals generateBindings [ pkgs.castxml pygccxml ]
    ++ stdenv.lib.optional withDoc [ doxygen graphviz imagemagick ]
    ++ stdenv.lib.optional withManual [ python-sphinx dia ]
    ++ stdenv.lib.optional withGsl [ gsl-bin libgsl2 libgsl ]
    ;

    # withNetanim ? [ qt4-dev-tools libqt4-dev ]
    #
    # sqlite sqlite3 libsqlite3-dev
    # todo configure
    # --enable-examples --enable-tests --enable-modules=core
    # ${stdenv.lib.optionalString withExamples "--enable-examples"}
  configurePhase = ''
    runHook preConfigure
    # make configure
    # TODO limit modules so that it gets faster
    ./waf configure --prefix=$out \
      --enable-modules=core \
      '' + stdenv.lib.optionalString withExamples " --enable-examples "
      + stdenv.lib.optionalString withTests " --enable-tests " + ''

    runHook preConfigure
  '' ;

  # buildFlags = [ "CFLAGS=-Wno-error" ];

  # todo add hooks
  postBuild = stdenv.lib.optionalString generateBindings "./waf --apiscan=all";
  # ''
    
  #   '';
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
