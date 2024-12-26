{ pkgs, ... }:
{

  plugins = [
    pkgs.vimPlugins.vim-dadbod-ui

    pkgs.vimPlugins.llm-nvim
  ];
}
