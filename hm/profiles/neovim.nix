{ config, pkgs, lib,  ... }:

let
  genBlock = title: content: lib.optionalString (content != null) ''
    " ${title} {{{
    ${content}
    " }}}
    '';

  rcBlocks = {
    wildBlock = ''
    set wildignore+=.hg,.git,.svn                    " Version control
    " set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
    set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
    set wildignore+=*.sw?                            " Vim swap files
    set wildignore+=*.luac                           " Lua byte code
    set wildignore+=*.pyc                            " Python byte code
    set wildignore+=*.orig                           " Merge resolution files
    '';

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

    highlight_yank = ''
      augroup highlight_yank
          autocmd!
          autocmd TextYankPost * lua require'vim.highlight'.on_yank{higroup="IncSearch", timeout=1000}
      augroup END
    '';
  };


  overlayPlugins = with pkgs.vimPlugins;[
    # https://github.com/vmchale/dhall-vim.git
    dhall-vim
    # {
    # }
      # TODO restore in my overlay
      # {
      #   # davidgranstrom/nvim-markdown-preview
      #   plugin = nvim-markdown-preview;
      #   config = ''
      #   '';
      # }
  ];

  # taken from the official flake
  myPackage = pkgs.neovim-debug;
in
{

  home.file."${config.xdg.configHome}/nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  # haskell treesitter is broken
  home.file."${config.xdg.configHome}/nvim/parser/haskell.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-haskell}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";

# nvim-lua/lsp_extensions.nvim


  programs.neovim = {
     enable = true;

     # take the one from the flake
     package = myPackage;

     # concatMap
     # source doesn't like `stdpath('config').'`
     # todo should use mkBefore
     #         ${config.programs.neovim.generatedInitrc}
     extraConfig = ''
        set noshowmode " Show the current mode on command line
        set cursorline " highlight cursor line
        source $XDG_CONFIG_HOME/nvim/init.manual.vim
      ''
      # concatStrings = builtins.concatStringsSep "";
      + (lib.strings.concatStrings (
        lib.mapAttrsToList genBlock rcBlocks
      ))
    ;

    # just for tests
    # configure = {
    #   customRC = ''test'';
    # };

    # extraLuaConfig = ''
    #   -- logs are written to /home/teto/.cache/vim-lsp.log
    #   vim.lsp.set_log_level("info")
    # '';

    # TODO add lsp stuff
    extraPackages = with pkgs; [
      # luaPackages.lua-lsp
      haskellPackages.hasktags
      jq
      nodePackages.bash-language-server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.pyright
      nodePackages.typescript-language-server
      pandoc  # for markdown preview, should be in the package closure instead
      pythonPackages.pdftotext  # should appear only in RC ?
      rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      # echodoc-vim

      # {
      #   # davidgranstrom/nvim-markdown-preview
      #   plugin = nvim-markdown-preview;
      #   config = ''
      #   '';
      # }
      # y a aussi vim-markdown
      {
        # euclio/vim-markdown-composer
        plugin = vim-markdown-composer;
        config = ''
        '';
      }

      # to install manually with coc.nvim:
      # - coc-vimtex  coc-snippets
      # use coc-yank for yank history
      {
        plugin = editorconfig-vim;
        config = ''
        '';
      }
      # {
      #   plugin = nvim-lspconfig;
      #   config = ''
      #   '';
      #   # not upstreamed yet
      #   # runtime = {
      #   #   "init.vim".text = ''
      #   #     '';
      #   #   "init.lua".text = ''
      #   #     -- TODO write config.lua; genere par home-manager
      #   #     '';
      #   # };
      # }
      {
        plugin = editorconfig-vim;
        # config = ''
        # '';
      }
      {
        plugin = far-vim;
        config = ''
          let g:far#source='rg'
          let g:far#collapse_result=1
        '';
      }
      # {
      #   plugin = telescope-nvim;
      # }
      {
        plugin = telescope-frecency-nvim;
      }
      {
        plugin = fzf-vim;
        config = ''
          let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
          let g:fzf_nvim_statusline = 0 " disable statusline overwriting

          " This is the default extra key bindings
          let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

          " Default fzf layout
          " - down / up / left / right
          " - window (nvim only)
          let g:fzf_layout = { 'down': '~40%' }

          " For Commits and BCommits to customize the options used by 'git log':
          let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

          " mostly fzf mappings, use TAB to mark several files at the same time
          " https://github.com/neovim/neovim/issues/4487
        '';
      }
          # nnoremap <Leader>o <Cmd>FzfFiles<CR>
          # " nnoremap <Leader>g <Cmd>FzfGitFiles<CR>
                # nnoremap <Leader>F <Cmd>FzfFiletypes<CR>
          # nnoremap <Leader>h <Cmd>FzfHistory<CR>
          # nnoremap <Leader>c <Cmd>FzfCommits<CR>
          # nnoremap <Leader>C <Cmd>FzfColors<CR>
          # nnoremap <leader>b <Cmd>FzfBuffers<CR>
          # nnoremap <leader>m <Cmd>FzfMarks<CR>
          # nnoremap <leader>l <Cmd>FzfLines<CR>
          # nnoremap <leader>t <Cmd>FzfTags<CR>
          # nnoremap <leader>T <Cmd>FzfBTags<CR>
          # nnoremap <leader>g <Cmd>FzfRg<CR>

      # defined in overrides: TODO this should be easier: like fzf-vim should be enough
      fzfWrapper
      gruvbox

      # neomake
      nvim-terminal-lua
      auto-git-diff   # display git diff while rebasing, pretty dope

      {
        plugin =  nvimdev-nvim;
        # optional = true;
      }

      # LanguageClient-neovim
      {
        plugin =  tagbar;
        optional = true;
      }
      # {
      #   plugin = fzf-preview;
      #   config = ''
      #     let g:fzf_preview_layout = $'''
      #     " Key to toggle fzf window size of normal size and full-screen
      #     let g:fzf_full_preview_toggle_key = '<C-s>'
      #   '';
      # }

      # targets-vim
      # vCoolor-vim
      # vim-CtrlXA
      {
        plugin = vim-dasht;
        # optional = true;
      }
      # displays a minimap on the right
      minimap-vim
      vim-dirvish
      packer-nvim
      # {
      #   plugin = sql-nvim;
      #   # config = "let g:sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
      # }
      # {
      #   plugin = vim-fugitive;
      #   config = ''
      #     '';
      # }
      # vim-signature

      {
        plugin = vim-signify;
        config = ''
          let g:signify_vcs_list = [ 'git']
          let g:signify_priority = 1000
          let g:signify_sign_add          = '▎'
          let g:signify_sign_delete       = '▎'
          let g:signify_sign_change       = '▎'
          let g:signify_sign_changedelete = '▎'

          let g:signify_cursorhold_insert     = 0
          let g:signify_cursorhold_normal     = 0
          let g:signify_update_on_bufenter    = 1
          let g:signify_update_on_focusgained = 1

        '';
      }
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
      {
        # TODO generate its runtime/init
        plugin = nvim-lspconfig;
        # config = ''
        # '';
      }

      # triggers errors when working on neovim
      # {
      #   plugin = vista-vim;
      #   # optional = false;
      #   config = ''

      #   '';
      # }

      # vimwiki

      # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
      # vimtex
      {
        plugin = unicode-vim;
        # let g:Unicode_data_directory = /home/user/data/
        # let g:Unicode_cache_directory = /tmp/

        # " let g:Unicode_cache_directory='${pkgs.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'
        config = ''
          let g:Unicode_data_directory='${pkgs.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'

          " overrides ga
          nmap ga <Plug>(UnicodeGA)
        '';
      }

    ];

  };
}
