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

  # " , { 'tag': 'v3.12.0' }
  # Plug 'Olical/aniseed' " dependency of ?
  # Plug 'bakpakin/fennel.vim'

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = wmgraphviz-vim; }
    { plugin = vim-toml; }
  ];


  luaPlugins = with pkgs.vimPlugins; [

    # TODO it should be rocksified
    # (luaPlugin { plugin = iron-nvim;
    # TODO set lua here
    # config = ''
    #         local iron = require('iron.core')
    #         iron.setup({
    #             config = {
    #                 -- If iron should expose `<plug>(...)` mappings for the plugins
    #                 should_map_plug = false,
    #                 -- Whether a repl should be discarded or not
    #                 scratch_repl = true,
    #                 -- Your repl definitions come here
    #                 repl_definition = {
    #                     sh = { command = { 'zsh' } },
    #                     nix = { command = { 'nix', 'repl', '/home/teto/nixpkgs' } },
    #                     -- copied from the nix wrapper :/
    #                     lua = { command = '${pkgs.luajit}/bin/lua' },
    #                 },
    #                 # bottom('40')
    #                 repl_open_cmd = require('iron.view').leftabove(40),
    #                 -- how the REPL window will be opened, the default is opening
    #                 -- a float window of height 40 at the bottom.
    #             },
    #             -- Iron doesn't set keymaps by default anymore. Set them here
    #             -- or use `should_map_plug = true` and map from you vim files
    #             keymaps = {
    #                 send_motion = '<space>sc',
    #                 visual_send = '<space>sc',
    #                 send_file = '<space>sf',
    #                 send_line = '<space>sl',
    #                 send_mark = '<space>sm',
    #                 mark_motion = '<space>mc',
    #                 mark_visual = '<space>mc',
    #                 remove_mark = '<space>md',
    #                 cr = '<space>s<cr>',
    #                 interrupt = '<space>s<space>',
    #                 exit = '<space>sq',
    #                 clear = '<space>cl',
    #             },
    #             -- If the highlight is on, you can change how it looks
    #             -- For the available options, check nvim_set_hl
    #             highlight = {
    #                 italic = true,
    #             },
    #         })
    # '';
   # })

    # { plugin = modicator-nvim; }
    # (luaPlugin {
    #   plugin = nvim-lspconfig;
    #   config = let nodePkgs = pkgs.nodePackages; in ''
    #     local lspconfig = require 'lspconfig'
    #     lspconfig.tsserver.setup({
    #         autostart = true,
    #         -- TODO should be generated/fixed in nix
    #         cmd = {
    #           "${lib.getExe nodePkgs.typescript-language-server}",
    #               "--stdio",
    #               "--tsserver-path",
    #               -- found with 'nix build .#nodePackages.typescript'
    #               "${nodePkgs.typescript}/lib/node_modules/typescript/lib"
    #         }
    #      })
    #     '';
    # })

    {
      # we should have a file of the grammars as plugins
      # symlinkJoin
     # Usage:
      plugin = pkgs.symlinkJoin {
       name = "tree-sitter-grammars";
       paths = with pkgs.neovimUtils; [
          # tree-sitter-bash
          # tree-sitter-c
          # tree-sitter-lua
          # tree-sitter-http
          # tree-sitter-json
          (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-nix)
          # # tree-sitter-haskell # crashes with a loop
          # tree-sitter-python
          # tree-sitter-html  # for rest.nvim
          (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-html) # for devdocs
          # tree-sitter-norg
          # tree-sitter-org-nvim
          (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-query)
          # (grammarToPlugin tree-sitter-just)
        ];
      };
      # see https://github.com/NixOS/nixpkgs/issues/189838#issuecomment-1250993635 for rationale
      # config = ''
      # local available, config = pcall(require, 'nvim-treesitter.configs')
      # config.setup {
      # parser_install_dir = ${pkgs.buildEnv { name = "tree-sitter-grammars"; paths = tree-sitter-grammars; } }
      # }
      # '';
    }

	# not upstreamed yet
    # (luaPlugin { plugin = nvim-lua-gf; })
    (luaPlugin { plugin = urlview-nvim; })
    # (luaPlugin { plugin = nvim-web-devicons; })
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
          signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
          numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
          linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
          word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
          on_attach = function(bufnr) 
              local function map(mode, lhs, rhs, opts)
                  opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
              end

              -- Navigation
              map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
              map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

              -- Actions
              map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
              map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
              map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
              map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
              map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
              map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
              map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
              map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
              map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
              map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
              map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
              map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
              map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

              -- Text object
              map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
              map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end,
          watch_gitdir = {
            interval = 1000,
            follow_files = true
          },
          sign_priority = 6,
          current_line_blame = false,
          current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
          current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
          },
          max_file_length = 40000, -- Disable if file is longer than this (in lines)
          update_debounce = 300,
          status_formatter = nil, -- Use default
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

    (luaPlugin {
      plugin = nvim-spectre;
	  # TODO add to menu instead
      config = ''
        -- nnoremap ( "n", "<leader>S",  function() require('spectre').open() end )
      '';
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

    (luaPlugin {
      plugin = registers-nvim;
      # https://github.com/tversteeg/registers.nvim#default-values
      config = ''
       require("registers").setup()
       '';

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
    })
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
    (luaPlugin { plugin = fzf-lua; })

    { # use ctrl a/xto cycle between different words
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
        vim.g.fzf_nvim_statusline = 0 -- disable statusline overwriting'';
    })

    # defined in overrides: TODO this should be easier: like fzf-vim should be enough
    fzfWrapper

    #  nvim-colorizer 
    (luaPlugin { plugin = nvim-terminal-lua; config = "require('terminal').setup()"; })

	# TODO hacking on this
    {
      # display git diff while rebasing, pretty dope
      plugin = auto-git-diff;
      # config = ''
      # let g:auto_git_diff_disable_auto_update=1
      # '';
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
    { plugin = vim-fugitive; }

	# replaced by alpha.nvim ?
    # (luaPlugin {
    #   plugin = vim-startify;
    #   # cool stuff is that it autostarts sessions
    #   config = ''
    #     vim.cmd [[
    #     let g:startify_use_env = 0
    #     let g:startify_disable_at_vimenter = 0
    #     let g:startify_lists = [
    #           \ { 'header': ['   MRU '.getcwd() ], 'type': 'dir'},
    #           \ { 'header': ['   MRU' ],           'type': 'files'} ,
    #           \ { 'header': ['   Bookmarks' ],     'type': 'bookmarks' },
    #           \ { 'header': ['   Sessions'  ],      'type': 'sessions' }
    #           \ ]
    #     let g:startify_bookmarks = [
    #           \ {'i': $XDG_CONFIG_HOME.'/i3/config.main'},
    #           \ {'h': $XDG_CONFIG_HOME.'/nixpkgs/home.nix'},
    #           \ {'c': 'dotfiles/nixpkgs/configuration.nix'},
    #           \ {'z': $XDG_CONFIG_HOME.'/zsh/'},
    #           \ {'m': $XDG_CONFIG_HOME.'/mptcpanalyzer/config'},
    #           \ {'n': $XDG_CONFIG_HOME.'/nvim/config'},
    #           \ {'N': $XDG_CONFIG_HOME.'/ncmpcpp/config'},
    #           \ ]
    #           " \ {'q': $XDG_CONFIG_HOME.'/qutebrowser/qutebrowser.conf'},
    #     let g:startify_files_number = 10
    #     let g:startify_session_autoload = 1
    #     let g:startify_session_persistence = 0
    #     let g:startify_change_to_vcs_root = 0
    #     let g:startify_session_savevars = []
    #     let g:startify_session_delete_buffers = 1
    #     let g:startify_change_to_dir = 0
    #     let g:startify_relative_path = 0
    #     ]]
    #   '';
    # })

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
    }
    vim-nix
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

    {
      plugin = vim-commentary;
    }

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

  # with myVimPlugins;
  overlayPlugins =  [
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
       basePlugins
    ++ overlayPlugins
    ++ luaPlugins
    ++ colorschemePlugins
    ++ filetypePlugins
  ;

  # taken from the official flake
  myPackage = pkgs.neovim;
in
{

  #  extraLuaPackages = ps: [ps.mpack];
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # custom options
    # fennel.enable = false;
    teal.enable = false;
    orgmode.enable = false;
    autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    package = myPackage;

    # https://github.com/iskolbin/lbase64
    # extraLuaPackages = lp: [ lp.basexx ];
    # extraLuaPackages = ls: [ ls.basexx ];

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


     extraLuaConfig =      (lib.strings.concatStrings (
        lib.mapAttrsToList genBlockLua luaRcBlocks
      ))
     ;

    extraPackages = with pkgs; [
      lua51Packages.luacheck
      nil # a nix lsp
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };
}
