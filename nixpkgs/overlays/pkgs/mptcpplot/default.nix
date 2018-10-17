{ stdenv, fetchFromGitHub
, pkgconfig 
, autoreconfHook
, check
, openssl # for libcrypto
, libpcap
}:

stdenv.mkDerivation rec {
  name = "mptcpplot";
  version = "20180606";

  # FATAL we need to keep a git repo
  src = fetchFromGitHub {
    owner = "nasa";
    repo = "multipath-tcp-tools";
    rev = "9efc6619910537d6705fa9cb97996ddb4dbebf7d";
    sha256 = "10claj0x5gqmbn0zjz251hns43zl92d9rsrri1hx28p31l23pfg0";

    # leaveDotGit = true;
    #  deepClone = true;

    # dvlp branch => ne compile pas
    # rev = "19ef5c6ecf3e25844a53d2980e0cb9aea8841b34";
    # sha256 = "0ii78gna06gkkkw3qb774lfxxdh478ab8qligyglmiy6hxl4w00k";
  };

  # setSourceRoot 
  # sourceRoot="network-traffic-analysis-tools";

  nativeBuildInputs = [ autoreconfHook pkgconfig check openssl libpcap ];

  meta = with stdenv.lib; {

    homepage = https://github.com/nasa/multipath-tcp-tools;
    description = "Analyze MPTCP traces";
    platforms = platforms.unix;
    # NASA OPEN SOURCE AGREEMENT VERSION 1.3O
    # https://github.com/nasa/multipath-tcp-tools/blob/master/LICENSE
    license = licenses.gpl3;
  };
}
