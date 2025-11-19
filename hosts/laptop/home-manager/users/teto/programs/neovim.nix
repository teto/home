{ pkgs, flakeSelf, ... }:
{

  programs.neovim.plugins = [
    # pkgs.vimPlugins.vim-dadbod-ui

    pkgs.vimPlugins.llm-nvim

    flakeSelf.inputs.rest-nvim.packages.${pkgs.stdenv.hostPlatform.system}.rest-nvim-dev
  ];
}
