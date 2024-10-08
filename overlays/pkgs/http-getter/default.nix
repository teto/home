{
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  pkgconfig,
  lib,
}:

stdenv.mkDerivation rec {
  name = "http-getter";
  version = "20180606";

  src = fetchFromGitHub {
    owner = "tohojo";
    repo = "http-getter";
    rev = "79bcccce721825a745f089d0c347bbaf2e6e12f4";
    sha256 = "1zxk52s1h5qx62idil237zdpj8agrry0w1xwkfx05wvv9sw4ld35";
  };

  buildInputs = [
    cmake
    pkgconfig
    curl
  ];

  meta = with lib; {
    homepage = "https://github.com/tohojo/http-getter";
    description = "Simple getter for HTTP URLs using cURL";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
