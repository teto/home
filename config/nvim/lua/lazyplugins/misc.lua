return {
 {
  -- highlight cursor position and selection in command mode
  -- (which is not the case by default
   "moyiz/command-and-cursor.nvim",
   event = "VeryLazy",
   opts = {},
 },
 {
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  config = function()
    require("telescope").load_extension("smart_open")
  end,
  dependencies = {
    -- "kkharji/sqlite.lua", -- installed via nix
    -- Only required if using match_algorithm fzf
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    -- { "nvim-telescope/telescope-fzy-native.nvim" },
  },
},
 {
  -- :DataViewer
  'VidocqH/data-viewer.nvim'
 },
 {
   "jghauser/kitty-runner.nvim",

   -- :KittyOpenRunner / KittyRunCommand / KittySendLines
   config = function()
     require("kitty-runner").setup()
   end
 },
 {

  -- trying to show all warnings/errors
  -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
  'artemave/workspace-diagnostics.nvim'
 },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup()
    end,
  },
 -- { 
 --  -- 'monkoose/fzf-hoogle.vim'
 --  dir = '/home/teto/fzf-hoogle.vim'
 -- }, 

-- {
--  -- neotests has extensions for haskell and playwright
--  -- :Neotest summary
--   "nvim-neotest/neotest",
--   dependencies = {
--    "nvim-neotest/nvim-nio",
--     -- "nvim-lua/plenary.nvim",
--     -- "nvim-treesitter/nvim-treesitter",
--     "antoinemadec/FixCursorHold.nvim"
--   },
--   config = function ()
--    -- https://github.com/nvim-neotest/neotest#usage
--    -- require("neotest").run.run()
--    require("neotest").setup({
--      adapters = {
--       require('neotest-haskell') {
--         -- Default: Use stack if possible and then try cabal
--         build_tools = { 'stack', 'cabal' },
--         -- Default: Check for tasty first and then try hspec
--         frameworks = { 'tasty', 'hspec', 'sydtest' },
--       },      
--        -- require("neotest-plenary"),
--        -- require("neotest-vim-test")({
--        --   ignore_file_types = { "python", "vim", "lua" },
--        -- }),
--      },
--    })
--   end

-- },
-- {
--  'Exafunction/codeium.vim'
-- },


 {
   'TrevorS/uuid-nvim',
   lazy = true,
   config = function()
     -- optional configuration
     require('uuid-nvim').setup{
       case = 'upper',
     }
   end,
 },

 { dir = '/home/teto/neovim/jap.nvim',
  config = function ()
    vim.keymap.set('n', '<Leader>j', [[<Cmd>lua require'jap-nvim'.show_info()<CR>]])
  end

 },
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
 { 'ziontee113/color-picker.nvim'
 -- use with PickColor, o to toggle serliazier, hjkl to change values
 ,  config = function()
        require("color-picker")
    end,
 },
 -- {
 -- -- a zenity picker for several stuff (colors etc)
 -- -- lazy = true
 --  'DougBeney/pickachu', 
 --  cmd= "Pickachu",
 --  -- :Pick
 -- },

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
 -- { 'gennaro-tedesco/nvim-peekup' },
 -- { 'notomo/gesture.nvim' , opt = true; },
 -- 'anuvyklack/hydra.nvim', -- to create submodes
 -- "terrortylor/nvim-comment"
 { 'SmiteshP/nvim-navic'
 , config = function ()

   local navic = require'nvim-navic'
    vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Attach lsp_signature on new client",
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end
            -- navic.attach(client, bufnr)
            -- local on_attach = require 'on_attach'
            -- on_attach.on_attach(client, bufnr)
        end
    })
  end
 },
 {
  -- provides :SessionSave,:SessionRestore, :Autosession search/delete
   'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
      auto_session_root_dir = ".", -- vim.fn.stdpath('data').."/sessions/",
      auto_session_use_git_branch = false
    }
  end
 },
 -- {'Shatur/neovim-session-manager',
 -- config = function ()
 --  local Path = require('plenary.path')
 --  require('session_manager').setup({
 --    sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
 --    path_replacer = '__', -- The character to which the path separator will be replaced for session files.
 --    colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
 --    -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
 --    autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
 --    autosave_last_session = true, -- Automatically save last session on exit and on session switch.
 --    autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
 --    autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
 --    autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
 --      'gitcommit',
 --    },
 --    autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
 --    autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
 --    max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
 --  })
 -- end
-- },
-- default config
 { 'letieu/hacker.nvim',


 -- :HackFollow or :HackAuto
  config = function ()
    require("hacker").setup {
   content = [[ Code want to show.... ]], -- The code snippet that show when typing
   filetype = "lua", -- filetype of code snippet
   speed = { -- characters insert each time, random from min -> max
     min = 2,
     max = 10,
   },
   is_popup = false, -- show random float window when typing
   popup_after = 5,
  }
 end
},
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
 'cameron-wags/rainbow_csv.nvim',
 'gennaro-tedesco/nvim-peekup', -- to see the content of the various buffers
 'rhysd/vim-gfm-syntax', -- markdown syntax compatible with Github's
 { 'eandrju/cellular-automaton.nvim', lazy = true }, -- :CellularAutomaton make_it_rain
 { 'bogado/file-line', branch = 'main' }, -- to open a file at a specific line
 'darkonig/nvim-terminal.lua' -- , '~/neovim/nvim-terminal.lua' -- to display ANSI colors
 , -- to display ANSI colors
 'chrisbra/vim-diff-enhanced',
 { 'rareitems/anki.nvim', lazy = true }, -- to create anki cards
 'nvim-zh/colorful-winsep.nvim', -- to have a colored separator around the active window
 -- :Nvimesweeper / :h nvimesweeper
 { 'seandewar/nvimesweeper', lazy = true },
 --  '~/pdf-scribe.nvim'  -- to annotate pdf files from nvim :PdfScribeInit
 -- PdfScribeInit
 -- vim.g.pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
 -- vim.g.pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
 -- }}}

 { 'voldikss/vim-translator', lazy = true },
 -- Vim-cool disables search highlighting when you are done searching and re-enables it when you search again.
 -- ('romainl/vim-cool')
 -- 'lrangell/theme-cycler.nvim'
 -- {'folke/which-key.nvim', -- :WhichKey
 -- config = function ()
 --   wk.setup({
 -- plugins = {
 --	marks = true, -- shows a list of your marks on ' and `
 --	registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
 --	-- the presets plugin, adds help for a bunch of default keybindings in Neovim
 --	-- No actual key bindings are created
 --	presets = {
 --	operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
 --	motions = true, -- adds help for motions
 --	text_objects = true, -- help for text objects triggered after entering an operator
 --	windows = true, -- default bindings on <c-w>
 --	nav = true, -- misc bindings to work with windows
 --	z = true, -- bindings for folds, spelling and others prefixed with z
 --	g = true, -- bindings for prefixed with g
 --	},
 -- },
 -- add operators that will trigger motion and text object completion
 -- to enable all native operators, set the preset / operators plugin above
 -- operators = { gc = "Comments" },
 -- icons = {
 --	breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
 --	separator = "➜", -- symbol used between a key and it's label
 --	group = "+", -- symbol prepended to a group
 -- },
 -- window = {
 --	border = "none", -- none, single, double, shadow
 --	position = "bottom", -- bottom, top
 --	margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
 --	padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
 -- },
 -- layout = {
 --	height = { min = 4, max = 25 }, -- min and max height of the columns
 --	width = { min = 20, max = 50 }, -- min and max width of the columns
 --	spacing = 3, -- spacing between columns
 -- },
 -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
 -- show_help = true, -- show help message on the command line when the popup is visible
 -- triggers = "auto", -- automatically setup triggers
 -- triggers = {"<leader>"} -- or specifiy a list manually
 -- })
 -- end,
 -- lua repl :Luadev

 -- for live editing
 --  { 'jbyuki/instant.nvim' }
 --  { 'jbyuki/nabla.nvim' } -- write latex equations in ASCII
 --  { 'jbyuki/monolithic.nvim' } -- write latex equations in ASCII
 { 'bfredl/nvim-luadev', cmd = 'Luadev' },
 {
  'AckslD/nvim-FeMaco.lua',
  name = 'femaco',
  -- config = function()
  --  require('femaco').setup()
  -- end,
 },
 -- for quickreading: use :FSToggle to Toggle flow state
 -- {'nullchilly/fsread.nvim', config = function ()
 -- 	-- vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
 -- 	-- vim.g.skip_flow_default_hl = true -- If you want to override default highlights
 -- 	-- vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
 -- 	-- vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
 -- end},
 { 'alec-gibson/nvim-tetris', lazy = true },
 { 'tweekmonster/startuptime.vim', lazy = true }, -- {'on': 'StartupTime'} " see startup time per script
 'MunifTanjim/nui.nvim', -- to create UIs
 'honza/vim-snippets',
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
 {
  "giusgad/pets.nvim",
  cond = not vim.fn.has 'gui_running' == 1, -- fails in neovide
  dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
  config = function ()
   require("pets").setup({})
  end
},
 { 'rhysd/git-messenger.vim', cmd = 'GitMessenger' }, -- to show git message :GitMessenger
 -- { 'tweekmonster/nvim-api-viewer', cmd = 'NvimAPI' },
 -- 'antoinemadec/openrgb.nvim',
 -- 'vim-denops/denops.vim',
 -- to help with nvim-hs
 -- 'neovimhaskell/nvim-hs.vim',
 --  'ryoppippi/bad-apple.vim' -- needs denops
 --  'eugen0329/vim-esearch' -- search & replace
 --  'kshenoy/vim-signature' -- display marks in gutter, love it
 --  {
 --   -- Display marks for different kinds of decorations across the buffer. Builtin handlers include:
 --   -- 'lewis6991/satellite.nvim',
 --   config = function()
 --     require('satellite').setup()
 --   end
 -- }
 -- installed via nix
 -- require('satellite').setup()
 --  {
 --   "max397574/colortils.nvim",
 --   -- cmd = "Colortils",
 --   config = function()
 --     require("colortils").setup()
 --   end,
 -- }

 --{ -- to take notes, :NV
 --'alok/notational-fzf-vim',
 --config = function ()
 ---- alok/notational-fzf-vim {{{
 ---- use c-x to create the note
 ---- vim.g.nv_search_paths = []
 --vim.g.nv_search_paths = { '~/Nextcloud/Notes' }
 --vim.g.nv_default_extension = '.md'
 --vim.g.nv_show_preview = 1
 --vim.g.nv_create_note_key = 'ctrl-x'
 --end

 ---- String. Default is first directory found in `g:nv_search_paths`. Error thrown
 ----if no directory found and g:nv_main_directory is not specified
 ----vim.g.nv_main_directory = g:nv_main_directory or (first directory in g:nv_search_paths)
 ----}}}
 --},

 -- terminal image viewer in neovim see https://github.com/edluffy/hologram.nvim#usage for usage
 --  'edluffy/hologram.nvim' -- hologram-nvim
 --  'ellisonleao/glow.nvim' -- markdown preview, run :Glow

 --  {
 -- 	-- Show where your cursor moves
 -- 	'edluffy/specs.nvim',
 -- 	config = function ()
 -- 		local specs = require 'specs'
 -- 		specs.setup{
 -- 			show_jumps	= true,
 -- 			min_jump = 20,
 -- 			popup = {
 -- 				delay_ms = 0, -- delay before popup displays
 -- 				inc_ms = 10, -- time increments used for fade/resize effects
 -- 				blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
 -- 				width = 30,
 -- 				winhl = "PMenu",
 -- 				fader = specs.linear_fader,
 -- 				resizer = specs.shrink_resizer
 -- 			},
 -- 			ignore_filetypes = {},
 -- 			ignore_buftypes = {
 -- 				nofile = true,
 -- 			},
 -- 		}
 -- 	end
 -- }

 --  {
 -- 	'code-biscuits/nvim-biscuits',
 -- 	config = function ()
 -- 	require('nvim-biscuits').setup({
 -- 	on_events = { 'InsertLeave', 'CursorHoldI' },
 -- 	cursor_line_only = true,
 -- 	default_config = {
 -- 		max_length = 12,
 -- 		min_distance = 50,
 -- 		prefix_string = " 📎 "
 -- 	},
 -- 	language_config = {
 -- 		html = { prefix_string = " 🌐 " },
 -- 		javascript = {
 -- 			prefix_string = " ✨ ",
 -- 			max_length = 80
 -- 		},
 -- 		python = { disabled = true },
 -- 		-- nix = { disabled = true }
 -- 	}
 -- 	})
 -- end
 -- }

 --  { 'nvim-lua/popup.nvim'	}  -- mimic vim's popupapi for neovim

 --  {
 -- 	-- shows type annotations for functions in virtual text using built-in LSP client
 -- 	'jubnzv/virtual-types.nvim'
 -- }


 --  'glacambre/firenvim' -- to use nvim in firefox
 -- call :NR on a region than :w . coupled with b:nrrw_aucmd_create,
 --  'chrisbra/NrrwRgn' -- to help with multi-ft files
}
