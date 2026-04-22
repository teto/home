# TODO extend the nightly overlay devShell
{ pkgs, ... }:
pkgs.mkShell {
  name = "my-neovim";
  buildInputs = with pkgs; [
    yq
  ];

  shellHook = ''
    echo "Welcome to the neovim development environment!"
    echo "make lua-typecheck"
  '';
}
