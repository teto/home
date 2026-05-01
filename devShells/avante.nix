{ pkgs, ... }:
pkgs.mkShell {
  name = "avante";
  buildInputs = with pkgs; [
    lua5_1.pkgs.luacheck
    lua-language-server # not using emmy yet
    yq
    # needed for 'luatest'
    pkgs.silver-searcher
    pkgs.python3
    pkgs.docker
    pkgs.stylua
    # missing 'ruststylecheck'
  ];

  shellHook = ''
    echo "Welcome to the avante development environment!"
    export DEPS_PATH="$PWD/target/tests"
  '';
}
