{
  pkgs,
  flakeSelf,
  lib,
  ...
}:
{

  programs.neovim = {
    neorg.enable = true;

    plugins = [
      # pkgs.vimPlugins.hex-nvim # to test runtimeDeps
    ];
  };
}
