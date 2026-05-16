{
  pkgs,
  flakeSelf,
  lib,
  ...
}:
{

  neorg.enable = true;

  plugins = [
    # pkgs.vimPlugins.hex-nvim # to test runtimeDeps
  ];
}
