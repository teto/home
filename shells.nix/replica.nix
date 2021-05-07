with import <nixpkgs> {};

let
  idris2-dev = pkgs.idris2.overrideAttrs(oa: {
    src = fetchFromGitHub {
      owner = "idris-lang";
      repo = "Idris2";
      rev = "4b7d85653a422597a580c1ac9039b45456825f05";
      sha256 = "sha256-55fa53qV2m84TM+pf4AYbMKVF9pQWm8L3SDe4/co8e0=";
    };
  });

  in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      idris2-dev
      # haskellPackages.dhall-json
    ];
  }

