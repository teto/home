
-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
-- local nvim_lsp = require 'nvim_lsp'
-- local configs = require'nvim_lsp/configs'
-- local lsp_status = require'lsp-status'
local plug_telescope_enabled, telescope = pcall(require, "telescope")
local plug_gitsigns_enabled, gitsigns = pcall(require, "gitsigns")

-- Only required if you have packer in your `opt` pack
-- vim.cmd [[packadd packer.nvim]]

local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

-- taken from https://github.com/neovim/neovim/pull/12368
function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end


vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

vim.g.should_show_diagnostics_in_statusline = true

local bufferline_available, bufferline = pcall(require, "bufferline")

if bufferline_available then
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

-- TODO check for telescope github extension too
if plug_telescope_enabled then
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
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
		color_devicons = true,
		use_less = true,
		set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
		file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
		grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
		qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
	}
	}
end


function contextMenu()
	local choices = {"choice 1", "choice 2"}
	require"contextmenu".open(choices, {
		callback = function(chosen)
			print("Final choice " .. choices[chosen])
		end
	})
end

if plug_gitsigns_enabled then
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

-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()]]
-- vim.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()]]

-- TELESCOPE
--
-- Fuzzy find over git files in your directory
-- telescope.git_files()

-- -- Grep as you type (requires rg currently)
-- telescope.live_grep()

-- -- Use builtin LSP to request references under cursor. Fuzzy find over results.
-- require('telescope.builtin').lsp_references()

-- -- Convert currently quickfixlist to telescope
-- require('telescope.builtin').quickfix()
