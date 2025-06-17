{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "kagome";
  version = "latest";

  src = fetchFromGitHub {
    owner = "ikawaha";
    repo = "kagome";
    rev = "master";
    hash = "sha256-NfEOZ+yJq+9ucnI7i8X4cEF6BhYK/EnD6BJSNusEcdM=";
  };

  vendorHash = null; # "sha256-R+pW3xcfpkTRqfS2ETVOwG7PZr0iH5ewroiF7u8hcYI=";

  meta = with lib; {
    description = "Kagome: a Pure Go Japanese Morphological Analyzer";
    homepage = "https://github.com/ikawaha/kagome";
    license = licenses.mit;
    maintainers = [ ];
  };
}

