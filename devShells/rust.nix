{ pkgs, ... }:
pkgs.mkShell {
  name = "rust";
  buildInputs = with pkgs; [
    cargo
    gcc
  ];

  shellHook = ''
    echo "Welcome to the Rust development environment!"
  '';
}
