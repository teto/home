{ stdenv, fetchurl, numactl, lib }:

stdenv.mkDerivation {
  name = "re-tests";
  version = "1.0";
  src = fetchurl {
    url = "https://mirrors.edge.kernel.org/pub/linux/utils/rt-tests/rt-tests-1.0.tar.gz";
    sha256 = "0zzyyl5wwvq621gwjfdrpj9mf3gy003hrhqry81s1qmv7m138v5v";
  };

  nativeBuildInputs = [ numactl ];
  # prefix is not passed when installing apparently

  meta = with lib; {
    homepage = "https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/rt-tests";
    description = "Linux latency analysis";
    license = licenses.gpl2;
    maintainers = [ maintainers.teto ];
    platforms = platforms.linux;
  };
}
