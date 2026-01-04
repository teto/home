{ pkgs, flakeSelf, ... }:
{

  programs.neovim.plugins = [
    # pkgs.vimPlugins.hex-nvim # to test runtimeDeps
  ];
}
