return {
    'rhysd/vim-gfm-syntax', -- markdown syntax compatible with Github's
    { 'eandrju/cellular-automaton.nvim', lazy = true }, -- :CellularAutomaton make_it_rain
    { 'bogado/file-line', branch = 'main' }, -- to open a file at a specific line
    'norcalli/nvim-terminal.lua'    -- , '~/neovim/nvim-terminal.lua' -- to display ANSI colors
, -- to display ANSI colors
    'chrisbra/vim-diff-enhanced',
    'linty-org/readline.nvim',
    { 'rareitems/anki.nvim', lazy = true }, -- to create anki cards
    'nvim-zh/colorful-winsep.nvim',
    -- :Nvimesweeper / :h nvimesweeper
    { 'seandewar/nvimesweeper', lazy = true },
    --  '~/pdf-scribe.nvim'  -- to annotate pdf files from nvim :PdfScribeInit
    -- PdfScribeInit
    -- vim.g.pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
    -- vim.g.pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
    -- }}}

    { 'voldikss/vim-translator', lazy = true },
    -- load 'after/colors'
    'calvinchengx/vim-aftercolors',
    -- Vim-cool disables search highlighting when you are done searching and re-enables it when you search again.
    -- ('romainl/vim-cool')
    -- 'lrangell/theme-cycler.nvim'
    -- lua repl :Luadev
    { 'bfredl/nvim-luadev', cmd = 'Luadev' },
    {
        'AckslD/nvim-FeMaco.lua',
        config = function()
            require('femaco').setup()
        end,
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
    {
        'ethanholz/nvim-lastplace',
        config = function()
            require('nvim-lastplace').setup({
                lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
                lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
                lastplace_open_folds = true,
            })
        end,
    },
    { 'rhysd/git-messenger.vim', cmd = 'GitMessenger' }, -- to show git message :GitMessenger
    { 'tweekmonster/nvim-api-viewer', cmd = 'NvimAPI' },
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
