{ pkgs, flakeSelf, ... }:
{

  programs.neovim.plugins = [
    # pkgs.vimPlugins.vim-dadbod-ui

    pkgs.vimPlugins.llm-nvim

    flakeSelf.inputs.rest-nvim.packages.${pkgs.system}.rest-nvim-dev
  ];
}
