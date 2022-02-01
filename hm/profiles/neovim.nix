{ config, pkgs, lib,  ... }:

let
  genBlock = title: content: lib.optionalString (content != null) ''
    " ${title} {{{
    ${content}
    " }}}
    '';

  rcBlocks = {

    appearance = ''
      " draw a line on 80th column
      set colorcolumn=80,100
    '';

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
      set fillchars+=foldopen:▾
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


  myVimPluginsOverlay = pkgs.callPackage ../../nixpkgs/overlays/vim-plugins/generated.nix {
    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  };

  myVimPlugins = pkgs.vimPlugins.extend (
    myVimPluginsOverlay
  );

  luaPlugins = with pkgs.vimPlugins; [
    {

      plugin = (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-lua
            tree-sitter-json
            tree-sitter-nix
            # tree-sitter-haskell # crashes with a loop
            tree-sitter-python
            tree-sitter-html  # for rest.nvim
            tree-sitter-norg
            # tree-sitter-org
          ]
        ));
    }
    # {
    #   plugin = nvim-dap;
    # }
    {
      plugin = lightspeed-nvim;
    }
    {
      plugin = auto-git-diff;
    }
    {
      plugin = plenary-nvim;
    }
    {
      plugin = gitsigns-nvim;
      type = "lua";
      config = ''
        require 'gitsigns'.setup {
            -- -- '│' passe mais '▎' non :s
        signs = {
            add          = {hl = 'GitSignsAdd'   , text ='▎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
            change       = {hl = 'GitSignsChange', text ='▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
            delete       = {hl = 'GitSignsDelete', text ='▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            topdelete    = {hl = 'GitSignsDelete', text ='▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text ='▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          },
          numhl = false,
          linehl = false,
          keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,

            -- ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
            -- ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

            -- ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            -- ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            -- ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            -- ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            -- ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
          },
          watch_gitdir = {
            interval = 1000,
            follow_files = true
          },
          current_line_blame = false,
          current_line_blame_opts = {
                delay = 1000,
                virt_text_pos = 'eol'
            },
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil, -- Use default
          word_diff = true,
          diff_opts = {
              internal = false
          }  -- If luajit is present
        }'';

    }
    # {
    #   plugin = fidget-nvim;
    #   type = "lua";
    #   config = ''
    #     require"fidget".setup{}
    #   '';
    # }

    {
      plugin = lsp_lines-nvim;
      type = "lua";
      config = ''
        require("lsp_lines").register_lsp_virtual_lines()
        '';
    }
    {
      plugin = marks-nvim;
      type = "lua";
      config = ''
	require'marks'.setup {
		-- whether to map keybinds or not. default true
		default_mappings = true,
		-- which builtin marks to show. default {} but available:  ".", "<", ">", "^"
		builtin_marks = {},
		-- whether movements cycle back to the beginning/end of buffer. default true
		cyclic = true,
		-- whether the shada file is updated after modifying uppercase marks. default false
		force_write_shada = false,
		-- how often (in ms) to redraw signs/recompute mark positions.
		-- higher values will have better performance but may cause visual lag,
		-- while lower values may cause performance penalties. default 150.
		refresh_interval = 250,
		-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
		-- marks, and bookmarks.
		-- can be either a table with all/none of the keys, or a single number, in which case
		-- the priority applies to all marks.
		-- default 10.
		sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
		-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
		-- sign/virttext. Bookmarks can be used to group together positions and quickly move
		-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
		-- default virt_text is "".
		bookmark_0 = {
			sign = "⚑",
			virt_text = "hello world"
		},
		mappings = {}
	}
      '';

    }
    # {
      # not packaged yet
  # Plug 'bfredl/nvim-miniyank' " killring alike plugin, cycling paste careful search for :Yank commands
  # hangs with big strings
    #   plugin = nvim-miniyank;
    #   config = 
    #   ''
# let g:miniyank_delete_maxlines=100

# let g:miniyank_filename = $XDG_CACHE_HOME."/miniyank.mpack"
# " map p <Plug>(miniyank-autoput)
# " map P <Plug>(miniyank-autoPut)


# function! FZFYankList() abort
  # function! KeyValue(key, val)
    # let line = join(a:val[0], '\n')
    # if (a:val[1] ==# 'V')
    #   let line = '\n'.line
    # endif
    # return a:key.' '.line
  # endfunction
  # return map(miniyank#read(), function('KeyValue'))
# endfunction

# function! FZFYankHandler(opt, line) abort
  # let key = substitute(a:line, ' .*', '', '')
  # if !empty(a:line)
    # let yanks = miniyank#read()[key]
    # call miniyank#drop(yanks, a:opt)
  # endif
# endfunction

# command! YanksAfter call fzf#run(fzf#wrap('YanksAfter', {
# \ 'source':  FZFYankList(),
# \ 'sink':    function('FZFYankHandler', ['p']),
# \ 'options': '--no-sort --prompt="Yanks-p> "',
# \ }))

# command! YanksBefore call fzf#run(fzf#wrap('YanksBefore', {
# \ 'source':  FZFYankList(),
# \ 'sink':    function('FZFYankHandler', ['P']),
# \ 'options': '--no-sort --prompt="Yanks-P> "',
# \ }))

# map <A-p> <Cmd>YanksAfter<CR>
# map <A-P> <Cmd>YanksBefore<CR>
# '';

    # }
    vim-lion # Use with gl/L<text object><character to align to 
    vim-vsnip
    vim-vsnip-integ
      {
      plugin = nvim-spectre;
    }
    {
      plugin = tokyonight-nvim;
    }
    # broken for now
    {
      plugin = telescope-fzf-native-nvim;
    }
    {
      plugin = registers-nvim;
      # use :Registers
    }


    # broken
    # {
    #   plugin = nvim-compe;
    # }
    {
      plugin = telescope-frecency-nvim;
    }
    # {
    #   plugin = neogit;
    #   config = ''
    #     " -- neogit config
    #   '';
    # }
  ];

  basePlugins = with pkgs.vimPlugins; [

      # {
      #   # davidgranstrom/nvim-markdown-preview
      #   plugin = nvim-markdown-preview;
      #   config = ''
      #   '';
      # }
      # y a aussi vim-markdown
      idris-vim
      # TODO package
      # astronauta
      {
        # euclio/vim-markdown-composer
        plugin = vim-markdown-composer;
        config = ''
          " use with :ComposerStart
          let g:markdown_composer_autostart = 0
        '';
      }
      {
        plugin = gruvbox-nvim;
        config = ''
          " test if gruvbox is installed

        '';
      }
      {
        plugin = dhall-vim;
        config = ''
          " dhall.vim config
        '';
      }
      {
        plugin = nvim-orgmode;
        type = "lua";
      }
      {
        plugin = vim-toml;
      }
      # {
      #   plugin = onedark-nvim;
      # }
      # to install manually with coc.nvim:
      {
        plugin = editorconfig-vim;
        # config = ''
        #   " dhall.vim config
        # '';
      }
      # {
      #   plugin = jbyuki/venn.nvim;
      # }
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

      # {
      #   plugin = far-vim;
      #   config = ''
      #     let g:far#source='rg'
      #     let g:far#collapse_result=1
      #   '';
      # }

      # {
      #   plugin = telescope-nvim;
      # }
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
      {
        plugin = packer-nvim;
        type = "lua";
		config = ''
          require('packer').init({
            luarocks = {
              python_cmd = 'python' -- Set the python command to use for running hererocks
            },
          })
        '';
      }
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

      # {
      #   plugin = vim-signify;
      #   config = ''
      #     let g:signify_vcs_list = [ 'git']
      #     let g:signify_priority = 1000
      #     "let g:signify_line_color_add    = 'DiffAdd'
      #     "let g:signify_line_color_delete = 'DiffDelete'
      #     "let g:signify_line_color_change = 'DiffChange'
      #     let g:signify_sign_add          = '▎'
      #     let g:signify_sign_delete       = '▎'
      #     let g:signify_sign_change       = '▎'
      #     let g:signify_sign_changedelete = '▎'
      # let g:signify_line_highlight = 0 " display added/removed lines in different colors
      # let g:signify_sign_show_text = 1
      # let g:signify_sign_show_count= 0
      #     let g:signify_cursorhold_insert     = 0
      #     let g:signify_cursorhold_normal     = 0
      #     let g:signify_update_on_bufenter    = 1
      #     let g:signify_update_on_focusgained = 1

      #   '';
      # }

      {
        plugin = vim-startify;
        config = ''
          let g:startify_use_env = 0
          let g:startify_disable_at_vimenter = 0
          let g:startify_session_dir = stdpath('data').'/nvim/sessions'
        '';
      }

      vim-scriptease
      # test with hop ?
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
          nnoremap <leader>rg  <Cmd>Grepper -tool git -open -switch<CR>
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
        # testing luaConfig (experimental)
        # luaConfig = ''
        #   -- vim-obsession config
        # '';
      }
      # ctrl-e causes an issue with telescope prompt
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
      {
        plugin = nvim-spectre;
      }

      # vim-markdown-preview  # WIP
      {
        plugin = vim-commentary;
        config = ''
          '';
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

  # Usage:
  # pkgs.tree-sitter.withPlugins (p: [ p.tree-sitter-c p.tree-sitter-java ... ])
  #
  # or for all grammars:
  # pkgs.tree-sitter.withPlugins (_: allGrammars)
  # which is equivalent to
  # pkgs.tree-sitter.withPlugins (p: builtins.attrValues p)
  overlayPlugins = with myVimPlugins; [
    # octo-nvim
    # pkgs.vimPlugins.telescope-fzf-native-nvim
  # {
  #     plugin = virtual-types-nvim;
  #   }

      # TODO restore in my overlay
      # {
      #   # davidgranstrom/nvim-markdown-preview
      #   plugin = nvim-markdown-preview;
      #   config = ''
      #   '';
      # }
  ];

  # taken from the official flake
  myPackage = pkgs.neovim;
in
{

  #  extraLuaPackages = ps: [ps.mpack];
  programs.neovim = {
    enable = true;

    # take the one from the flake
    package = myPackage;

    # source doesn't like `stdpath('config').'`
    # todo should use mkBefore ${config.programs.neovim.generatedInitrc}
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
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.pyright
      nodePackages.typescript-language-server
      pandoc  # for markdown preview, should be in the package closure instead
      # pythonPackages.pdftotext  # should appear only in RC ? broken
      rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];

    plugins = basePlugins
      ++ overlayPlugins
      ++ luaPlugins;
  };

  xdg.configFile = {
    # a copy of init.vim in fact
    "nvim/init.generated.vim".text = config.programs.neovim.generatedConfigViml;
    "nvim/init.generated.lua".text = config.programs.neovim.generatedConfigs.lua;
  };
}
