{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "subtitles-rs";

  src = fetchFromGitHub {
    owner = "emk";
    repo = "subtitles-rs";
    rev = "f8a8b824070c1f397c4c22e4da7738562c147585";
    sha256 = "077ngy3qgdc4pggy9abwyv4by8fn1gcv8l3nvdlfh6nin569ppah";
  };

  cargoSha256 = "1851zf4pyi2mj4kq3w16abqi9izr6q9vznf4ap4mnfhaaplbc4x0";

  doCheck = false;

  meta = {
    description = "Tools and libraries for manipulating subtitles";
    homepage = https://github.com/emk/subtitles-rs;
    license = stdenv.lib.licenses.cc0;
  };
}
