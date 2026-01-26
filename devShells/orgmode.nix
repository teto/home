{ lib, pkgs, ... }:
pkgs.mkShell {
  name = "orgmode";
  buildInputs = with pkgs; [
    lua5_1.pkgs.luacheck
    lua5_1.pkgs.busted
    lua5_1.pkgs.nlua
    pkgs.tree-sitter-grammars.tree-sitter-org-nvim
    # stylua
  ];

  # TODO need to address the LUA_PATH
  # will need plenary /
  shellHook = ''
    echo "hello world";
    echo "Busted must be run sequentially in teto/fix-busted branch"
    export LUA_PATH="lua/?.lua;lua/?/init.lua;$LUA_PATH"
  '';

}
