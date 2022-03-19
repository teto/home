-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- local configs = require'nvim_lsp/configs'
local has_telescope, telescope = pcall(require, "telescope")

-- local packerCfg =
local packer = require "packer"
local use, _ = packer.use, packer.use_rocks
local nnoremap = vim.keymap.set

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

-- local my_image = require('hologram.image'):new({
--	   source = '/home/teto/doctor.png',
--	   row = 11,
--	   col = 0,
-- })
-- my_image:transmit() -- send image data to terminal

-- use {
-- 	"~/telescope-frecency.nvim",
-- 	config = function ()
-- 		nnoremap ( "n", "<Leader>f", function () require('telescope').extensions.frecency.frecency({
-- 			query = "toto"
-- 		}) end )
-- 	end
-- 	}

-- use {
--	"SmiteshP/nvim-gps",
--	requires = "nvim-treesitter/nvim-treesitter",
--	config = function ()
--		-- Example config
--		local has_gps, gps = pcall(require, 'nvim-gps')
--		gps.setup({
--			icons = {
--				["class-name"] = ' ',		-- Classes and class-like objects
--				["function-name"] = ' ',	-- Functions
--				["method-name"] = ' '		-- Methods (functions inside class-like objects)
--			},
--			-- Disable any languages individually over here
--			-- Any language not disabled here is enabled by default
--			languages = {
--				-- ["bash"] = false,
--				-- ["go"] = false,
--			},
--			separator = ' > ',
--		})
--	end

-- }

-- not packaged
use{"petertriho/nvim-scrollbar",
	config = function ()
		require"scrollbar".setup({show=true})
	end
}
-- overrides vim.ui / vim.select with the backend of my choice
-- use {
--	'stevearc/dressing.nvim'
--	, config = function ()
-- require('dressing').setup({
--	 input = {
--	   -- Default prompt string
--	   default_prompt = "➤ ",

--	   -- These are passed to nvim_open_win
--	   anchor = "SW",
--	   relative = "cursor",
--	   row = 0,
--	   col = 0,
--	   border = "rounded",

--	   -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
--	   prefer_width = 40,
--	   max_width = nil,
--	   min_width = 20,

--	   -- see :help dressing_get_config
--	   get_config = nil,
--	 },
--	 select = {
--	   -- Priority list of preferred vim.select implementations
--	   backend = { "telescope", "fzf", "builtin", "nui" },

--	   -- Options for telescope selector
--	   telescope = {
--		 -- can be 'dropdown', 'cursor', or 'ivy'
--		 theme = "dropdown",
--	   },

--	   -- Options for fzf selector
--	   fzf = {
--		 window = {
--		   width = 0.5,
--		   height = 0.4,
--		 },
--	   },

--	   -- Options for nui Menu
--	   nui = {
--		 position = "50%",
--		 size = nil,
--		 relative = "editor",
--		 border = {
--		   style = "rounded",
--		 },
--		 max_width = 80,
--		 max_height = 40,
--	   },

--	   -- Options for built-in selector
--	   builtin = {
--		 -- These are passed to nvim_open_win
--		 anchor = "NW",
--		 relative = "cursor",
--		 row = 0,
--		 col = 0,
--		 border = "rounded",

--		 -- Window options
--		 winblend = 10,

--		 -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
--		 width = nil,
--		 max_width = 0.8,
--		 min_width = 40,
--		 height = nil,
--		 max_height = 0.9,
--		 min_height = 10,
--	   },

--	   -- see :help dressing_get_config
--	   get_config = nil,
--	 },
-- })	end
-- }


-- use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
-- use({
--	 "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
--	 as = "lsp_lines",
--	 config = function()

--	   require("lsp_lines").register_lsp_virtual_lines()
--	 end,
-- })

-- use 'mfussenegger/nvim-dap'
-- use {
--	"rcarriga/nvim-dap-ui"
--	, requires = {"mfussenegger/nvim-dap"}
-- }
-- use 'nvim-telescope/telescope-dap.nvim'
--

use {
	-- set virtualedit=all, select an area then call :VBox
	'jbyuki/venn.nvim'
	}


use {
	'protex/better-digraphs.nvim'
}
use {
	"rcarriga/nvim-notify"
	, config = function ()
		require("notify").setup({
			-- Animation style (see below for details)
			stages = "fade_in_slide_out",

			-- Function called when a new window is opened, use for changing win settings/config
			-- on_open = nil,
			-- Function called when a window is closed
			-- on_close = nil,
			-- Render function for notifications. See notify-render()
			-- render = "default",
			-- Default timeout for notifications
			timeout = 5000,
			-- Max number of columns for messages
			max_width = 300,
			-- Max number of lines for a message
			-- max_height = 50,

			-- For stages that change opacity this is treated as the highlight behind the window
			-- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
			background_colour = "Normal",

			-- Minimum width for notification windows
			minimum_width = 50,
		})

		vim.notify = require("notify")

	end
}
use {
	"~/neovim/nvim-lspconfig"
}

-- terminal image viewer in neovim see https://github.com/edluffy/hologram.nvim#usage for usage
use 'edluffy/hologram.nvim' -- hologram-nvim
use 'ellisonleao/glow.nvim' -- markdown preview, run :Glow
use {
	-- Show where your cursor moves
	'edluffy/specs.nvim',
	config = function ()
		local specs = require 'specs'
		specs.setup{
			show_jumps	= true,
			min_jump = 20,
			popup = {
				delay_ms = 0, -- delay before popup displays
				inc_ms = 10, -- time increments used for fade/resize effects
				blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
				width = 30,
				winhl = "PMenu",
				fader = specs.linear_fader,
				resizer = specs.shrink_resizer
			},
			ignore_filetypes = {},
			ignore_buftypes = {
				nofile = true,
			},
		}
	end

}
use {
	'code-biscuits/nvim-biscuits',
	config = function ()
	require('nvim-biscuits').setup({
	on_events = { 'InsertLeave', 'CursorHoldI' },
	cursor_line_only = true,
	default_config = {
		max_length = 12,
		min_distance = 50,
		prefix_string = " 📎 "
	},
	language_config = {
		html = { prefix_string = " 🌐 " },
		javascript = {
			prefix_string = " ✨ ",
			max_length = 80
		},
		python = { disabled = true },
		-- nix = { disabled = true }
	}
	})
end
}

-- use { 'nvim-lua/popup.nvim'	}  -- mimic vim's popupapi for neovim
-- use { 'nvim-lua/plenary.nvim' } -- lua utilities for neovim

use {
	'lukas-reineke/indent-blankline.nvim',
	config = function ()
		require("indent_blankline").setup {
			char = "│",
			buftype_exclude = {"terminal"},
			filetype_exclude = {'help'},
			space_char_blankline = " ",
			show_end_of_line = true,
			char_highlight_list = {
				"IndentBlanklineIndent1",
				"IndentBlanklineIndent2",
				"IndentBlanklineIndent3",
				"IndentBlanklineIndent4",
				"IndentBlanklineIndent5",
				"IndentBlanklineIndent6",
			},
			max_indent_increase = 1,
			indent_level = 2,
			show_first_indent_level = false,
			-- blankline_use_treesitter,
			char_list = {'.', "|", "-"},
			show_trailing_blankline_indent = false,
			show_current_context = false,
			show_current_context_start = true,
			enabled = false,
		}
	end
}
use {
	-- shows type annotations for functions in virtual text using built-in LSP client
	'jubnzv/virtual-types.nvim'
}

-- use_rocks 'plenary.nvim'
-- use { 'nvim-lua/telescope.nvim' }
use '~/telescope.nvim'	  -- fzf-like in lua
use { 'nvim-telescope/telescope-github.nvim' }
use { 'nvim-telescope/telescope-symbols.nvim' }
use {'nvim-telescope/telescope-fzy-native.nvim'}
use { 'nvim-telescope/telescope-media-files.nvim'}
-- use "terrortylor/nvim-comment"
-- shows a lightbulb where a codeAction is available
-- use { 'kosayoda/nvim-lightbulb',
--	config = function ()
--		vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
--	end
-- }
-- using packer.nvim
use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

-- compete with registers.nvim
-- https://github.com/gelguy/wilder.nvim
-- use { 'gelguy/wilder.nvim' }
use { 'gennaro-tedesco/nvim-peekup' }
-- use { 'nvim-telescope/telescope-packer.nvim' }
--use { 'TimUntersberger/neogit',
--	config = function ()
--		vim.defer_fn (
--		function ()
--		require 'neogit'.setup {
--		disable_signs = false,
--		disable_context_highlighting = false,
--		disable_commit_confirmation = false,
--		-- customize displayed signs
--		signs = {
--			-- { CLOSED, OPENED }
--			section = { ">", "v" },
--			item = { ">", "v" },
--			hunk = { "", "" },
--		},
--		integrations = {
--			-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs you can use `sindrets/diffview.nvim`.
--			-- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
--			--
--			-- Requires you to have `sindrets/diffview.nvim` installed.
--			-- use {
--			--	 'TimUntersberger/neogit',
--			--	 requires = {
--			--	   'nvim-lua/plenary.nvim',
--			--	   'sindrets/diffview.nvim'
--			--	 }
--			-- }
--			--
--			diffview = false
--		},
--		-- override/add mappings
--		mappings = {
--			-- modify status buffer mappings
--			status = {
--			-- Adds a mapping with "B" as key that does the "BranchPopup" command
--			["B"] = "BranchPopup",
--			-- Removes the default mapping of "s"
--			["s"] = "",
--			}
--		}

--	}
--end)
--end
--}
-- use { 'wfxr/minimap.vim' }
-- use {
--	-- to work with github
--	'pwntester/octo.nvim'
-- -- , requires = { 'nvim-lua/popup.nvim' }
-- }

use { 'notomo/gesture.nvim' }
-- use { 'svermeulen/vimpeccable'} -- broken ?
-- use { 'npxbr/gruvbox.nvim'
-- using teto instead to test packer luarocks support
-- use_rocks { 'teto/gruvbox.nvim'
	-- , requires = {"rktjmp/lush.nvim"}
	-- }
use { 'onsails/lspkind-nvim' }
-- use {
--	'phaazon/hop.nvim',
--	config = function ()
--		require 'hop'.setup {}
--	end
-- }   -- sneak.vim equivalent

use { 'alec-gibson/nvim-tetris', opt = true }

-- use { 'mfussenegger/nvim-dap'} -- debug adapter protocol
use {
	-- a plugin for interacting with bazel :Bazel build //some/package:sometarget
	-- supports autocompletion
	'bazelbuild/vim-bazel' , requires = { 'google/vim-maktaba' }
}
use 'bazelbuild/vim-ft-bzl'
use {
	'chipsenkbeil/distant.nvim'
	, config = function()
		require('distant').setup {
		-- Applies Chip's personal settings to every machine you connect to
		--
		-- 1. Ensures that distant servers terminate with no connections
		-- 2. Provides navigation bindings for remote directories
		-- 3. Provides keybinding to jump into a remote file's parent directory
		['*'] = require('distant.settings').chip_default()
		}
	end
}
use {
	'matbme/JABS.nvim',
	config = function ()
		require 'jabs'.setup {
			position = 'center', -- center, corner
			width = 50,
			height = 10,
			border = 'shadow', -- none, single, double, rounded, solid, shadow, (or an array or chars)

			-- the options below are ignored when position = 'center'
			col = 0,
			row = 0,
			anchor = 'NW', -- NW, NE, SW, SE
			relative = 'win', -- editor, win, cursor
		}
	end
}
-- use {
--	'ggandor/lightspeed.nvim',
--	config = function ()
--		require'lightspeed'.setup {
--		-- This can get _really_ slow if the window has a lot of content,
--		-- turn it on only if your machine can always cope with it.
--		jump_to_unique_chars = false,
--		match_only_the_start_of_same_char_seqs = true,
--		limit_ft_matches = 5,
--		-- x_mode_prefix_key = '<c-x>',
--		substitute_chars = { ['\r'] = '¬' },
--		instant_repeat_fwd_key = nil,
--		instant_repeat_bwd_key = nil,
--		-- If no values are given, these will be set at runtime,
--		-- based on `jump_to_first_match`.
--		labels = nil,
--		cycle_group_fwd_key = nil,
--		cycle_group_bwd_key = nil,
--		}
--	end
-- }
-- use 'mrjones2014/dash.nvim' -- only for dash it seems
use {
  "folke/trouble.nvim",
--	 requires = "kyazdani42/nvim-web-devicons",
	-- Trouble {{{
	config = function ()
	require'trouble'.setup {
	position = "bottom", -- position of the list can be: bottom, top, left, right}}}
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	-- icons = false, -- use devicons for filenames
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
	end

}
-- use {
--	 'kdheepak/tabline.nvim',
--	 config = function()
--	   require'tabline'.setup {
--		 -- Defaults configuration options
--		 enable = true
--	   }
--	   vim.cmd[[
--		 set guioptions-=e " Use showtabline in gui vim
--		 set sessionoptions+=tabpages,globals " store tabpages and globals in session
--	   ]]
--	 end,
--	 requires = { { 'hoob3rt/lualine.nvim', opt=true }, 'kyazdani42/nvim-web-devicons' }
-- }
use 'MunifTanjim/nui.nvim' -- to create UIs
-- use 'rafamadriz/friendly-snippets'

use {
	'hrsh7th/nvim-cmp',
-- use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
-- use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

	requires = {
		-- "quangnguyen30192/cmp-nvim-ultisnips",
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-vsnip',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/vim-vsnip',
		'hrsh7th/vim-vsnip-integ',
		'rafamadriz/friendly-snippets'
	},
	config = function ()

  -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
  --   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- }
	local cmp = require 'cmp'
	cmp.setup({
	snippet = {
	  expand = function(args)
		-- For `vsnip` user.
		vim.fn["vsnip#anonymous"](args.body)

		-- For `luasnip` user.
		-- require('luasnip').lsp_expand(args.body)

		-- For `ultisnips` user.
		-- vim.fn["UltiSnips#Anon"](args.body)
	  end,
	},
	mapping = {
	  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-f>'] = cmp.mapping.scroll_docs(4),
	  ['<C-Space>'] = cmp.mapping.complete(),
	  ['<C-e>'] = cmp.mapping.close(),
	  ['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
	  -- { name = 'nvim_lsp' },

	  -- For vsnip user.
	  { name = 'vsnip' },

	  -- For luasnip user.
	  -- { name = 'luasnip' },

	  -- For ultisnips user.
	  -- { name = 'ultisnips' },

	  { name = 'buffer' },
	  { name = 'neorg' },
	}
  })

  end
}

-- use {
--	   "nvim-neorg/neorg",
--	   config = function()
--		   require('neorg').setup {
--			   -- Tell Neorg what modules to load
--			   load = {
--				   ["core.defaults"] = {}, -- Load all the default modules
--				   ["core.keybinds"] = { -- Configure core.keybinds
--					   config = {
--						   default_keybinds = true, -- Generate the default keybinds
--						   neorg_leader = "<Leader>n" -- This is the default if unspecified
--					   }
--				   },
--				   ["core.norg.concealer"] = {}, -- Allows for use of icons
--				   ["core.norg.completion"] = {
--					config = {
--						engine =  "nvim-cmp"
--					}
--				}, -- Allows for use of icons
--				   ["core.norg.dirman"] = { -- Manage your directories with Neorg
--					   config = {
--						   workspaces = {
--							   my_workspace = "~/neorg"
--						   }
--					   }
--				   }
--			   },
--		   }
--	   end,
--	   requires = "nvim-lua/plenary.nvim"
-- }
use 'ray-x/lsp_signature.nvim' -- display function signature in insert mode
use { 'Pocco81/AutoSave.nvim' -- :ASToggle /AsOn / AsOff
	, config = function ()
		local autosave = require("autosave")
		autosave.setup({
				enabled = true,
				execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
				events = {"InsertLeave"},
				conditions = {
					exists = true,
					filetype_is_not = {},
					modifiable = true
				},
				write_all_buffers = false,
				on_off_commands = true,
				clean_command_line_interval = 2500
			}
		)
end
}
-- use 'sindrets/diffview.nvim' -- :DiffviewOpen
use 'rlch/github-notifications.nvim'
use {
	'nvim-lualine/lualine.nvim' -- fork of hoob3rt/lualine
	, requires = { 'arkav/lualine-lsp-progress' }
	, config = function ()
		require'lualine'.setup {
		options = {
			icons_enabled = false,
			-- theme = 'gruvbox',
			component_separators = {left='', right=''},
			section_separators = {left='', right=''},
			separators = {left='', right=''},
			-- disabled_filetypes = {}
		},
		sections = {
			lualine_a = {'branch'},
			lualine_b = {
				-- path=2 => absolute path
				{'filename', path = 1 }
			},

			lualine_c = {
				'lsp_progress'
				-- component
				-- {'lsp_progress', display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }}}
				-- ,  gps.get_location, condition = gps.is_available
			},
			lualine_x = {
				-- 'encoding', 'fileformat', 'filetype'
			},
			lualine_y = {'diagnostics', 'progress'}, -- progress = %progress in file
			lualine_z = {'location'}
		},
		-- inactive_sections = {
		--	 lualine_a = {},
		--	 lualine_b = {},
		--	 lualine_c = {'filename', 'lsp_progress'},
		--	 lualine_x = {'location'},
		--	 lualine_y = {},
		--	 lualine_z = {}
		-- },
		tabline = {},
		extensions = { 'fzf', 'fugitive'}
		}
	end
}


-- Inserts a component in lualine_c at left section
-- local function ins_left(component)
--	 table.insert(config.sections.lualine_c, component)
-- end

-- -- Inserts a component in lualine_x ot right section
-- local function ins_right(component)
--	 table.insert(config.sections.lualine_x, component)
-- end

-- broken
--use {
--	'sunjon/shade.nvim',
--	config = function ()
--		require'shade'.setup({
--			overlay_opacity = 70,
--			opacity_step = 1,
--			-- keys = {
--			--	 brightness_up	  = '<C-Up>',
--			--	 brightness_down  = '<C-Down>',
--			--	 toggle			  = '<Leader>s',
--			-- }
--		})
--	end
--}

-- use fzf to search through diagnostics
-- use { 'ojroques/nvim-lspfuzzy'}

-- for live editing
-- use { 'jbyuki/instant.nvim' }
-- use { 'jbyuki/nabla.nvim' } -- write latex equations in ASCII
-- use { 'jbyuki/monolithic.nvim' } -- write latex equations in ASCII

vim.cmd([[colorscheme sonokai]])

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

vim.g.should_show_diagnostics_in_statusline = true

vim.keymap.set ('n', "<Leader>o", function () vim.cmd("FzfFiles") end)
vim.keymap.set ('n', "<Leader>g", function () vim.cmd("FzfGitFiles") end)
vim.keymap.set ('n', "<Leader>F", function () vim.cmd("FzfFiletypes") end)
vim.keymap.set ('n', "<Leader>h", function () vim.cmd("FzfHistory") end)
vim.keymap.set ('n', "<Leader>t", function () require'telescope.builtin'.tags{} end )
vim.keymap.set ('n', "<Leader>C", function () require'telescope.builtin'.colorscheme{ enable_preview = true; } end )

nnoremap ( "n", "<Leader>ca", function () vim.lsp.buf.code_action{} end )

nnoremap ( "n", "<leader>S",  function() require('spectre').open() end )

-- replace with telescope
-- nnoremap { "<Leader>t", function () vim.cmd("FzfTags") end}
-- nnoremap <Leader>h <Cmd>FzfHistory<CR>
-- nnoremap <Leader>c <Cmd>FzfCommits<CR>
-- nnoremap <Leader>C <Cmd>FzfColors<CR>

-- use 'folke/which-key.nvim' -- :WhichKey

local has_whichkey, wk = pcall(require, "which-key")
if has_whichkey then
  wk.setup {
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
	}
end

-- set tagfunc=v:lua.vim.lsp.tagfunc


-- since it was not merge yet
if vim.ui then

vim.ui.pick = function (entries, opts)
	acceptable_files = vim.tbl_values(entries)

	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	print("use my custom function")
	local prompt = "default prompt"
	if opts ~= nil then prompt = opts.prompt end

	local selection = pickers.new({
	prompt_title = prompt,
	finder = finders.new_table {
	results = acceptable_files,
	entry_maker = function(line)
	  return {
		value = line,

		ordinal = line,
		display = line,
	--	   filename = base_directory .. "/data/memes/planets/" .. line,
	  }
	end,

	attach_mappings = function(prompt_bufnr)
		actions.select_default:replace(function()

			selection = action_state.get_selected_entry()
			actions.close(prompt_bufnr)
			print("Selected", selection)
			return selection
		end)
	  return true
	end,
	}
	}):find()
	-- print("Selected", selection)

	return selection
end
end


-- review locally github PRs
local has_octo, octo = pcall(require, "octo")
if has_octo then
	octo.setup({
	default_remote = {"upstream", "origin"}; -- order to try remotes
	reaction_viewer_hint_icon = "";		 -- marker for user reactions
	user_icon = " ";						 -- user icon
	timeline_marker = "";					 -- timeline marker
	timeline_indent = "2";					 -- timeline indentation
	right_bubble_delimiter = "";			 -- Bubble delimiter
	left_bubble_delimiter = "";			 -- Bubble delimiter
	github_hostname = "";					 -- GitHub Enterprise host
	snippet_context_lines = 4;				 -- number or lines around commented lines
	file_panel = {
		size = 10,							   -- changed files panel rows
		use_icons = true					   -- use web-devicons in file panel
	},
	mappings = {--{{{
		issue = {--{{{
		close_issue = "<space>ic",			 -- close issue
		reopen_issue = "<space>io",			 -- reopen issue
		list_issues = "<space>il",			 -- list open issues on same repo
		reload = "<C-r>",					 -- reload issue
		open_in_browser = "<C-b>",			 -- open issue in browser
		copy_url = "<C-y>",					 -- copy url to system clipboard
		add_assignee = "<space>aa",			 -- add assignee
		remove_assignee = "<space>ad",		 -- remove assignee
		create_label = "<space>lc",			 -- create label
		add_label = "<space>la",			 -- add label
		remove_label = "<space>ld",			 -- remove label
		goto_issue = "<space>gi",			 -- navigate to a local repo issue
		add_comment = "<space>ca",			 -- add comment
		delete_comment = "<space>cd",		 -- delete comment
		next_comment = "]c",				 -- go to next comment
		prev_comment = "[c",				 -- go to previous comment
		react_hooray = "<space>rp",			 -- add/remove 🎉 reaction
		react_heart = "<space>rh",			 -- add/remove ❤️ reaction
		react_eyes = "<space>re",			 -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",		 -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",	 -- add/remove 👎 reaction
		react_rocket = "<space>rr",			 -- add/remove 🚀 reaction
		react_laugh = "<space>rl",			 -- add/remove 😄 reaction
		react_confused = "<space>rc",		 -- add/remove 😕 reaction
		},--}}}
		pull_request = {--{{{
		checkout_pr = "<space>po",			 -- checkout PR
		merge_pr = "<space>pm",				 -- merge PR
		list_commits = "<space>pc",			 -- list PR commits
		list_changed_files = "<space>pf",	 -- list PR changed files
		show_pr_diff = "<space>pd",			 -- show PR diff
		add_reviewer = "<space>va",			 -- add reviewer
		remove_reviewer = "<space>vd",		 -- remove reviewer request
		close_issue = "<space>ic",			 -- close PR
		reopen_issue = "<space>io",			 -- reopen PR
		list_issues = "<space>il",			 -- list open issues on same repo
		reload = "<C-r>",					 -- reload PR
		open_in_browser = "<C-b>",			 -- open PR in browser
		copy_url = "<C-y>",					 -- copy url to system clipboard
		add_assignee = "<space>aa",			 -- add assignee
		remove_assignee = "<space>ad",		 -- remove assignee
		create_label = "<space>lc",			 -- create label
		add_label = "<space>la",			 -- add label
		remove_label = "<space>ld",			 -- remove label
		goto_issue = "<space>gi",			 -- navigate to a local repo issue
		add_comment = "<space>ca",			 -- add comment
		delete_comment = "<space>cd",		 -- delete comment
		next_comment = "]c",				 -- go to next comment
		prev_comment = "[c",				 -- go to previous comment
		react_hooray = "<space>rp",			 -- add/remove 🎉 reaction
		react_heart = "<space>rh",			 -- add/remove ❤️ reaction
		react_eyes = "<space>re",			 -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",		 -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",	 -- add/remove 👎 reaction
		react_rocket = "<space>rr",			 -- add/remove 🚀 reaction
		react_laugh = "<space>rl",			 -- add/remove 😄 reaction
		react_confused = "<space>rc",		 -- add/remove 😕 reaction
		},--}}}
		review_thread = {--{{{
		goto_issue = "<space>gi",			 -- navigate to a local repo issue
		add_comment = "<space>ca",			 -- add comment
		add_suggestion = "<space>sa",		 -- add suggestion
		delete_comment = "<space>cd",		 -- delete comment
		next_comment = "]c",				 -- go to next comment
		prev_comment = "[c",				 -- go to previous comment
		select_next_entry = "]q",			 -- move to previous changed file
		select_prev_entry = "[q",			 -- move to next changed file
		close_review_tab = "<C-c>",			 -- close review tab
		react_hooray = "<space>rp",			 -- add/remove 🎉 reaction
		react_heart = "<space>rh",			 -- add/remove ❤️ reaction
		react_eyes = "<space>re",			 -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",		 -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",	 -- add/remove 👎 reaction
		react_rocket = "<space>rr",			 -- add/remove 🚀 reaction
		react_laugh = "<space>rl",			 -- add/remove 😄 reaction
		react_confused = "<space>rc",		 -- add/remove 😕 reaction
		},--}}}
		submit_win = {--{{{
		approve_review = "<C-a>",			 -- approve review
		comment_review = "<C-m>",			 -- comment review
		request_changes = "<C-r>",			 -- request changes review
		close_review_tab = "<C-c>",			 -- close review tab
		},--}}}
		review_diff = {--{{{
		add_review_comment = "<space>ca",	 -- add a new review comment
		add_review_suggestion = "<space>sa", -- add a new review suggestion
		focus_files = "<leader>e",			 -- move focus to changed file panel
		toggle_files = "<leader>b",			 -- hide/show changed files panel
		next_thread = "]t",					 -- move to next thread
		prev_thread = "[t",					 -- move to previous thread
		select_next_entry = "]q",			 -- move to previous changed file
		select_prev_entry = "[q",			 -- move to next changed file
		close_review_tab = "<C-c>",			 -- close review tab
		toggle_viewed = "<leader><space>",	 -- toggle viewer viewed state
		},--}}}
		file_panel = {--{{{
		next_entry = "j",					 -- move to next changed file
		prev_entry = "k",					 -- move to previous changed file
		select_entry = "<cr>",				 -- show selected changed file diffs
		refresh_files = "R",				 -- refresh changed files panel
		focus_files = "<leader>e",			 -- move focus to changed file panel
		toggle_files = "<leader>b",			 -- hide/show changed files panel
		select_next_entry = "]q",			 -- move to previous changed file
		select_prev_entry = "[q",			 -- move to next changed file
		close_review_tab = "<C-c>",			 -- close review tab
		toggle_viewed = "<leader><space>",	 -- toggle viewer viewed state
		}--}}}
	}--}}}
	})
end

local orig_ref_handler = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = function(...)
  orig_ref_handler(...)
  vim.cmd [[ wincmd p ]]
end


local has_bufferline, bufferline = pcall(require, "bufferline")
if has_bufferline then
	bufferline.setup{
		options = {
			view =	"default",
			-- "ordinal"
			numbers = "buffer_id",
			-- number_style = "superscript" | "",
			-- mappings = true,
			-- buffer_close_icon= '',
			modified_icon = '●',
			close_icon = '',
			left_trunc_marker = '',
			right_trunc_marker = '',
			-- max_name_length = 18,
			-- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
			-- tab_size = 18,
			show_buffer_close_icons = false,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- -- can also be a table containing 2 custom separators
			-- -- [focused and unfocused]. eg: { '|', '|' }
			-- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
			separator_style = "slant",
			-- enforce_regular_tabs = false | true,
			always_show_bufferline = false,
			-- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
			-- -- add custom logic
			-- return buffer_a.modified > buffer_b.modified
			-- end
		}
	}
end


-- Treesitter config {{{
--	'nvim-treesitter/completion-treesitter' " extension of completion-nvim,
-- use { 'nvim-treesitter/nvim-treesitter' }
local enable_treesitter = false
if enable_treesitter then
	use { 'nvim-treesitter/nvim-treesitter' }
	use {
		'nvim-treesitter/playground',
		requires = { 'nvim-treesitter/nvim-treesitter' }
	}
	use {
		'p00f/nvim-ts-rainbow',
		requires = { 'nvim-treesitter/nvim-treesitter' }
	}
	use { 'nvim-treesitter/nvim-treesitter-textobjects' }
end
--}}}

-- telescope {{{
-- TODO check for telescope github extension too
if has_telescope then
	-- telescope.load_extension('ghcli')
	local actions = require('telescope.actions')
	telescope.setup{
		defaults = {
			mappings = {
				i = {
					-- -- To disable a keymap, put [map] = false
					-- -- So, to not map "<C-n>", just put
					-- ["<c-x>"] = false,
					-- -- Otherwise, just set the mapping to the function that you want it to be.
					-- ["<C-i>"] = actions.goto_file_selection_split,
					-- -- Add up multiple actions
					-- ["<CR>"] = actions.goto_file_selection_edit + actions.center,
					-- -- You can perform as many actions in a row as you like
					-- ["<CR>"] = actions.goto_file_selection_edit + actions.center + my_cool_custom_action,
					["<esc>"] = actions.close
				},
				n = {
					["<esc>"] = actions.close
				},
			},
			vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case'
			},
			prompt_prefix = ">",
			scroll_strategy = "limit", -- or cycle
			selection_strategy = "reset",
			sorting_strategy = "descending",
			-- horizontal, vertical, center, flex
			layout_strategy = "horizontal",
			layout = {
				width = 0.75,
				prompt_position = "bottom",
			},

			file_ignore_patterns = {},
			-- get_generic_fuzzy_sorter not very good, doesn't select an exact match
			-- get_fzy_sorter
			-- https://github.com/nvim-telescope/telescope.nvim#sorters
			-- generic_sorter =  require'telescope.sorters'.get_levenshtein_sorter,
			generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
			file_sorter =  require'telescope.sorters'.get_fuzzy_file,
			shorten_path = false,
			winblend = 0,
			-- preview_cutoff = 120,
			border = true,
			path_display='shorten',
			-- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
			color_devicons = true,
			-- use_less = true,
			-- file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
			grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
			qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

			-- Developer configurations: Not meant for general override
			buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
		},
		extensions = {
			fzf = {
				fuzzy = true,					 -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true,	 -- override the file sorter
				case_mode = "smart_case",		 -- or "ignore_case" or "respect_case"
											-- the default case_mode is "smart_case"
			},
			fzy_native = {
				override_generic_sorter = false,
				override_file_sorter = false,
			},
			 frecency = {
				workspaces = {
					["home"]	= "/home/teto/home",
					["data"]	= "/home/teto/neovim",
					["jinko"]	= "/home/teto/jinko",
					-- ["wiki"]    = "/home/my_username/wiki"
				},
				show_scores = true,
				show_unindexed = true,
				ignore_patterns = {"*.git/*", "*/tmp/*"},
				db_safe_mode = true,
				auto_validate = false,
				devicons_disabled = true
			 }
		}
	}
	-- This will load fzy_native and have it override the default file sorter
	telescope.load_extension('fzf')
	-- telescope.load_extension('fzy_native')
	telescope.load_extension("notify")
	telescope.load_extension("frecency")

	-- TODO add autocmd
	-- User TelescopePreviewerLoaded
end
--}}}

-- nvim-comment {{{
-- replace vim-commentary
-- require('nvim_comment').setup()
--}}}

function contextMenu()
	local choices = {"choice 1", "choice 2"}
	require"contextmenu".open(choices, {
		callback = function(chosen)
			print("Final choice " .. choices[chosen])
		end
	})
end
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
	-- disabled because too big in haskell
  virtual_lines = false,
  virtual_text = true;
  -- {
	  -- severity = { min = vim.diagnostic.severity.WARN }
  -- },
  signs = true,
  severity_sort = true
})

require 'teto.lsp'

-- my treesitter config
require 'teto.treesitter'

-- logs are written to /home/teto/.cache/vim-lsp.log
vim.lsp.set_log_level("info")

-- hack
local _, notifs = pcall(require, "notifications")

vim.lsp.notifier = notifs

-- showLineDiagnostic is a wrapper around show_line_diagnostics
-- show_line_diagnostics calls open_floating_preview
-- local popup_bufnr, winnr = util.open_floating_preview(lines, 'plaintext')
-- seems like there is no way to pass options from show_line_diagnostics to open_floating_preview
-- the floating popup has "ownsyntax markdown"
function showLineDiagnostic ()
	-- local opts = {
	--	enable_popup = true;
	--	-- options of
	--	popup_opts = {
	--	};
	-- }
	-- return vim.lsp.diagnostic.show_line_diagnostics()
	vim.diagnostic.goto_prev {wrap = true }
	-- return require'lspsaga.diagnostic'.show_line_diagnostics()
end

-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.cmd [[autocmd CursorHold <buffer> lua showLineDiagnostic()]]
-- vim.cmd [[autocmd CursorMoved <buffer> lua showLineDiagnostic()]]
-- function lsp_show_all_diagnostics()
--	local all_diagnostics = vim.lsp.diagnostic.get_all()
--	vim.lsp.util.set_qflist(all_diagnostics)
-- end
vim.opt.background = "dark" -- or "light" for light mode


-- TODO add a command to select a ref (from telescope ?) and call Gitsigns change_base
-- afterwards


-- local Menu = require("nui.menu")

-- function create_menu ()

-- local menu = Menu({
--	 relative = "cursor",
--	 border = {
--	   style = "rounded",
--	   highlight = "Normal",
--	   text = {
--		 top = "[Sample Menu]",
--		 top_align = "left",
--	   },
--	 },
--	 position = {
--	   row = 1,
--	   col = 0,
--	 },
--	 highlight = "Normal:Normal",
-- }, {
--	 lines = {
--	   Menu.separator("Group One"),
--	-- TODO print status when possible
--	   Menu.item("Toggle obsession", { func = function() vim.cmd("Obsession") end}),
--	   Menu.item("Toggle autosave", { func = function() vim.cmd("ASToggle") end}),
--	   Menu.item("Toggle indentlines", { func = function() vim.cmd('IndentBlanklineToggle!') end}),
--	   Menu.item("Search and replace", { func = function () require("spectre").open() end}),
--	   Menu.separator("LSP"),
--	   Menu.item("Code action", { func = function() vim.lsp.buf.code_action() end}),
--	   Menu.item("Search references", { func = function() vim.lsp.buf.references() end}),
--	   Menu.item("Definition", { func = function() vim.lsp.buf.definition() end}),
--	   Menu.item("Workspace symbols", { func = function() vim.lsp.buf.workspace_symbol() end}),
--	   Menu.item("Rename", { func = function() vim.lsp.buf.rename() end}),
--	   Menu.item("Format", { func = function() vim.lsp.buf.formatting_sync(nil, 1000) end}),

--	 },
--	 max_width = 200,
--	 max_height = 30,
--	 separator = {
--	   char = "-",
--	   text_align = "right",
--	 },
--	 keymap = {
--	   focus_next = { "j", "<Down>", "<Tab>" },
--	   focus_prev = { "k", "<Up>", "<S-Tab>" },
--	   close = { "<Esc>", "<C-c>" },
--	   submit = { "<CR>", "<Space>" },
--	 },
--	 on_close = function()
--	   print("CLOSED")
--	 end,
--	 on_submit = function(item)
--	   -- print("SUBMITTED", vim.inspect(item))
--	item.func()
--	 end
-- })
-- menu:mount()
-- menu:map("n", "l", menu.menu_props.on_submit, { noremap = true, nowait = true })
-- menu:on(vim.event.BufLeave, menu.menu_props.on_close, { once = true })
-- end

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

menu_add = function(name, command)

   res = vim.cmd ([[menu ]]..name..[[ ]]..command)
   -- print(res)
end

menu_add("LSP.Declaration", 'lua vim.lsp.buf.declaration()')
menu_add("LSP.Definition", 'lua vim.lsp.buf.definition()')
menu_add("LSP.Hover", 'lua vim.lsp.buf.references()')
menu_add("LSP.Hover", 'lua vim.lsp.buf.references()')

menu_add("Toggle.Minimap", 'MinimapToggle')
menu_add("Toggle.Obsession", 'Obsession')
menu_add("Toggle.Blanklines", 'IndentBlanklineToggle')
-- menu_add("Toggle.Biscuits", 'lua require("nvim-biscuits").toggle_biscuits()')

menu_add("REPL.Send line", [[lua require'luadev'.exec(vim.api.nvim_get_current_line())]])
-- menu_add('REPL.Send selection ', 'call <SID>luadev_run_operator(v:true)')

menu_add('Diagnostic.Display_in_QF', 'lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })')
menu_add('Diagnostic.Set_severity_to_warning', 'lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})')
menu_add('Diagnostic.Set_severity_to_all', 'lua vim.diagnostic.config({virtual_text = { severity = nil }})')

menu_add("Search.Search_and_replace", 'lua require("spectre").open()')

menu_add("Rest.RunRequest", "RestNvim")
-- menu_add("Search.Search\ in\ current\ Buffer", :Grepper -switch -buffer")
-- menu_add("Search.Search\ across\ Buffers :Grepper -switch -buffers")
-- menu_add("Search.Search\ across\ directory :Grepper")
-- menu_add("Search.Autoopen\ results :let g:grepper.open=1<CR>")
-- menu_add("Tabs.S2 :set  tabstop=2 softtabstop=2 sw=2<CR>")
-- menu_add("Tabs.S4 :set ts=4 sts=4 sw=4<CR>")
-- menu_add("Tabs.S6 :set ts=6 sts=6 sw=6<CR>")
-- menu_add("Tabs.S8 :set ts=8 sts=8 sw=8<CR>")
-- menu_add("Tabs.SwitchExpandTabs :set expandtab!")

-- menu_add("DAP.Add breakpoint", 'lua require"dap".toggle_breakpoint()')
-- menu_add("DAP.Continue", 'lua require"dap".continue()')
-- menu_add("DAP.Open repl", 'lua require"dap".repl.open()')

function open_contextual_menu()
-- getcurpos()	Get the position of the cursor.  This is like getpos('.'), but
--		includes an extra "curswant" in the list:
--			[0, lnum, col, off, curswant] ~
--		The "curswant" number is the preferred column when moving the
--		cursor vertically.	Also see |getpos()|.
--		The first "bufnum" item is always zero.

	local curpos = vim.fn.getcurpos()

	menu_opts = {
		kind = 'menu',
		prompt = 'Main menu',
		experimental_mouse = true,
		position = {
		  screenrow = curpos[2] ,
		  screencol = curpos[3]
		},
		-- ignored
		-- width = 200,
		-- height = 300,
	}

	-- print('### ' ..res)
	require'stylish'.ui_menu(
		vim.fn.menu_get(''),
		menu_opts,
		function(res) vim.cmd(res) end
	)
end

vim.api.nvim_set_keymap(
  'n',
  '<F1>',
  "<Cmd>lua open_contextual_menu()<CR>",
  { noremap = true, silent = false }
)
-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )

vim.o.swapfile = false


-- lua vim.diagnostic.setqflist({open = tru, severity = { min = vim.diagnostic.severity.WARN } })