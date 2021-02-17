-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :

-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
-- local nvim_lsp = require 'nvim_lsp'
-- local configs = require'nvim_lsp/configs'
-- local lsp_status = require'lsp-status'
local has_telescope, telescope = pcall(require, "telescope")
local has_gitsigns, gitsigns = pcall(require, "gitsigns")
local has_compe, compe = pcall(require, "compe")
local notifs = require "notifications"

-- Only required if you have packer in your `opt` pack
-- vim.cmd [[packadd packer.nvim]]

-- local packerCfg =
local packer = require "packer"
local use = packer.use
packer.init()

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- TODOsource if it exists
local generated_init = "~/.config/nvim/init.generated.lua"
if file_exists(generated_init) then
	vim.cmd.luafile( generated_init)
end

-- use { 'haorenW1025/completion-nvim', opt = true,
-- requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
-- }
-- use {
-- 	"nvim-telescope/telescope-frecency.nvim",
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

-- use "terrortylor/nvim-comment"
-- shows a lightbulb where a codeAction is available
use { 'kosayoda/nvim-lightbulb' }
use { 'gennaro-tedesco/nvim-peekup' }
use { 'nvim-telescope/telescope-packer.nvim' }
-- use { 'TimUntersberger/neogit' }
use { 'wfxr/minimap.vim' }
-- 	'nvim-treesitter/completion-treesitter' " extension of completion-nvim,
-- use { 'nvim-treesitter/nvim-treesitter' }
use {
	'nvim-treesitter/playground',
	requires = { 'nvim-treesitter/nvim-treesitter' }
}
use {
	'p00f/nvim-ts-rainbow',
	requires = { 'nvim-treesitter/nvim-treesitter' }
}
use { 'nvim-treesitter/nvim-treesitter-textobjects' }
use { 'notomo/gesture.nvim' }
-- use { 'svermeulen/vimpeccable'} -- broken ?
use { 'tjdevries/astronauta.nvim' }

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

local has_neogit, neogit = pcall(require, 'neogit')
-- use with neogit.status.create(<kind>)

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
		layout_strategy = "horizontal",
		layout_defaults = {
		-- TODO add builtin options.
		},
		file_sorter =  require'telescope.sorters'.get_fuzzy_file,
		file_ignore_patterns = {},
		generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
		shorten_path = true,
		winblend = 0,
		width = 0.75,
		preview_cutoff = 120,
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
	}
	}
	telescope.load_extension("frecency")
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
	debug = false;
	min_length = 1;
	preselect = 'disable'; -- 'enable' || 'disable' || 'always';
	-- throttle_time = ... number ...;
	-- source_timeout = ... number ...;
	-- incomplete_delay = ... number ...;
	allow_prefix_unmatch = false;

	source = {
		path = true;
		buffer = true;
		vsnip = true;
		nvim_lsp = true;
		-- nvim_lua = { ... overwrite source configuration ... };
		};
	};
end

-- hack
vim.lsp.notifier = notifs

-- if we are running my fork that has vim.notify
if vim.notify then

	vim.notify = notifs.notify_external
end


-- options to pass to goto_next/goto_prev
local goto_opts = {
	severity_limit = "Warning"
}

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
	-- vim.lsp.diagnostic.goto_prev {wrap = true }
	return require'lspsaga.diagnostic'.show_line_diagnostics()

end

-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
vim.cmd [[autocmd CursorHold <buffer> lua showLineDiagnostic()]]
-- vim.cmd [[autocmd CursorMoved <buffer> lua showLineDiagnostic()]]
