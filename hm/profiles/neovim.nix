{ config, pkgs, lib, ... }:

let
  luaPlugin = attrs: attrs // {
    type = "lua";
    config = lib.optionalString (attrs ? config && attrs.config != null) (genBlockLua attrs.plugin.pname attrs.config);
  };

  genBlockLua = title: content: 
   ''
   -- ${title} {{{
   ${content}
   -- }}}
   '';

  luaRcBlocks = {
    appearance = ''
		-- draw a line on 80th column
		vim.o.colorcolumn='80,100'
      	'';

    # hi MsgSeparator ctermbg=black ctermfg=white
    # TODO equivalent of       set fillchars+=
    foldBlock = ''
		vim.o.fillchars='foldopen:▾,foldclose:▸,msgsep:‾'
		vim.o.foldcolumn='auto:2'
      	'';
    # dealingwithpdf= ''
    #   " Read-only pdf through pdftotext / arf kinda fails silently on CJK documents
    #   " autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

    #   " convert all kinds of files (but pdf) to plain text
    #   autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
    # '';

    # sessionoptions = ''
    #   set sessionoptions-=terminal
    #   set sessionoptions-=help
    # '';
  };

  myVimPluginsOverlay = pkgs.callPackage ../../nixpkgs/overlays/vim-plugins/generated.nix {
    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  };

  myVimPlugins = pkgs.vimPlugins.extend (
    myVimPluginsOverlay
  );


  parserDir = pkgs.tree-sitter.withPlugins (tree-sitter-grammars-fn);

  # TODO this should be done automatically
  tree-sitter-grammars-fn = p: with p; [
    tree-sitter-bash
    tree-sitter-c
    tree-sitter-lua
    tree-sitter-http
    tree-sitter-json
    tree-sitter-nix
    # tree-sitter-haskell # crashes with a loop
    tree-sitter-python
    tree-sitter-html # for rest.nvim
    tree-sitter-norg
    tree-sitter-org-nvim
  ];


  # " , { 'tag': 'v3.12.0' }
  # Plug 'Olical/aniseed' " dependency of ?
  # Plug 'bakpakin/fennel.vim'

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = wmgraphviz-vim; }
    { plugin = fennel-vim; }
    { plugin = vim-toml; }
    { plugin = dhall-vim; }
    { plugin = vim-teal; }
    idris-vim
  ];

  luaPlugins = with pkgs.vimPlugins; [
    # {
    #   plugin = nvim-treesitter;
    #   runtime = {
    #     "parser" = {
    #       recursive = true;
    #       # target
    #       # target = "parser";
    #       source = parserDir;
    #     };
    #   };

      # plugin = (nvim-treesitter.withPlugins (
      #     plugins: with plugins; [
      #       tree-sitter-bash
      #       tree-sitter-c
      #       tree-sitter-lua
      #       tree-sitter-http
      #       tree-sitter-json
      #       tree-sitter-nix
      #       # tree-sitter-haskell # crashes with a loop
      #       tree-sitter-python
      #       tree-sitter-html  # for rest.nvim
      #       tree-sitter-norg
      #       tree-sitter-org-nvim
      #     ]
      #   ));
      # see https://github.com/NixOS/nixpkgs/issues/189838#issuecomment-1250993635 for rationale
      # runtime 
      # config = ''
      # local available, config = pcall(require, 'nvim-treesitter.configs')
      # config.setup {
      # parser_install_dir = ${pkgs.buildEnv { name = "tree-sitter-grammars"; paths = tree-sitter-grammars; } }
      # }
      # '';
    # }
    { plugin = satellite-nvim; }
    # { plugin = nvim-dap; }
    # (luaPlugin { 
    #   plugin = octo-nvim;
    # # 	  -- -- , requires = { 'nvim-lua/popup.nvim' }
    #   optional = true;
    # })
    (luaPlugin {
      plugin = sniprun;
    })
    (luaPlugin {
      plugin = urlview-nvim;
    })
    (luaPlugin {
      plugin = trouble-nvim;
      config = ''
        	require'trouble'.setup {
        	position = "bottom", -- position of the list can be: bottom, top, left, right
        	height = 10, -- height of the trouble list when position is top or bottom
        	width = 50, -- width of the list when position is left or right
        	icons = false, -- use devicons for filenames
        	-- mode = "workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
        	-- fold_open = "", -- icon used for open folds
        	-- fold_closed = "", -- icon used for closed folds
        	action_keys = { -- key mappings for actions in the trouble list
        		-- map to {} to remove a mapping, for example:
        		-- close = {},
        		close = "q", -- close the list
        		cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        		refresh = "r", -- manually refresh
        		jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        		open_split = { "<c-x>" }, -- open buffer in new split
        		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        		open_tab = { "<c-t>" }, -- open buffer in new tab
        		jump_close = {"o"}, -- jump to the diagnostic and close the list
        		toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        		toggle_preview = "P", -- toggle auto_preview
        		hover = "K", -- opens a small poup with the full multiline message
        		preview = "p", -- preview the diagnostic location
        		close_folds = {"zM", "zm"}, -- close all folds
        		open_folds = {"zR", "zr"}, -- open all folds
        		toggle_fold = {"zA", "za"}, -- toggle fold of current file
        		previous = "k", -- preview item
        		next = "j" -- next item
        	},
        	-- indent_lines = true, -- add an indent guide below the fold icons
        	-- auto_open = false, -- automatically open the list when you have diagnostics
        	-- auto_close = false, -- automatically close the list when you have no diagnostics
        	-- auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
        	-- auto_fold = false, -- automatically fold a file trouble list at creation
        	signs = {
        		-- icons / text used for a diagnostic
        		error = "",
        		warning = "",
        		hint = "",
        		information = "",
        		other = "﫠"
        	},
        	use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
        	}
        	'';

      runtime = {
        "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc";
      };
    })
    {
      plugin = auto-git-diff;
    }
    # {
    # # should be autoinstalled via deps really
    #   plugin = plenary-nvim;
    # }

    (luaPlugin {
      plugin = gitsigns-nvim;
      config = ''
        require 'gitsigns'.setup {
        -- '│' passe mais '▎' non :s
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
          update_debounce = 300,
          status_formatter = nil, -- Use default
          word_diff = true,
          diff_opts = {
              internal = false
          }  -- If luajit is present
		}
		'';
    })

    # {
    #   plugin = fidget-nvim;
    #   type = "lua";
    #   config = ''
    #     require"fidget".setup{}
    #   '';
    # }

    # (luaPlugin {
    #   plugin = lsp_lines-nvim;
    #   config = ''
    #   require("lsp_lines").register_lsp_virtual_lines()
    #   '';
    # })

    (luaPlugin {
      plugin = marks-nvim;
      config = ''
          require'marks'.setup {
            -- whether to map keybinds or not. default true
            default_mappings = true,
            -- whether movements cycle back to the beginning/end of buffer. default true
            cyclic = true,
            -- whether the shada file is updated after modifying uppercase marks. default false
            force_write_shada = false,
            -- how often (in ms) to redraw signs/recompute mark positions.
            -- higher values will have better performance but may cause visual lag,
            -- while lower values may cause performance penalties. default 150.
            refresh_interval = 1000,
            -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
            -- marks, and bookmarks.
            -- can be either a table with all/none of the keys, or a single number, in which case
            -- the priority applies to all marks.
            -- default 10.
            sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
            -- marks.nvim allows you to up to 10 bookmark groups, each with its own
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
    })

    vim-lion # Use with gl/L<text object><character to align to 
    moonscript-vim

    (luaPlugin {
      plugin = nvim-spectre;
      config = ''
		 -- nnoremap ( "n", "<leader>S",  function() require('spectre').open() end )
		 '';
    })

    # (luaPlugin {
    # plugin = nvim-gps;
    #   config = ''
    # 	require("nvim-gps").setup()
    #   '';
    # })
    # (luaPlugin {
    # plugin = nvim-treesitter-context;
    # })


    { plugin = vim-dadbod; }
    { plugin = vim-dadbod-completion; }
    { plugin = vim-dadbod-ui; }

    (luaPlugin {
      # run with :Diffview
      plugin = diffview-nvim;
      # optional = true;
    })
    (luaPlugin {
      # prettier quickfix
      plugin = nvim-bqf;
	  config = ''
	   require'bqf'.setup({
		preview = {
		 delay_syntax = 0
		}
	   })
	   '';
    })
    (luaPlugin { plugin = fugitive-gitlab-vim; })

    # { plugin = telescope-fzf-native-nvim; }
    {
      plugin = registers-nvim;

      # let g:registers_return_symbol = "\n" "'⏎' by default
      # let g:registers_tab_symbol = "\t" "'·' by default
      # let g:registers_space_symbol = "." "' ' by default
      # let g:registers_delay = 500 "0 by default, milliseconds to wait before opening the popup window
      # let g:registers_register_key_sleep = 1 "0 by default, seconds to wait before closing the window when a register key is pressed
      # let g:registers_show_empty_registers = 0 "1 by default, an additional line with the registers without content
      # let g:registers_trim_whitespace = 0 "1 by default, don't show whitespace at the begin and end of the registers
      # let g:registers_hide_only_whitespace = 1 "0 by default, don't show registers filled exclusively with whitespace
      # let g:registers_window_border = "single" "'none' by default, can be 'none', 'single','double', 'rounded', 'solid', or 'shadow' (requires Neovim 0.5.0+)
      # let g:registers_window_min_height = 10 "3 by default, minimum height of the window when there is the cursor at the bottom
      # let g:registers_window_max_width = 20 "100 by default, maximum width of the window
      # use :Registers
    }

    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first
    # (luaPlugin { plugin = telescope-frecency-nvim; })
    { plugin = nvimdev-nvim; optional = true; }
    # { plugin = neomake; }
    # {
    #   plugin = neogit;
    #   config = ''
    #     " -- neogit config
    #   '';
    # }
  ];

  completionPlugins = with pkgs.vimPlugins; [
    # (luaPlugin { plugin = coq_nvim; })
    (luaPlugin { plugin = nvim-cmp; })
    (luaPlugin { plugin = cmp-nvim-lsp; })
    # (luaPlugin { plugin = cmp-cmdline-history; })
    # (luaPlugin { plugin = cmp-conventionalcommits; })
    # (luaPlugin { plugin = cmp-digraphs; })
    (luaPlugin { plugin = cmp-rg; })
    (luaPlugin { plugin = cmp-vsnip; })
    ({ plugin = vim-vsnip; })
    # (luaPlugin { plugin = cmp-zsh; })
    # vim-vsnip
    # vim-vsnip-integ
  ];


  colorschemePlugins = with pkgs.vimPlugins; [
    { plugin = sonokai; }
    { plugin = tokyonight-nvim; }
    { plugin = molokai; }
    { plugin = onedark-nvim; }
    { plugin = dracula-vim; }
    # monkai-pro
    { plugin = vim-monokai; }
    { plugin = vim-janah; }
    { plugin = tokyonight-nvim; }
    (luaPlugin {
      # required by some colorscheme
      plugin = colorbuddy-nvim;
    })
  ];

  basePlugins = with pkgs.vimPlugins; [
    # Packer should remain first

    # { plugin = vCoolor-vim; }
    # { plugin = vim-lastplace; } # triggers a neovim bug for now
    (luaPlugin {
      plugin = packer-nvim;
      config = ''
        require('packer').init({
          luarocks = {
            python_cmd = 'python' -- Set the python command to use for running hererocks
          },
        })
        -- require my own manual config
        require('init-manual')
      '';
    })

    # {
    #   # davidgranstrom/nvim-markdown-preview
    #   plugin = nvim-markdown-preview;
    #   config = ''
    #   '';
    # }
    # y a aussi vim-markdown
    # TODO package
    # astronauta
    (luaPlugin {
      # euclio/vim-markdown-composer
      # https://github.com/euclio/vim-markdown-composer/issues/69#issuecomment-1103440076
      # see https://github.com/euclio/vim-markdown-composer/commit/910fd4321b7f25fbab5fdf84e68222cbc226d8b1
      # https://github.com/euclio/vim-markdown-composer/issues/69#event-6528328732
      # ComposerUpdate / ComposerStart
      # we can now set g:markdown_composer_binary
      # " is that the correct plugin ?
      # " let $NVIM_MKDP_LOG_LEVEL = 'debug'
      # " let $VIM_MKDP_RPC_LOG_FILE = expand('~/mkdp-rpc-log.log')
      # " let g:mkdp_browser = 'firefox'
      plugin = vim-markdown-composer;
      config = ''
                  -- use with :ComposerStart
                  vim.g.markdown_composer_autostart = 0
        		  vim.g.markdown_composer_binary = '${vim-markdown-composer.vimMarkdownComposerBin}/bin/markdown-composer'
        		'';
    })
    # disabled because of https://github.com/rktjmp/lush.nvim/issues/89
    # (luaPlugin { plugin = lush-nvim; }) 
    # (luaPlugin { plugin = gruvbox-nvim; }) 
    # out of tree
    # call with :Hoogle
    (luaPlugin {
      plugin = fzf-hoogle-vim;
      config = ''
        		  vim.g.hoogle_path = "hoogle"
        		  vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
      '';
    })

    # (luaPlugin {
    #   plugin = Shade-nvim;
    # })

    (luaPlugin {
      # TODO move config hee
      plugin = bufferline-nvim;
    })

    # (luaPlugin { plugin = nvim-peekup; })

    # (luaPlugin {
    #   plugin = nvim-biscuits;
    #   config = ''
    # require('nvim-biscuits').setup({
    # on_events = { 'InsertLeave', 'CursorHoldI' },
    # cursor_line_only = true,
    # default_config = {
    # max_length = 12,
    # min_distance = 50,
    # prefix_string = " 📎 "
    # },
    # language_config = {
    # html = { prefix_string = " 🌐 " },
    # javascript = {
    # prefix_string = " ✨ ",
    # max_length = 80
    # },
    # python = { disabled = true },
    # -- nix = { disabled = true }
    # }
    # })

    #   '';
    # })

    # (luaPlugin {
    #   plugin = pywal-nvim;
    #   config = ''
    #   '';
    # })
    (luaPlugin { plugin = glow-nvim; })

    (luaPlugin { plugin = fzf-lua; })

    (luaPlugin {
      # really helps with syntax highlighting
      plugin = haskell-vim;
      config = ''
        		  vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
        		  vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
        		  vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
        		  vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
        		  vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
        		  vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
        		  vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords
        		  vim.g.haskell_indent_disable=1
        		'';
    })
    # " gutentags + gutenhasktags {{{
    # " to keep logs GutentagsToggleTrace
    # " some commands/functions are not available by default !!
    # " https://github.com/ludovicchabant/vim-gutentags/issues/152
    # let g:gutentags_define_advanced_commands=1
    # " let g:gutentags_project_root
    # " to ease with debug
    # let g:gutentags_trace=0
    # let g:gutentags_enabled = 1 " dynamic loading
    # let g:gutentags_dont_load=0 " kill once and for all
    # let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
    #                                \ {'type': 'ruby', 'file': 'Gemfile'},
    #                                \ {'type': 'haskell', 'glob': '*.cabal'} ]
    # " produce tags for haskell http://hackage.haskell.org/package/hasktags
    # " it will fail without a wrapper https://github.com/rob-b/gutenhasktags
    # " looks brittle, hie might be better
    # " or haskdogs
    # " let g:gutentags_ctags_executable_haskell = 'gutenhasktags'
    # let g:gutentags_ctags_executable_haskell = 'hasktags'
    # " let g:gutentags_ctags_extra_args
    # let g:gutentags_file_list_command = 'rg --files'
    # " gutenhasktags/ haskdogs/ hasktags/hothasktags

    # let g:gutentags_ctags_exclude = ['.vim-src', 'build', '.mypy_cache']
    # " }}}

    (luaPlugin {
      plugin = stylish-nvim;
    })
    # 'diepm/vim-rest-console' " test rest APIs * Hit the trigger key (<C-j> by default).
    (luaPlugin {
      plugin = rest-nvim;
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
		   -- disable formatters else they generate errors/add dependencies
		   -- for instance when it detects html, it tried to run 'tidy'
		   formatters = {
			html = false,
			jq = false
		   },
          },
          -- Jump to request line on run
          jump_to_request = false,
		})
		'';
    })

    # it depends on nvim-treesitter
    (luaPlugin {
      # matches nvim-orgmode
      plugin = orgmode;

      config = ''
        		require('orgmode').setup_ts_grammar()
                require('orgmode').setup{
                    org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
                    org_default_notes_file = '~/orgmode/refile.org',
                    -- TODO add templates
                    org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
                }
        	   '';
    })

    { plugin = editorconfig-vim; }

    {
      # use ctrl a/xto cycle between different words
      plugin = vim-CtrlXA;
    }
    # { plugin = jbyuki/venn.nvim; }
    # { plugin = telescope-nvim; }
    (luaPlugin {
      plugin = fzf-vim;
      # " mostly fzf mappings, use TAB to mark several files at the same time
      # " https://github.com/neovim/neovim/issues/4487
      config = ''
        vim.g.fzf_command_prefix = 'Fzf' -- prefix commands :Files become :FzfFiles, etc.
        vim.g.fzf_nvim_statusline = 0 -- disable statusline overwriting
      '';
    })

    # defined in overrides: TODO this should be easier: like fzf-vim should be enough
    fzfWrapper

	#  nvim-colorizer 
    (luaPlugin { plugin = nvim-terminal-lua; config = "require('terminal').setup()"; })
    {
      # display git diff while rebasing, pretty dope
      plugin = auto-git-diff;
    }
    # {
    #   plugin = vim-dasht;
    # config = ''
    # " When in Python, also search NumPy, SciPy, and Pandas:
    # let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
    # let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']
    # " search related docsets
    # nnoremap <Leader>k :Dasht<Space>
    # " search ALL the docsets
    # nnoremap <Leader><Leader>k :Dasht!<Space>
    # " search related docsets
    # nnoremap ,k <Cmd>call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
    # " search ALL the docsets
    # nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>
    # '';

    #   # optional = true;
    # }
    # displays a minimap on the right
    (luaPlugin { plugin = minimap-vim; })
    (luaPlugin {
      plugin = vim-dirvish;
      config = ''
        		  vim.g.dirvish_mode=2
        		  vim.g.loaded_netrwPlugin = 1
        		'';
    })

    # {
    #   plugin = sql-nvim;
    #   # config = "let g:sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
    # }
    {
      plugin = vim-fugitive;
    }
    # {
    # plugin = vim-signature;
    # config = ''
    # let g:SignatureMarkTextHLDynamic=0
    # let g:SignatureEnabledAtStartup=1
    # let g:SignatureWrapJumps=1
    # let g:SignatureDeleteConfirmation=1
    # let g:SignaturePeriodicRefresh=1
    # '';
    # }

    (luaPlugin {
      plugin = vim-startify;
      # cool stuff is that it autostarts sessions
      # TODO
      config = ''
        		  vim.cmd [[
        		  let g:startify_use_env = 0
        		  let g:startify_disable_at_vimenter = 0
        		  let g:startify_lists = [
        				\ { 'header': ['   MRU '.getcwd() ], 'type': 'dir'},
        				\ { 'header': ['   MRU' ],           'type': 'files'} ,
        				\ { 'header': ['   Bookmarks' ],     'type': 'bookmarks' },
        				\ { 'header': ['   Sessions'  ],      'type': 'sessions' }
        				\ ]
        		  let g:startify_bookmarks = [
        				\ {'i': $XDG_CONFIG_HOME.'/i3/config.main'},
        				\ {'h': $XDG_CONFIG_HOME.'/nixpkgs/home.nix'},
        				\ {'c': 'dotfiles/nixpkgs/configuration.nix'},
        				\ {'z': $XDG_CONFIG_HOME.'/zsh/'},
        				\ {'m': $XDG_CONFIG_HOME.'/mptcpanalyzer/config'},
        				\ {'n': $XDG_CONFIG_HOME.'/nvim/config'},
        				\ {'N': $XDG_CONFIG_HOME.'/ncmpcpp/config'},
        				\ ]
        				" \ {'q': $XDG_CONFIG_HOME.'/qutebrowser/qutebrowser.conf'},
        		  let g:startify_files_number = 10
        		  let g:startify_session_autoload = 1
        		  let g:startify_session_persistence = 0
        		  let g:startify_change_to_vcs_root = 0
        		  let g:startify_session_savevars = []
        		  let g:startify_session_delete_buffers = 1
        		  let g:startify_change_to_dir = 0
        		  let g:startify_relative_path = 0
        		  ]]
      '';
    })

    vim-scriptease
    # test with hop ?
    (luaPlugin {
      plugin = vim-sneak;
      config = ''
         -- can press 's' again to go to next result, like ';'
        		  vim.cmd [[
        		   let g:sneak#s_next = 1 
        		   let g:sneak#prompt = 'Sneak>'

                  let g:sneak#streak = 0
        		  ]]
      '';
      # map f <Plug>Sneak_f
      # map F <Plug>Sneak_F
      # map t <Plug>Sneak_t
      # map T <Plug>Sneak_T

    })

    {
      plugin = vim-grepper;
      # careful these mappings are not applied as they arrive before the plug declaration
      # config="";
      # after = ''
      # '';
    }
    vim-nix
    (luaPlugin {
      plugin = vim-obsession;
      after = ''
                  vim.keymap.set("n", "<Leader>$", "<Cmd>Obsession<CR>", { remap = true })
        		  vim.g.obsession_no_bufenter = true
      '';
      # testing luaConfig (experimental)
      # luaConfig = ''
      #   -- vim-obsession config
      # '';
    })
    # ctrl-e causes an issue with telescope prompt
    vim-rsi
    # ' " syntax file for neomutt
    # neomutt-vim
    (luaPlugin {
      plugin = vim-sayonara;
      config = ''
        vim.g.sayonara_confirm_quit = 0
      '';
    })

    # vim-livedown

    # { 
    # # node-based :MarkdownPreview
    # plugin = markdown-preview-nvim;
    # # let g:vim_markdown_preview_github=1
    # # let g:vim_markdown_preview_use_xdg_open=1
    # }

    # nvim-markdown-preview  # :MarkdownPreview
    {
      plugin = vim-commentary;
    }

    (luaPlugin {
      # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
      plugin = vimtex;
      optional = true;
      config = ''
        -- Pour le rappel
        -- <localleader>ll pour la compilation continue du pdf
        -- <localleader>lv pour la preview du pdf
        -- see https://github.com/lervag/vimtex/issues/1058
        -- let g:vimtex_log_ignore 
        -- taken from https://castel.dev/post/lecture-notes-1/
        vim.g.tex_conceal='abdmg'
        vim.g.vimtex_log_verbose=1
        vim.g.vimtex_quickfix_open_on_warning = 1
        vim.g.vimtex_view_automatic=1
        vim.g.vimtex_view_enabled=1
        -- was only necessary with vimtex lazy loaded
        -- let g:vimtex_toc_config={}
        -- let g:vimtex_complete_img_use_tail=1
        -- autoindent can slow down vim quite a bit
        -- to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_compiler_enabled=1
        vim.g.vimtex_compiler_progname='nvr'
        vim.g.vimtex_quickfix_method="latexlog"
        -- 1=> opened automatically and becomes active (2=> inactive)
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_format_enabled = 0
        vim.g.vimtex_complete_recursive_bib = 0
        vim.g.vimtex_complete_close_braces = 0
        vim.g.vimtex_fold_enabled = 0
        vim.g.vimtex_view_use_temp_files=1 -- to prevent zathura from flickering
        -- let g:vimtex_syntax_minted = [ { 'lang' : 'json', \ }]

        -- shell-escape is mandatory for minted
        -- check that '-file-line-error' is properly removed with pplatex
        -- executable The name/path to the latexmk executable. 
        		'';
      # vim.gvimtex_compiler_latexmk = {
      #          'backend' : 'nvim',
      #          'background' : 1,
      #          'build_dir' : ''',
      #          'callback' : 1,
      #          'continuous' : 1,
      #          'executable' : 'latexmk',
      #          'options' : {
      #            '-pdf',
      #            '-file-line-error',
      #            '-bibtex',
      #            '-synctex=1',
      #            '-interaction=nonstopmode',
      #            '-shell-escape',
      #          },
      #         }
    })
    (luaPlugin {
      plugin = unicode-vim;

      # " let g:Unicode_cache_directory='${pkgs.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'
      # let g:Unicode_data_directory='${pkgs.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'
      # " overrides ga
      # nmap ga <Plug>(UnicodeGA)

      config = ''
                vim.g.Unicode_data_directory='${pkgs.vimPlugins.unicode-vim}/autoload/unicode'

                -- overrides ga
        		vim.keymap.set ( "n", "ga",  "<Plug>(UnicodeGA)", { remap = true, } )

      '';
    })

  ];

  overlayPlugins = with myVimPlugins; [
    # pkgs.vimPlugins.telescope-fzf-native-nvim
    # TODO restore in my overlay
    # {
    #   # davidgranstrom/nvim-markdown-preview
    #   plugin = nvim-markdown-preview;
    #   config = ''
    #   '';
    # }
  ];

  rawPlugins =

    # [
    # this one must be first
    # (luaPlugin {
    #  plugin = myVimPlugins.import-nvim;

    #  config = "local import = require'import'";
    # }) 
    # ] 
    # ++
    basePlugins
    ++ overlayPlugins
    ++ luaPlugins
    # ++ fennelPlugins
    ++ colorschemePlugins
    ++ completionPlugins
    ++ filetypePlugins
  ;

  # taken from the official flake
  myPackage = pkgs.neovim;
in
{

 imports = [
   ../modules/neovim.nix
 ];

  #  extraLuaPackages = ps: [ps.mpack];
  programs.neovim = {
    enable = true;
	# defaultEditor = false;

	fennel.enable = false;
	teal.enable = true;
	orgmode.enable = true;
	# autocompletion.enable = true;

    # take the one from the flake
    package = myPackage;

    # https://github.com/iskolbin/lbase64
    # extraLuaPackages = lp: [ lp.basexx ];
    extraLuaPackages = ls: [ ls.basexx ];

    # source doesn't like `stdpath('config').'`
    # todo should use mkBefore ${config.programs.neovim.generatedInitrc}
    # source $XDG_CONFIG_HOME/nvim/init.manual.vim
    # extraConfig = let 
    # in ''
    #   let mapleader = " "
    #   let maplocalleader = ","
    # ''
    # # concatStrings = builtins.concatStringsSep "";
    # + (lib.strings.concatStrings (
    # lib.mapAttrsToList genBlockViml vimlRcBlocks
    # ))
    # ;


    # extraLuaConfig = ''
    #   -- logs are written to /home/teto/.cache/vim-lsp.log
    #   vim.lsp.set_log_level("info")
    # '';

	# TODO use lua from 

    # TODO add lsp stuff
    extraPackages = with pkgs; [
      # luaPackages.lua-lsp
      lua53Packages.teal-language-server
      lua51Packages.luacheck
      haskellPackages.hasktags
      jq
      manix
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.pyright
      nodePackages.typescript-language-server
      pandoc # for markdown preview, should be in the package closure instead
      # pythonPackages.pdftotext  # should appear only in RC ? broken
      nil # a nix lsp
      # rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };

  xdg.configFile =
    let
      # TODO add the after bits
      extraLuaConfig = (lib.strings.concatStrings (
        lib.mapAttrsToList genBlockLua luaRcBlocks
      ));

    in
    {
      # a copy of init.vim in fact
      "nvim/lua/init-home-manager.lua".text = extraLuaConfig;
    };
}
