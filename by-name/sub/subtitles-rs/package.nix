{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
}:

rustPlatform.buildRustPackage {
  pname = "subtitles-rs";
  version = "0-unstable-2017-02-14";

  src = fetchFromGitHub {
    owner = "emk";
    repo = "subtitles-rs";
    rev = "f8a8b824070c1f397c4c22e4da7738562c147585";
    hash = "sha256-D3fHG6efMfDZ0wajbqRMtZvxR94yQfnw9WUUC3YE0gU=";
  };

  cargoHash = "sha256-GUosXIUBltJi+FIVzEfnPWRm93epgW/2FJbU0czn8kQ=";

  doCheck = false;

  meta = {
    description = "Tools and libraries for manipulating subtitles";
    homepage = "https://github.com/emk/subtitles-rs";
    license = lib.licenses.cc0;
  };
}
