{ flakeSelf, lib, ... }:
let
  nix-builders = import ./nix-builder.nix  { inherit flakeSelf lib; };
  neovim = import ./neovim.nix  { inherit flakeSelf lib; };
in
{
  inherit
    nix-builders
    neovim
    ;

  inherit (neovim)
    genBlockLua
    luaPlugin
    ;

  inherit (nix-builders)
    deployrsNodeToBuilderAttr
    ;
}
