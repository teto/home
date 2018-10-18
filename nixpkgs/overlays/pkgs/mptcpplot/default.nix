{ stdenv, fetchFromGitHub
, pkgconfig 
, openssl # for libcrypto
, libpcap
}:

stdenv.mkDerivation rec {
  name = "mptcpplot";
  version = "20180606";

  # FATAL we need to keep a git repo
  src = /home/teto/mptcpplot;
  # src = fetchFromGitHub {
  #   owner = "nasa";
  #   repo = "multipath-tcp-tools";
  #   rev = "9efc6619910537d6705fa9cb97996ddb4dbebf7d";
  #   sha256 = "0f5zpb555mipp7224amhf59hg61cg61nscm6qw2p2k1yqbdqzxz2";

  #   # leaveDotGit = true;
  #   #  deepClone = true;

  #   # dvlp branch => ne compile pas
  #   # rev = "19ef5c6ecf3e25844a53d2980e0cb9aea8841b34";
  #   # sha256 = "0ii78gna06gkkkw3qb774lfxxdh478ab8qligyglmiy6hxl4w00k";
  # };

  setSourceRoot = "export sourceRoot=$(echo */network-traffic-analysis-tools)";
  # sourceRoot="*/network-traffic-analysis-tools";
  installFlags = [ "PREFIX=$(out)" ];

  # autoreconfHook 
  nativeBuildInputs = [ pkgconfig openssl libpcap ];

  meta = with stdenv.lib; {

    homepage = https://github.com/nasa/multipath-tcp-tools;
    description = "Analyze MPTCP traces";
    platforms = platforms.unix;
    # NASA OPEN SOURCE AGREEMENT VERSION 1.3O
    # https://github.com/nasa/multipath-tcp-tools/blob/master/LICENSE
    license = licenses.gpl3;
  };
}
