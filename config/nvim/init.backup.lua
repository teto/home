-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :

-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
-- local nvim_lsp = require 'nvim_lsp'
-- local configs = require'nvim_lsp/configs'
-- local lsp_status = require'lsp-status'
local has_telescope, telescope = pcall(require, "telescope")
local has_gitsigns, gitsigns = pcall(require, "gitsigns")
local has_compe, compe = pcall(require, "compe")

-- local packerCfg =
local packer = require "packer"
local use = packer.use

packer.init({
-- compile_path
})

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- TODOsource if it exists
local generated_init = vim.fn.stdpath('config').."/init.generated.lua"
-- print(generated_init)
if file_exists(generated_init) then
	-- for some reason it doesn't work
	-- vim.cmd ('luafile '..generated_init..' ')
end

-- use { 'haorenW1025/completion-nvim', opt = true,
-- requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
-- }
-- use { "~/telescope-frecency.nvim", }
-- 	requires = {
-- 		{'hrsh7th/vim-vsnip', opt = true},
-- 		-- {'tami5/sql.nvim', opt = false}
-- 	},
-- 	config = function()
-- 		telescope.load_extension("frecency")
-- 	end
-- }

-- provides TSContextEnable / TSContextDisable
-- shows current function on first line
-- use { 'romgrk/nvim-treesitter-context',
-- 	requires = { 'nvim-treesitter/nvim-treesitter' }
-- }
-- Packer can manage itself as an optional plugin
-- use {'wbthomason/packer.nvim', opt = true}

-- use { 'glepnir/lspsaga.nvim' }  -- builds on top of neovim lsp
use { 'edluffy/specs.nvim' }
use { 'nvim-lua/popup.nvim'  }  -- mimic vim's popupapi for neovim
use { 'nvim-lua/plenary.nvim' } -- lua utilities for neovim
-- use { 'nvim-lua/telescope.nvim' }
use { '~/telescope.nvim' }
use { 'lukas-reineke/indent-blankline.nvim', branch = "lua", opt=true}
-- Plug '~/telescope.nvim'    -- fzf-like in lua
use { 'nvim-telescope/telescope-github.nvim' }
use { 'nvim-telescope/telescope-symbols.nvim' }
use {'nvim-telescope/telescope-fzy-native.nvim'}
use { 'nvim-telescope/telescope-media-files.nvim'}
-- use "terrortylor/nvim-comment"
-- shows a lightbulb where a codeAction is available
use { 'kosayoda/nvim-lightbulb' }
-- compete with registers.nvim
use { 'gennaro-tedesco/nvim-peekup' }
use { 'nvim-telescope/telescope-packer.nvim' }
-- use { 'TimUntersberger/neogit' }
-- use { 'wfxr/minimap.vim' }
use { 'pwntester/octo.nvim',
	requires = { 'nvim-lua/popup.nvim' }

}  -- to work with github

use { 'notomo/gesture.nvim' }
-- use { 'svermeulen/vimpeccable'} -- broken ?
use { 'tjdevries/astronauta.nvim' }
use { 'npxbr/gruvbox.nvim', requires = {"rktjmp/lush.nvim"} }
use { 'onsails/lspkind-nvim' }
use { 'phaazon/hop.nvim', opt=true }
use { 'alec-gibson/nvim-tetris'}
use { 'mfussenegger/nvim-dap'}
use { 'bazelbuild/vim-bazel' , requires = { 'google/vim-maktaba' } }

-- use 'sindrets/diffview.nvim' -- :DiffviewOpen
use 'folke/which-key.nvim'

-- use 'sunjon/shade.nvim'

-- use fzf to search through diagnostics
-- use { 'ojroques/nvim-lspfuzzy'}

-- for live editing
-- use { 'jbyuki/instant.nvim' }
-- use { 'jbyuki/nabla.nvim' } -- write latex equations in ASCII
-- use { 'jbyuki/monolithic.nvim' } -- write latex equations in ASCII

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

vim.g.should_show_diagnostics_in_statusline = true

local k = require"astronauta.keymap"
local nnoremap = k.nnoremap
nnoremap { "<Leader>o", function () vim.cmd("FzfFiles") end}
nnoremap { "<Leader>g", function () vim.cmd("FzfGitFiles") end}
nnoremap { "<Leader>F", function () vim.cmd("FzfFiletypes") end}
nnoremap { "<Leader>t", function () require'telescope.builtin'.tags{} end }
nnoremap { "<Leader>C", function () require'telescope.builtin'.colorscheme{} end }
nnoremap { "<Leader>f", function () require('telescope').extensions.frecency.frecency({
	query = "toto"
}) end }
-- replace with telescope
-- nnoremap { "<Leader>t", function () vim.cmd("FzfTags") end}
-- nnoremap <Leader>h <Cmd>FzfHistory<CR>
-- nnoremap <Leader>c <Cmd>FzfCommits<CR>
-- nnoremap <Leader>C <Cmd>FzfColors<CR>


local has_bufferline, bufferline = pcall(require, "bufferline")

if has_bufferline then
	bufferline.setup{
		options = {
			view =  "default",
			-- "ordinal"
			numbers = "buffer_id",
			-- number_style = "superscript" | "",
			mappings = true,
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

local lspfuzzy_available, lspfuzzy = pcall(require, "lspfuzzy")
if lspfuzzy_available then
	lspfuzzy.setup {}
end

local has_shade, shade = pcall(require, "shade")
if has_shade then
	shade.setup({
		overlay_opacity = 70,
		opacity_step = 1,
		-- keys = {
		--   brightness_up    = '<C-Up>',
		--   brightness_down  = '<C-Down>',
		--   toggle           = '<Leader>s',
		-- }
	})
end


-- local has_neogit, neogit = pcall(require, 'neogit')
-- use with neogit.status.create(<kind>)
-- Treesitter config {{{
-- 	'nvim-treesitter/completion-treesitter' " extension of completion-nvim,
-- use { 'nvim-treesitter/nvim-treesitter' }
local enable_treesitter = false
if enable_treesitter then
	use { '~/nvim-treesitter' }
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

-- blankline  {{{
-- let g:indent_blankline_char = '|'
-- }}}

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
			prompt_position = "bottom",
			prompt_prefix = ">",
			selection_strategy = "reset",
			sorting_strategy = "descending",
			-- horizontal, vertical, center, flex
			layout_strategy = "horizontal",
			layout_defaults = {
			-- TODO add builtin options.
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
			width = 0.75,
			-- preview_cutoff = 120,
			results_height = 1,
			results_width = 0.8,
			border = {},
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
			fzy_native = {
				override_generic_sorter = true,
				override_file_sorter = true,
			},
			frecency = {
			      workspaces = {
					["home"]    = "/home/teto/home",
					["data"]    = "/home/teto/neovim",
					["jinko"] = "/home/teto/jinko",
					-- ["wiki"]    = "/home/my_username/wiki"
				},
				db_safe_mode = false,
				auto_validate = false
			}
		}
	}
	-- This will load fzy_native and have it override the default file sorter
	telescope.load_extension('fzy_native')
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
-- gitsigns {{{
if has_gitsigns then
 gitsigns.setup {
  signs = {
    add          = {hl = 'DiffAdd'   , text = '│', numhl='GitSignsAddNr'},
    change       = {hl = 'DiffChange', text = '│', numhl='GitSignsChangeNr'},
    delete       = {hl = 'DiffDelete', text = '_', numhl='GitSignsDeleteNr'},
    topdelete    = {hl = 'DiffDelete', text = '‾', numhl='GitSignsDeleteNr'},
    changedelete = {hl = 'DiffChange', text = '~', numhl='GitSignsChangeNr'},
  },
  numhl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
  },
  watch_index = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}
end
--}}}
-- vim.fn.stdpath('config')
require 'lsp_init'

-- my treesitter config
require 'myTreesitter'

-- logs are written to /home/teto/.cache/vim-lsp.log
vim.lsp.set_log_level("info")

if has_compe then

  compe.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'enable';
	throttle_time = 80;
	source_timeout = 200;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = true;

	source = {
		path = true;
		buffer = true;
		calc = true;
		nvim_lsp = true;
		nvim_lua = true;
		vsnip = true;
	};
  };
end

-- hack
local _, notifs = pcall(require, "notifications")

vim.lsp.notifier = notifs

if vim.notify then
	vim.notify = notifs.notify_external
end

local has_specs, specs = pcall(require, 'specs')
if has_specs then
	specs.setup{
		show_jumps  = true,
		min_jump = 30,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 10, -- time increments used for fade/resize effects
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
			width = 10,
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
-- options to pass to goto_next/goto_prev
-- local goto_opts = {
-- 	severity_limit = "Warning"
-- }

-- showLineDiagnostic is a wrapper around show_line_diagnostics
-- show_line_diagnostics calls open_floating_preview
-- local popup_bufnr, winnr = util.open_floating_preview(lines, 'plaintext')
-- seems like there is no way to pass options from show_line_diagnostics to open_floating_preview
-- the floating popup has "ownsyntax markdown"
function showLineDiagnostic ()
	local opts = {
		enable_popup = true;
		-- options of
		popup_opts = {

		};
	}
	-- return vim.lsp.diagnostic.show_line_diagnostics()
	vim.lsp.diagnostic.goto_prev {wrap = true }
	-- return require'lspsaga.diagnostic'.show_line_diagnostics()

end

-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.cmd [[autocmd CursorHold <buffer> lua showLineDiagnostic()]]
-- vim.cmd [[autocmd CursorMoved <buffer> lua showLineDiagnostic()]]
function lsp_show_all_diagnostics()
	local all_diagnostics = vim.lsp.diagnostic.get_all()
	vim.lsp.util.set_qflist(all_diagnostics)
end
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
