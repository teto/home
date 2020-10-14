{ config, pkgs, lib,  ... }:

let

  genBlock = title: content: ''
    " ${title} {{{
    ${content}
    " }}}
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

    sessionoptions = ''
      set sessionoptions-=terminal
      set sessionoptions-=help
    '';
  };


in
{

  home.file."${config.xdg.configHome}/nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.c}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.bash}/parser";

  programs.neovim = {
     enable = true;
     package = pkgs.neovim-unwrapped-master;

     # concatMap
     extraConfig = ''
        set noshowmode " Show the current mode on command line
        set cursorline " highlight cursor line
    '';

    # TODO add lsp stuff
    extraPackages = with pkgs; [
      pkgs.jq
      nodePackages.bash-language-server
      luaPackages.lua-lsp
      yaml-language-server
      # dockerfile-language-server-nodejs
    ];

    plugins = with pkgs.vimPlugins; [
      # echodoc-vim

      # to install manually with coc.nvim:
      # - coc-vimtex  coc-snippets 
      # use coc-yank for yank history
      {
        plugin = editorconfig-vim;
        config = ''
        '';
      }
      far-vim

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
      {
        plugin = vim-startify;
        config = ''
          let g:startify_use_env = 0
          let g:startify_disable_at_vimenter = 0
          let g:startify_session_dir = stdpath('data').'/nvim/sessions'
        '';
      }

      vim-scriptease
      {
        plugin = vim-sneak;
        config = ''
          let g:sneak#s_next = 1 " can press 's' again to go to next result, like ';'
          let g:sneak#prompt = 'Sneak>'

          let g:sneak#streak = 0

          map f <Plug>Sneak_f
          map F <Plug>Sneak_F
          map t <Plug>Sneak_t
          map T <Plug>Sneak_T
        '';
      }
      {
        plugin = vim-grepper;
        config = ''
          nnoremap <leader>rg  <Cmd>Grepper -tool rg -open -switch<CR>
          nnoremap <leader>rgb  <Cmd>Grepper -tool rg -open -switch -buffer<CR>
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
      {
        plugin = unicode-vim;
        config = ''
          " overrides ga
          nmap ga <Plug>(UnicodeGA)
        '';
      }

    ];

  };
}
