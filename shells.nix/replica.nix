with import <nixpkgs> {};

pkgs.mkShell {
  buildInputs = with pkgs; [
    idris2
    # haskellPackages.dhall-json
  ];
}

