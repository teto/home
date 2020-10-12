{ config, pkgs, lib,  ... }:

let

  genBlock = title: content:
      '' " 
    '';


  rcBlocks = {
    foldBlock = ''
      " block,hor,mark,percent,quickfix,search,tag,undo
      " set foldopen+=all " specifies commands for which folds should open
      " set foldclose=all
      "set foldtext=
      set fillchars+=foldopen:▾,foldsep:│
      set fillchars+=foldclose:▸
      set fillchars+=msgsep:‾
      hi MsgSeparator ctermbg=black ctermfg=white

      set fdc=auto:2
    '';
  };


in
{

  home.file."${config.xdg.configHome}/nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.c}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.bash}/parser";

  programs.neovim = {
     enable = true;
     package = pkgs.neovim-unwrapped-master;

     extraConfig = ''
        set noshowmode " Show the current mode on command line
        set cursorline " highlight cursor line
    '';

    # TODO add lsp stuff
    # extraPackages =  [
    # ];

    plugins = with pkgs.vimPlugins; [
      # echodoc-vim

      # to install manually with coc.nvim:
      # - coc-vimtex  coc-snippets 
      # use coc-yank for yank history
      editorconfig-vim
      # replaced by coc
      far-vim

      # fails with   python module. Run `pip install neovim` to fix. For more info, :he nvim-python"
      # floobits-neovim

      {
        plugin = fzf-vim;
        config = ''
          let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
          let g:fzf_nvim_statusline = 0 " disable statusline overwriting
        '';
      }
      # defined in overrides: TODO this should be easier: like fzf-vim should be enough
      fzfWrapper
      gruvbox

      # neomake
      nvim-terminal-lua


      # LanguageClient-neovim
      tagbar
      # targets-vim
      # vCoolor-vim
      # vim-CtrlXA
      vim-dasht
      vim-dirvish
      # vim-fugitive
      vim-signature
      vim-signify
      vim-startify
      vim-scriptease
      vim-sneak
      {
        plugin = vim-grepper;
        config = ''
          nnoremap <leader>rg  <Cmd>Grepper -tool rg -open -switch<CR>
          nnoremap <leader>rgb  <Cmd>Grepper -tool rg -open -switch -buffer<CR>
          " TODO add 
          vnoremap <leader>rg  <Cmd>Grepper -tool rg -open -switch<CR>
        '';
      }
      vim-nix
      {
        plugin = vim-obsession;

        config = ''
          map <Leader>$ <Cmd>Obsession<CR>
        '';
      }
      vim-rsi
      {
        plugin = vim-sayonara;
        config = ''
          nnoremap <silent><leader>Q  <Cmd>Sayonara<cr>
          nnoremap <silent><leader>q  <Cmd>Sayonara!<cr>

          let g:sayonara_confirm_quit = 0
        '';
      }
      # TODO this one will be ok once we patch it
      # vim-markdown-composer  # WIP

      # vim-livedown
      # markdown-preview-nvim # :MarkdownPreview
      # nvim-markdown-preview  # :MarkdownPreview

      # vim-markdown-preview  # WIP
      {
        plugin = vim-commentary;
        config = ''
          '';
      }

      # vimwiki

      # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
      # vimtex
      unicode-vim
    ];

  };
}
