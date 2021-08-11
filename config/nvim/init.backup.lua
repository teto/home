-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :

-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
-- local nvim_lsp = require 'nvim_lsp'
-- local configs = require'nvim_lsp/configs'
-- local lsp_status = require'lsp-status'
local has_telescope, telescope = pcall(require, "telescope")

-- local packerCfg =
local packer = require "packer"
local use, use_rocks = packer.use, packer.use_rocks

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
use {'kristijanhusak/orgmode.nvim', config = function()
	-- it maps <leader>oc
        -- require('orgmode').setup{}
end
}
use 'windwp/nvim-spectre' -- search & replace 
use { 'edluffy/specs.nvim' } -- Show where your cursor moves
use { 'nvim-lua/popup.nvim'  }  -- mimic vim's popupapi for neovim
-- use { 'nvim-lua/plenary.nvim' } -- lua utilities for neovim
use {
    'NTBBloodbath/rest.nvim',
    -- requires = { 'nvim-lua/plenary.nvim' }
}
-- use_rocks 'plenary.nvim'
-- use { 'nvim-lua/telescope.nvim' }
use '~/telescope.nvim'    -- fzf-like in lua
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
use { 'TimUntersberger/neogit' }
-- use { 'wfxr/minimap.vim' }
use { 'pwntester/octo.nvim',
	requires = { 'nvim-lua/popup.nvim' }

}  -- to work with github

use { 'notomo/gesture.nvim' }
-- use { 'svermeulen/vimpeccable'} -- broken ?
use { 'tjdevries/astronauta.nvim' }
use { 'npxbr/gruvbox.nvim', requires = {"rktjmp/lush.nvim"} }
use { 'onsails/lspkind-nvim' }
use { 'phaazon/hop.nvim' }   -- sneak.vim equivalent
use { 'alec-gibson/nvim-tetris', opt = true }
-- use { 'mfussenegger/nvim-dap'} -- debug adapter protocol
use { 'bazelbuild/vim-bazel' , requires = { 'google/vim-maktaba' } }
use 'matbme/JABS.nvim'
-- use {
--   "folke/trouble.nvim",
--   requires = "kyazdani42/nvim-web-devicons",
-- }
use {
  'kdheepak/tabline.nvim',
  config = function()
    require'tabline'.setup {
      -- Defaults configuration options
      enable = true
    }
    vim.cmd[[
      set guioptions-=e " Use showtabline in gui vim
      set sessionoptions+=tabpages,globals " store tabpages and globals in session
    ]]
  end,
  requires = { { 'hoob3rt/lualine.nvim', opt=true }, 'kyazdani42/nvim-web-devicons' }
}
use 'MunifTanjim/nui.nvim' -- to create UIs
use 'hrsh7th/nvim-compe'
use 'vhyrro/neorg'
use 'ray-x/lsp_signature.nvim'
use 'Pocco81/AutoSave.nvim' -- :ASToggle /AsOn / AsOff
-- use 'sindrets/diffview.nvim' -- :DiffviewOpen
-- use 'folke/which-key.nvim' -- :WhichKey

-- use 'vim-airline/vim-airline'
-- use 'vim-airline/vim-airline-themes' -- creates problems if not here

use 'hoob3rt/lualine.nvim'
use 'arkav/lualine-lsp-progress'


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
nnoremap { "<Leader>C", function () require'telescope.builtin'.colorscheme{ enable_preview = true; } end }
nnoremap { "<Leader>f", function () require('telescope').extensions.frecency.frecency({
	query = "toto"
}) end }

nnoremap { "<leader>S",  function() require('spectre').open() end }

-- replace with telescope
-- nnoremap { "<Leader>t", function () vim.cmd("FzfTags") end}
-- nnoremap <Leader>h <Cmd>FzfHistory<CR>
-- nnoremap <Leader>c <Cmd>FzfCommits<CR>
-- nnoremap <Leader>C <Cmd>FzfColors<CR>

local has_whichkey, wk = pcall(require, "which-key")
if has_whichkey then
  wk.setup {
	-- plugins = {
	-- 	marks = true, -- shows a list of your marks on ' and `
	-- 	registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
	-- 	-- the presets plugin, adds help for a bunch of default keybindings in Neovim
	-- 	-- No actual key bindings are created
	-- 	presets = {
	-- 	operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
	-- 	motions = true, -- adds help for motions
	-- 	text_objects = true, -- help for text objects triggered after entering an operator
	-- 	windows = true, -- default bindings on <c-w>
	-- 	nav = true, -- misc bindings to work with windows
	-- 	z = true, -- bindings for folds, spelling and others prefixed with z
	-- 	g = true, -- bindings for prefixed with g
	-- 	},
	-- },
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	-- icons = {
	-- 	breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
	-- 	separator = "➜", -- symbol used between a key and it's label
	-- 	group = "+", -- symbol prepended to a group
	-- },
	-- window = {
	-- 	border = "none", -- none, single, double, shadow
	-- 	position = "bottom", -- bottom, top
	-- 	margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
	-- 	padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
	-- },
	-- layout = {
	-- 	height = { min = 4, max = 25 }, -- min and max height of the columns
	-- 	width = { min = 20, max = 50 }, -- min and max width of the columns
	-- 	spacing = 3, -- spacing between columns
	-- },
	-- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
	-- show_help = true, -- show help message on the command line when the popup is visible
	-- triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specifiy a list manually
	}

end


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
	--     filename = base_directory .. "/data/memes/planets/" .. line,
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

-- review locally github PRs
local has_octo, octo = pcall(require, "octo")
if has_octo then
	octo.setup({
	default_remote = {"upstream", "origin"}; -- order to try remotes
	reaction_viewer_hint_icon = "";         -- marker for user reactions
	user_icon = " ";                        -- user icon
	timeline_marker = "";                   -- timeline marker
	timeline_indent = "2";                   -- timeline indentation
	right_bubble_delimiter = "";            -- Bubble delimiter
	left_bubble_delimiter = "";             -- Bubble delimiter
	github_hostname = "";                    -- GitHub Enterprise host
	snippet_context_lines = 4;               -- number or lines around commented lines
	file_panel = {
		size = 10,                             -- changed files panel rows
		use_icons = true                       -- use web-devicons in file panel
	},
	mappings = {--{{{
		issue = {--{{{
		close_issue = "<space>ic",           -- close issue
		reopen_issue = "<space>io",          -- reopen issue
		list_issues = "<space>il",           -- list open issues on same repo
		reload = "<C-r>",                    -- reload issue
		open_in_browser = "<C-b>",           -- open issue in browser
		copy_url = "<C-y>",                  -- copy url to system clipboard
		add_assignee = "<space>aa",          -- add assignee
		remove_assignee = "<space>ad",       -- remove assignee
		create_label = "<space>lc",          -- create label
		add_label = "<space>la",             -- add label
		remove_label = "<space>ld",          -- remove label
		goto_issue = "<space>gi",            -- navigate to a local repo issue
		add_comment = "<space>ca",           -- add comment
		delete_comment = "<space>cd",        -- delete comment
		next_comment = "]c",                 -- go to next comment
		prev_comment = "[c",                 -- go to previous comment
		react_hooray = "<space>rp",          -- add/remove 🎉 reaction
		react_heart = "<space>rh",           -- add/remove ❤️ reaction
		react_eyes = "<space>re",            -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
		react_rocket = "<space>rr",          -- add/remove 🚀 reaction
		react_laugh = "<space>rl",           -- add/remove 😄 reaction
		react_confused = "<space>rc",        -- add/remove 😕 reaction
		},--}}}
		pull_request = {--{{{
		checkout_pr = "<space>po",           -- checkout PR
		merge_pr = "<space>pm",              -- merge PR
		list_commits = "<space>pc",          -- list PR commits
		list_changed_files = "<space>pf",    -- list PR changed files
		show_pr_diff = "<space>pd",          -- show PR diff
		add_reviewer = "<space>va",          -- add reviewer
		remove_reviewer = "<space>vd",       -- remove reviewer request
		close_issue = "<space>ic",           -- close PR
		reopen_issue = "<space>io",          -- reopen PR
		list_issues = "<space>il",           -- list open issues on same repo
		reload = "<C-r>",                    -- reload PR
		open_in_browser = "<C-b>",           -- open PR in browser
		copy_url = "<C-y>",                  -- copy url to system clipboard
		add_assignee = "<space>aa",          -- add assignee
		remove_assignee = "<space>ad",       -- remove assignee
		create_label = "<space>lc",          -- create label
		add_label = "<space>la",             -- add label
		remove_label = "<space>ld",          -- remove label
		goto_issue = "<space>gi",            -- navigate to a local repo issue
		add_comment = "<space>ca",           -- add comment
		delete_comment = "<space>cd",        -- delete comment
		next_comment = "]c",                 -- go to next comment
		prev_comment = "[c",                 -- go to previous comment
		react_hooray = "<space>rp",          -- add/remove 🎉 reaction
		react_heart = "<space>rh",           -- add/remove ❤️ reaction
		react_eyes = "<space>re",            -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
		react_rocket = "<space>rr",          -- add/remove 🚀 reaction
		react_laugh = "<space>rl",           -- add/remove 😄 reaction
		react_confused = "<space>rc",        -- add/remove 😕 reaction
		},--}}}
		review_thread = {--{{{
		goto_issue = "<space>gi",            -- navigate to a local repo issue
		add_comment = "<space>ca",           -- add comment
		add_suggestion = "<space>sa",        -- add suggestion
		delete_comment = "<space>cd",        -- delete comment
		next_comment = "]c",                 -- go to next comment
		prev_comment = "[c",                 -- go to previous comment
		select_next_entry = "]q",            -- move to previous changed file
		select_prev_entry = "[q",            -- move to next changed file
		close_review_tab = "<C-c>",          -- close review tab
		react_hooray = "<space>rp",          -- add/remove 🎉 reaction
		react_heart = "<space>rh",           -- add/remove ❤️ reaction
		react_eyes = "<space>re",            -- add/remove 👀 reaction
		react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
		react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
		react_rocket = "<space>rr",          -- add/remove 🚀 reaction
		react_laugh = "<space>rl",           -- add/remove 😄 reaction
		react_confused = "<space>rc",        -- add/remove 😕 reaction
		},--}}}
		submit_win = {--{{{
		approve_review = "<C-a>",            -- approve review
		comment_review = "<C-m>",            -- comment review
		request_changes = "<C-r>",           -- request changes review
		close_review_tab = "<C-c>",          -- close review tab
		},--}}}
		review_diff = {--{{{
		add_review_comment = "<space>ca",    -- add a new review comment
		add_review_suggestion = "<space>sa", -- add a new review suggestion
		focus_files = "<leader>e",           -- move focus to changed file panel
		toggle_files = "<leader>b",          -- hide/show changed files panel
		next_thread = "]t",                  -- move to next thread
		prev_thread = "[t",                  -- move to previous thread
		select_next_entry = "]q",            -- move to previous changed file
		select_prev_entry = "[q",            -- move to next changed file
		close_review_tab = "<C-c>",          -- close review tab
		toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
		},--}}}
		file_panel = {--{{{
		next_entry = "j",                    -- move to next changed file
		prev_entry = "k",                    -- move to previous changed file
		select_entry = "<cr>",               -- show selected changed file diffs
		refresh_files = "R",                 -- refresh changed files panel
		focus_files = "<leader>e",           -- move focus to changed file panel
		toggle_files = "<leader>b",          -- hide/show changed files panel
		select_next_entry = "]q",            -- move to previous changed file
		select_prev_entry = "[q",            -- move to next changed file
		close_review_tab = "<C-c>",          -- close review tab
		toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
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

-- local lspfuzzy_available, lspfuzzy = pcall(require, "lspfuzzy")
-- if lspfuzzy_available then
-- 	lspfuzzy.setup {}
-- end

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


local has_neogit, neogit = pcall(require, 'neogit')
if has_neogit then
	neogit.setup {
		disable_signs = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		-- customize displayed signs
		signs = {
			-- { CLOSED, OPENED }
			section = { ">", "v" },
			item = { ">", "v" },
			hunk = { "", "" },
		},
		integrations = {
			-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs you can use `sindrets/diffview.nvim`.
			-- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
			--
			-- Requires you to have `sindrets/diffview.nvim` installed.
			-- use {
			--   'TimUntersberger/neogit',
			--   requires = {
			--     'nvim-lua/plenary.nvim',
			--     'sindrets/diffview.nvim'
			--   }
			-- }
			--
			diffview = false
		},
		-- override/add mappings
		mappings = {
			-- modify status buffer mappings
			status = {
			-- Adds a mapping with "B" as key that does the "BranchPopup" command
			["B"] = "BranchPopup",
			-- Removes the default mapping of "s"
			["s"] = "",
			}
		}

	}
end

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
				fuzzy = true,                    -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true,     -- override the file sorter
				case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
											-- the default case_mode is "smart_case"
			},
			fzy_native = {
				override_generic_sorter = true,
				override_file_sorter = true,
			},
			-- frecency = {
			--       workspaces = {
			-- 		["home"]    = "/home/teto/home",
			-- 		["data"]    = "/home/teto/neovim",
			-- 		["jinko"]   = "/home/teto/jinko",
			-- 		-- ["wiki"]    = "/home/my_username/wiki"
			-- 	},
			-- 	show_scores = true,
			-- 	show_unindexed = true,
			-- 	ignore_patterns = {"*.git/*", "*/tmp/*"},
			-- 	db_safe_mode = false,
			-- 	auto_validate = false
			-- }
		}
	}
	-- This will load fzy_native and have it override the default file sorter
	-- telescope.load_extension('fzf')
	telescope.load_extension('fzy_native')
	-- telescope.load_extension("frecency")

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
local has_gitsigns, gitsigns = pcall(require, "gitsigns")
if has_gitsigns then
 gitsigns.setup {
	-- -- '│' passe mais '▎' non :s
 signs = {
    add          = {hl = 'GitSignsAdd'   , text ='▎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text ='▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  -- signs = {
  --   add          = {hl = 'DiffAdd'   , text = '▎', numhl='GitSignsAddNr'},
  --   change       = {hl = 'DiffChange', text = '▎', numhl='GitSignsChangeNr'},
  --   delete       = {hl = 'DiffDelete', text = '_', numhl='GitSignsDeleteNr'},
  --   topdelete    = {hl = 'DiffDelete', text = '‾', numhl='GitSignsDeleteNr'},
  --   changedelete = {hl = 'DiffChange', text = '▎', numhl='GitSignsChangeNr'},
  -- },
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
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = false,
  current_line_blame_delay = 1000,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = true,
  use_decoration_api = true,
  use_internal_diff = true,  -- If luajit is present
}
end
--}}}
-- vim.fn.stdpath('config')
require 'lsp_init'

-- my treesitter config
require 'myTreesitter'

-- logs are written to /home/teto/.cache/vim-lsp.log
vim.lsp.set_log_level("info")

local has_compe, compe = pcall(require, "compe")
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
	documentation = {
		border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
		winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
		max_width = 120,
		min_width = 60,
		max_height = math.floor(vim.o.lines * 0.3),
		min_height = 1,
	};
	source = {
		path = true;
		buffer = true;
		calc = true;
		nvim_lsp = true;
		nvim_lua = true;
		vsnip = true;
		ultisnips = true;
		luasnip = true;
	};
  };

  local inoremap = k.inoremap
  inoremap { "<C-Space>", function () vim.fn['compe#complete']() end, expr = true }
  -- inoremap { "<CR>", function () vim.cmd('compe#confirm("<CR>")') end, expr=true }
  inoremap { "<C-e>", function () vim.cmd('compe#close("<c-e>")') end , expr=true }
  inoremap { "<C-f>", function () vim.cmd('compe#scroll({ "delta": +4 })') end , expr=true }
  inoremap { "<C-d>", function () vim.cmd('compe#scroll({ "delta": -4 })') end , expr=true }

-- nnoremap { "<Leader>o", function () vim.cmd("FzfFiles") end}
-- inoremap <silent><expr> <C-Space> compe#complete()
-- inoremap <silent><expr> <CR>      compe#confirm('<CR>')
-- inoremap <silent><expr> <C-e>     compe#close('<C-e>')
-- inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
-- inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
end



local has_trouble, trouble = pcall(require, 'trouble')
if false then
	trouble.setup {--{{{
    position = "bottom", -- position of the list can be: bottom, top, left, right}}}
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right{{{
    icons = true, -- use devicons for filenames}}}
    mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
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
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}
end

-- hack
local _, notifs = pcall(require, "notifications")

vim.lsp.notifier = notifs

if vim.notify then
	vim.notify = notifs.notify_external
end

local has_hop, hop = pcall(require, 'hop')
if has_hop then
	hop.setup {}
end

local has_specs, specs = pcall(require, 'specs')
if has_specs then
	specs.setup{
		show_jumps  = true,
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
-- options to pass to goto_next/goto_prev
-- local goto_opts = {
-- 	severity_limit = "Warning"
-- }


local has_lualine, lualine = pcall(require, 'lualine')
if has_lualine then
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename', 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
end



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
-- function lsp_show_all_diagnostics()
-- 	local all_diagnostics = vim.lsp.diagnostic.get_all()
-- 	vim.lsp.util.set_qflist(all_diagnostics)
-- end
vim.opt.background = "dark" -- or "light" for light mode


-- TODO add a command to select a ref (from telescope ?) and call Gitsigns change_base
-- afterwards


local Menu = require("nui.menu")

function create_menu ()

local menu = Menu({
  relative = "cursor",
  border = {
    style = "rounded",
    highlight = "Normal",
    text = {
      top = "[Sample Menu]",
      top_align = "left",
    },
  },
  position = {
    row = 1,
    col = 0,
  },
  highlight = "Normal:Normal",
}, {
  lines = {
    Menu.separator("Group One"),
	-- TODO print status when possible
    Menu.item("Toggle obsession", { func = function() vim.cmd("Obsession") end}),
    Menu.item("Toggle autosave", { func = function() vim.cmd("ASToggle") end}),
    Menu.item("Toggle indentlines", { func = function() vim.cmd('IndentBlanklineToggle!') end}),
    Menu.item("Search and replace", { func = function () require("spectre").open() end}),
    Menu.separator("LSP"),
    Menu.item("Code action", { func = function() vim.lsp.buf.code_action() end}),
    Menu.item("Search references", { func = function() vim.lsp.buf.references() end}),
    Menu.item("Definition", { func = function() vim.lsp.buf.definition() end}),
    Menu.item("Workspace symbols", { func = function() vim.lsp.buf.workspace_symbol() end}),
    Menu.item("Rename", { func = function() vim.lsp.buf.rename() end}),
    Menu.item("Format", { func = function() vim.lsp.buf.formatting_sync(nil, 1000) end}),
            -- \ ["Goto &Definition\t\\cd", 'lua vim.lsp.buf.definition()'],
            -- \ ["Goto &Declaration\t\\cd", 'lua vim.lsp.buf.declaration()'],
            -- \ ["Goto I&mplementation\t\\cd", 'lua vim.lsp.buf.implementation()'],
            -- \ ["Hover\t\\ch", 'lua vim.lsp.buf.references()'],
            -- \ ["Document  &Symbols\t\\cr", 'lua vim.lsp.buf.document_symbol()'],
            -- \ ["&Execute  Command\\ce", 'lua vim.lsp.buf.execute_command()'],
            -- \ ["&Incoming calls\\ci", 'lua vim.lsp.buf.incoming_calls()'],
            -- \ ["&Outgoing calls\\ci", 'lua vim.lsp.buf.outgoing_calls()'],
            -- \ ["&Signature help\\ci", 'lua vim.lsp.buf.signature_help()'],

  },
  max_width = 200,
  max_height = 30,
  separator = {
    char = "-",
    text_align = "right",
  },
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  },
  on_close = function()
    print("CLOSED")
  end,
  on_submit = function(item)
    -- print("SUBMITTED", vim.inspect(item))
	item.func()
  end
})

menu:mount()

menu:map("n", "l", menu.menu_props.on_submit, { noremap = true, nowait = true })

-- menu:on(vim.event.BufLeave, menu.menu_props.on_close, { once = true })

end

vim.cmd([[colorscheme gruvbox]])
