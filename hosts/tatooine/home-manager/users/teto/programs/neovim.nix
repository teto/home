{
  pkgs,
  flakeSelf,
  lib,
  ...
}:
{

  programs.neovim = {

    plugins = [
      # pkgs.vimPlugins.hex-nvim # to test runtimeDeps
    ];
  };
}
