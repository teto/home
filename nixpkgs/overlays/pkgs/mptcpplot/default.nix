{ stdenv, fetchFromGitHub
, pkgconfig 
, openssl # for libcrypto
, libpcap
}:

stdenv.mkDerivation rec {
  name = "mptcpplot";
  version = "20190207";

  # FATAL we need to keep a git repo
  # src = /home/teto/mptcpplot;

  src = fetchFromGitHub {
    owner = "nasa";
    repo = "multipath-tcp-tools";
    rev = "57998fd9d1b03466ad75d601cfa585a18a4b0c6c";
    sha256 = "1wy7lkh8d1a64ihh75yq7r6hajzrwylpccxcjkzmv8np9ycdmxg6";

  #   # leaveDotGit = true;
  #   #  deepClone = true;

  #   # dvlp branch => ne compile pas
  #   # rev = "19ef5c6ecf3e25844a53d2980e0cb9aea8841b34";
  #   # sha256 = "0ii78gna06gkkkw3qb774lfxxdh478ab8qligyglmiy6hxl4w00k";
  };

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
