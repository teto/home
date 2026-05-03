{ pkgs, ... }:
pkgs.mkShell {
  name = "avante";
  buildInputs =
    let
      mylua = pkgs.lua5_1.withPackages (lp: [
        lp.luassert
        lp.busted
      ]);
    in
    with pkgs;
    [
      lua5_1.pkgs.luacheck
      lua-language-server # not using emmy yet
      yq
      # needed for 'luatest'
      pkgs.silver-searcher
      pkgs.python3
      pkgs.docker
      pkgs.stylua
      mylua
      # missing 'ruststylecheck'
    ];

  shellHook = ''
    echo "Welcome to the avante development environment!"
    export DEPS_PATH="$PWD/target/tests"
  '';
}
