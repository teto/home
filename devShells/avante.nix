{ pkgs, ... }:
pkgs.mkShell {
  name = "avante";
  buildInputs = with pkgs; [
    luacheck
    yq
  ];

  shellHook = ''
    echo "Welcome to the avante development environment!"
  '';
}
