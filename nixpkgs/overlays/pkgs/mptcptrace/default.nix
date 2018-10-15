{ stdenv, fetchFromBitbucket
, pkgconfig 
}:

stdenv.mkDerivation rec {
  name = "mptcptrace";
  version = "20180606";

  src = fetchFromBitbucket {
    owner = "bhesmans";
    repo = "mptcptrace";
    rev = "${version}";
    sha256 = "00q4ma5rvl10rkc6cdw8d69bddgrmvy0ckqj3hbisy65l4idj2zm";
  };

  buildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {

    homepage = https://bitbucket.org/bhesmans/mptcptrace.git;
    description = "Analyze MPTCP traces";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
