{ stdenv, fetchFromBitbucket
, pkgconfig 
, autoreconfHook
, check
, openssl # for libcrypto
, libpcap
}:

let
  pythonEnv = python.withPackages(ps: [ ps.scapy ]);
in
stdenv.mkDerivation rec {
  name = "mda-lite";
  version = "20180606";

  # FATAL we need to keep a git repo
  src = fetchFromGitLab {
# https://gitlab.planet-lab.eu/cartography/multilevel-mda-lite
    domain = "gitlab.planet-lab.eu";
    owner = "cartography";
    repo = "multilevel-mda-lite";
    rev = "1e4ac42";
    sha256 = "10claj0x5gqmbn0zjz251hns43zl92d9rsrri2hx28p31l23pfg0";

    # leaveDotGit = true;

    #  deepClone = true;

    # dvlp branch => ne compile pas
    # rev = "19ef5c6ecf3e25844a53d2980e0cb9aea8841b34";
    # sha256 = "0ii78gna06gkkkw3qb774lfxxdh478ab8qligyglmiy6hxl4w00k";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig check openssl libpcap ];

  meta = with stdenv.lib; {

    homepage = https://bitbucket.org/bhesmans/mptcptrace.git;
    description = "Analyze MPTCP traces";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}

