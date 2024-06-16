return {
    -- {
    --  "reo101/nix-update.nvim",
    --  dependencies = {
    -- 	 -- None (yet), but could use those
    -- 	 -- "nvim-lua/plenary.nvim",
    -- 	 -- "nvim-telescope/telescope.nvim",
    --  },
    --  config = function()
    -- 	 require("nix-update").setup()
    --  end,
    -- },

    -- TODO move to opt
    -- {
    --  -- :DataViewer
    --  'VidocqH/data-viewer.nvim'
    -- },

    -- {
    --   'mikesmithgh/kitty-scrollback.nvim',
    --   enabled = true,
    --   lazy = true,
    --   cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    --   event = { 'User KittyScrollbackLaunch' },
    --   -- version = '*', -- latest stable version, may have breaking changes if major version changed
    --   -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    --   config = function()
    --     require('kitty-scrollback').setup()
    --   end,
    -- },

    -- {
    --  -- 'monkoose/fzf-hoogle.vim'
    --  dir = '/home/teto/fzf-hoogle.vim'
    -- },

    -- {
    --   'TrevorS/uuid-nvim',
    --   lazy = true,
    --   config = function()
    --     -- optional configuration
    --     require('uuid-nvim').setup{
    --       case = 'upper',
    --     }
    --   end,
    -- },

    -- { "shellRaining/hlchunk.nvim", event = { "UIEnter" }, },

    -- compete with registers.nvim
    -- https://github.com/gelguy/wilder.nvim
    -- TODO upstream
    --use {
    --	'chipsenkbeil/distant.nvim'
    --	, opt = true
    --	, config = function()
    --		require('distant').setup {
    --		-- Applies Chip's personal settings to every machine you connect to
    --		--
    --		-- 1. Ensures that distant servers terminate with no connections
    --		-- 2. Provides navigation bindings for remote directories
    --		-- 3. Provides keybinding to jump into a remote file's parent directory
    --		['*'] = require('distant.settings').chip_default()
    --		}
    --	end
    --}

    -- REPL (Read Execute Present Loop) {{{
    -- github mirror of use 'http://gitlab.com/HiPhish/repl.nvim'
    -- use 'http://gitlab.com/HiPhish/repl.nvim' -- no commit for the past 2 years
    -- repl.nvim (from hiphish) {{{
    -- vim.g.repl['lua'] = {
    --     \ 'bin': 'lua',
    --     \ 'args': [],
    --     \ 'syntax': '',
    --     \ 'title': 'Lua REPL'
    -- \ }
    -- Send the text of a motion to the REPL
    -- nmap <leader>rs  <Plug>(ReplSend)
    -- -- Send the current line to the REPL
    -- nmap <leader>rss <Plug>(ReplSendLine)
    -- nmap <leader>rs_ <Plug>(ReplSendLine)
    -- -- Send the selected text to the REPL
    -- vmap <leader>rs  <Plug>(ReplSend)
    -- }}}
    --}}}

    -- only for dash it seems
    -- Install via nix
    -- module "libdash_nvim" not found, did you set up Dash.nvim with `make install` as a post-install hook? See :h dash-install
    -- 'mrjones2014/dash.nvim',
    -- use 'sjl/gundo.vim' " :GundoShow/Toggle to redo changes
    -- 		'hrsh7th/vim-vsnip',
    -- 		'hrsh7th/vim-vsnip-integ',
    -- 		'rafamadriz/friendly-snippets'
    -- 	},

    -- { 'gelguy/wilder.nvim' },
    -- { 'notomo/gesture.nvim' , opt = true; },
    -- 'anuvyklack/hydra.nvim', -- to create submodes
    -- "terrortylor/nvim-comment"

    -- {
    --  -- provides :SessionSave,:SessionRestore, :Autosession search/delete
    --   'rmagatti/auto-session',
    --  config = function()
    --    require("auto-session").setup {
    --      log_level = "error",
    --      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    --      auto_session_root_dir = ".", -- vim.fn.stdpath('data').."/sessions/",
    --      auto_session_use_git_branch = false
    --    }
    --  end
    -- },
    -- {
    --   -- yeah it depends
    --     'goolord/alpha-nvim',
    --     requires = { 'nvim-tree/nvim-web-devicons' },
    --     config = function ()
    --         require'alpha'.setup(require'alpha.themes.startify'.config)
    --     end
    -- },
    -- {
    --   'glepnir/dashboard-nvim',
    --   event = 'VimEnter',
    --   config = function()
    --     require('dashboard').setup {
    --       -- config
    --       -- change_to_vcs_root
    --       -- shortcut_type = "letter" or "number"
    --       hide = {
    --        statusline = false
    --       }
    --     }
    --   end,
    --   dependencies = { {'nvim-tree/nvim-web-devicons'}}
    -- },

    -- 'cameron-wags/rainbow_csv.nvim',

    -- 'gennaro-tedesco/nvim-peekup', -- to see the content of the various buffers

    -- 'darkonig/nvim-terminal.lua' -- , '~/neovim/nvim-terminal.lua' -- to display ANSI colors
    -- to display ANSI colors

    -- { 'rareitems/anki.nvim', lazy = true }, -- to create anki cards

    -- 'nvim-zh/colorful-winsep.nvim', -- to have a colored separator around the active window

    --  '~/pdf-scribe.nvim'  -- to annotate pdf files from nvim :PdfScribeInit
    -- PdfScribeInit
    -- vim.g.pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
    -- vim.g.pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
    -- }}}

    -- { 'bfredl/nvim-luadev', cmd = 'Luadev' },

    -- for quickreading: use :FSToggle to Toggle flow state
    -- {'nullchilly/fsread.nvim', config = function ()
    -- 	-- vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
    -- 	-- vim.g.skip_flow_default_hl = true -- If you want to override default highlights
    -- 	-- vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
    -- 	-- vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
    -- end},

    -- 'honza/vim-snippets',

    -- {
    --     'ethanholz/nvim-lastplace',
    --     config = function()
    --         require('nvim-lastplace').setup({
    --             lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
    --             lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
    --             lastplace_open_folds = true,
    --         })
    --     end,
    -- },

    -- 'vim-denops/denops.vim',
    -- to help with nvim-hs
    --  'ryoppippi/bad-apple.vim' -- needs denops
    --  'kshenoy/vim-signature' -- display marks in gutter, love it

    -- terminal image viewer in neovim see https://github.com/edluffy/hologram.nvim#usage for usage
    --  'edluffy/hologram.nvim' -- hologram-nvim
}
