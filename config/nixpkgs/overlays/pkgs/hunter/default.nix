{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "hunter";
  version = "1.1.4";
  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    rev = "v${version}";
    sha256 = "1pdzpglp1c8didgaq44fcx39bywqvif6vq8vnq2y9lg3gn9im6z3";
  };

  cargoSha256 = "169n8j7924x7mb5c0s0fkcyk7c931xx8qmqkqzmlqkjiw83q796d";

  doCheck = false;

  meta = {
    description = "Tools and libraries for manipulating subtitles";
    homepage = https://github.com/rabite0/hunter;
    license = stdenv.lib.licenses.wtfpl;
  };
}
