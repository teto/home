{ pkgs, ... }:
pkgs.mkShell {
  name = "rust";
  buildInputs = with pkgs; [
    cargo
    pkg-config
    openssl
    gcc
  ];

  shellHook = ''
    echo "Welcome to the Rust development environment!"
  '';
}
