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


# " , { 'tag': 'v3.12.0' }
# Plug 'Olical/aniseed' " dependency of ?
# Plug 'bakpakin/fennel.vim'
  fennelPlugins = with pkgs.vimPlugins; [
    # {
	  # # currently broken
	  # # > E154: Duplicate tag "module" in file /nix/store/j5vacr79vpxn874361wf25qjqxxj162h-vimplugin-aniseed-2022-02-15/./doc/aniseed.txt
    #    # > E154: Duplicate tag "module" in file /nix/store/j5vacr79vpxn874361wf25qjqxxj162h-vimplugin-aniseed-2022-02-15/./doc/aniseed.txt
    #    # > E154: Duplicate tag "module" in file /nix/store/j5vacr79vpxn874361wf25qjqxxj162h-vimplugin-aniseed-2022-02-15/./doc/aniseed.txtFailed to build help tags!
    #   plugin = aniseed;
# # " let g:aniseed#env = v:true
# # " lua require('aniseed.env').init()

    # }

  ];
  luaPlugins = with pkgs.vimPlugins; [
    {

      plugin = (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-lua
            tree-sitter-http
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
    # {
    #   plugin = lightspeed-nvim;
    # }
    {
      plugin = trouble-nvim;
      type = "lua";
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
      config = ''
        let g:registers_return_symbol = "\n" "'⏎' by default
        let g:registers_tab_symbol = "\t" "'·' by default
        let g:registers_space_symbol = "." "' ' by default
        let g:registers_delay = 500 "0 by default, milliseconds to wait before opening the popup window
        let g:registers_register_key_sleep = 1 "0 by default, seconds to wait before closing the window when a register key is pressed
        let g:registers_show_empty_registers = 0 "1 by default, an additional line with the registers without content
        let g:registers_trim_whitespace = 0 "1 by default, don't show whitespace at the begin and end of the registers
        let g:registers_hide_only_whitespace = 1 "0 by default, don't show registers filled exclusively with whitespace
        let g:registers_window_border = "single" "'none' by default, can be 'none', 'single','double', 'rounded', 'solid', or 'shadow' (requires Neovim 0.5.0+)
        let g:registers_window_min_height = 10 "3 by default, minimum height of the window when there is the cursor at the bottom
        let g:registers_window_max_width = 20 "100 by default, maximum width of the window
        '';
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
    # Packer should remain first
    {
      plugin = packer-nvim;
      type = "lua";
      config = ''
      require('packer').init({
        luarocks = {
          python_cmd = 'python' -- Set the python command to use for running hererocks
        },
      })
      require('init-manual')
      '';
    }

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
        plugin = stylish-nvim;
        type = "lua";
        config = ''
        '';
      }
      {
        plugin = rest-nvim;
        type = "lua";
        config = ''
          require("rest-nvim").setup({
            -- Open request results in a horizontal split
            result_split_horizontal = false,
            -- Skip SSL verification, useful for unknown certificates
            skip_ssl_verification = false,
            -- Highlight request on run
            highlight = {
                    enabled = true,
                    timeout = 150,
            },
            result = {
                    -- toggle showing URL, HTTP info, headers at top the of result window
                    show_url = true,
                    show_http_info = true,
                    show_headers = true,
            },
            -- Jump to request line on run
            jump_to_request = false,
          })
          vim.keymap.set('n',  "<leader>rr" , "<Plug>RestNvim", { expr = true} )
          vim.keymap.set('n',  "<leader>rp" , "<Plug>RestNvimPreview", { expr = true} )
        '';
      }
      {
        # matches nvim-orgmode
        plugin = orgmode;
        type = "lua";
        config = ''
        require('orgmode').setup{
            org_agenda_files = {'~/nextcloud/org/*', '~/orgmode/**/*'},
            org_default_notes_file = '~/orgmode/refile.org',
        }
        '';
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
      {
        plugin = nvim-terminal-lua;
        # optional = true;
      }
      {
        plugin = auto-git-diff;   # display git diff while rebasing, pretty dope
      }

      {
        plugin =  nvimdev-nvim;
        # optional = true;
      }

      # LanguageClient-neovim
      # {
      #   plugin =  tagbar;
      #   optional = true;
      # }
      # {
      #   plugin = fzf-preview;
      #   config = ''
      #     let g:fzf_preview_layout = $'''
      #     " Key to toggle fzf window size of normal size and full-screen
      #     let g:fzf_full_preview_toggle_key = '<C-s>'
      #   '';
      # }
      {
        plugin = vim-dasht;
        # optional = true;
      }
      # displays a minimap on the right
      minimap-vim
      vim-dirvish
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
        type = "lua";
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

  overlayPlugins = with myVimPlugins; [
    # octo-nvim
    # pkgs.vimPlugins.telescope-fzf-native-nvim
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
      ++ luaPlugins
      ++ fennelPlugins
      ;
  };

  xdg.configFile = {
    # a copy of init.vim in fact
    # "nvim/init.generated.vim".text = config.programs.neovim.generatedConfigViml;
    # "nvim/init.generated.lua".text = config.programs.neovim.generatedConfigs.lua;
  };
}
