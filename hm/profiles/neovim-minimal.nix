{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;
    vimAlias = false;
    highlightOnYank = true;
    plugins = with pkgs.vimPlugins; [
      # vim-colorschemes
      # {
      #   plugin = vimtex;
      #   config = ''
      #     let g:vimtex_view_method = 'zathura'
      #     let g:vimtex_quickfix_ignore_filters = ['Package unicode-math Warning']
      #     let g:tex_flavor = 'latex'
      #   '';
      # }
      vim-nix
    ];

    extraLuaConfig = lib.mkBefore (
      ''
        vim.g.mapleader = ' '

        vim.opt.hidden = true -- you can open a new buffer even if current is unsaved (error E37) =
        vim.opt.number = true
        vim.opt.relativenumber = true
      '');

    extraConfig = ''
      set shiftwidth=4
      set expandtab
      set autoindent
      filetype plugin indent on

      autocmd FileType tex setlocal shiftwidth=2 textwidth=79
      autocmd FileType nix setlocal shiftwidth=2
    '';
  };

  # home.sessionVariables.EDITOR = "nvim";
  # home.sessionVariables.VISUAL = "nvim";
}
