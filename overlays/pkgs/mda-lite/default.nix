{ stdenv
, fetchFromGitLab
, pkgconfig 
, autoreconfHook
, check
, graph-tool
# , openssl # for libcrypto
# , libpcap
, scapy
, setuptools
, netifaces
, python
, buildPythonApplication
}:

let
  pythonEnv = python.withPackages(ps: with ps; [ 
    scapy netifaces setuptools graph-tool
  ]);
in
  # stdenv.mkDerivation rec 
  buildPythonApplication {
  name = "mda-lite";
  version = "20180606";

  # FATAL we need to keep a git repo
  src = fetchFromGitLab {
# https://gitlab.planet-lab.eu/cartography/multilevel-mda-lite
    domain = "gitlab.planet-lab.eu";
    owner = "cartography";
    repo = "multilevel-mda-lite";
    rev = "3bf432efed9610f49416dfb4754669e541171c38";
    sha256 = "1ryv1c4cj6zw19z027wrrzbaya0l94f1yfc72kjrb3liw7x7my91";

    # leaveDotGit = true;

    #  deepClone = true;

    # dvlp branch => ne compile pas
    # rev = "19ef5c6ecf3e25844a53d2980e0cb9aea8841b34";
    # sha256 = "0ii78gna06gkkkw3qb774lfxxdh478ab8qligyglmiy6hxl4w00k";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ pythonEnv ];

  meta = with lib; {

    homepage =  https://gitlab.planet-lab.eu/cartography/multilevel-mda-lite;
    description = "Multipath traceroute";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}

