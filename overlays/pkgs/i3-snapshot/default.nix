{ stdenv, lib, fetchFromGitHub, jsoncpp, libsigcxx, i3, cmake, pkg-config, zlib }:

stdenv.mkDerivation rec {
  pname = "i3-snapshot";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3-snapshot";
    rev = "v${version}";
    sha256 = "07yk9sx7kdigh1z9jlk7d8pm6ig8kqvml2x1ikrcw901z0xh12qd";
    fetchSubmodules = true;
  };

  # for ipc.h
  nativeBuildInputs = [ i3 cmake pkg-config ];
  buildInputs = [ jsoncpp libsigcxx zlib ];

  meta = with lib; {
    homepage = https://github.com/regolith-linux/i3-snapshot;
    description = "Record and restore window and workspace containment structure in i3-wm.";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.teto ];
  };
}


