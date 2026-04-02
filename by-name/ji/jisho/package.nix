{
  rustPlatform,
  lib,
  pkgs,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jisho";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "eagleflo";
    repo = "jisho";
    rev = "78c06c66d1089f66c5cba4171629875ca9d1cd55";
    sha256 = "sha256-lNUyPoZ9XY5kE+vRuLgXj5BhYnasDeOj00O07JZti1Y=";
  };

  cargoHash = "sha256-d+khnCcnQSAZdXH9Fly+QSGWO1rTvAsgs4PIbvDObCs=";

  meta = with lib; {
    description = "A Rust program called jisho";
    homepage = "https://github.com/eagleflo/jisho";
    license = licenses.mit;
  };
}
