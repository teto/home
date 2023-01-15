return {
 {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        require('null-ls').setup({
            sources = {
                -- needs a luacheck in PATH
                require('null-ls').builtins.diagnostics.luacheck,
                -- require("null-ls").builtins.formatting.stylua,
                -- require("null-ls").builtins.diagnostics.eslint,
                -- require("null-ls").builtins.completion.spell,
            },
        })
    end,
},
"folke/neodev.nvim",

-- to cycle between different list/listchars configurations
'teto/vim-listchars',
'chrisbra/csv.vim',
-- provides 'NvimTree'
'kyazdani42/nvim-tree.lua',
 'rhysd/committia.vim',
-- <leader>ml to setup buffer modeline
-- 'teto/Modeliner', -- not needed with editorconfig ?
{
    'rcarriga/nvim-notify',
    config = function()
        require('notify').setup({
            -- Animation style (see below for details)
            stages = 'fade_in_slide_out',

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
            background_colour = 'Normal',

            -- Minimum width for notification windows
            minimum_width = 50,
        })

        vim.notify = require('notify')
    end,
},
{
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require('indent_blankline').setup({
            char = '│',
            buftype_exclude = { 'terminal' },
            filetype_exclude = { 'help' },
            space_char_blankline = ' ',
            show_end_of_line = true,
            char_highlight_list = {
                'IndentBlanklineIndent1',
                'IndentBlanklineIndent2',
                'IndentBlanklineIndent3',
                'IndentBlanklineIndent4',
                'IndentBlanklineIndent5',
                'IndentBlanklineIndent6',
            },
            max_indent_increase = 1,
            indent_level = 2,
            show_first_indent_level = false,
            -- blankline_use_treesitter,
            char_list = { '.', '|', '-' },
            show_trailing_blankline_indent = false,
            show_current_context = false,
            show_current_context_start = true,
            enabled = false,
        })
    end,
},
{'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'},

{
    'nvim-lualine/lualine.nvim', -- fork of hoob3rt/lualine
    requires = { 'arkav/lualine-lsp-progress' },
    config = function()
		require 'teto.lualine'
    end,
},
'ray-x/lsp_signature.nvim', -- display function signature in insert mode
{
    'Pocco81/AutoSave.nvim' -- :ASToggle /AsOn / AsOff
	, config = function ()
		local autosave = require("auto-save")
		autosave.setup({
			enabled = true,
			-- execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
			events = { "FocusLost"}, -- "InsertLeave"
			-- conditions = {
			-- 	exists = true,
			-- 	filetype_is_not = {},
			-- 	modifiable = true
			-- },
			write_all_buffers = false,
			-- on_off_commands = true,
			-- clean_command_line_interval = 2500
		}
		)
    end
},
'tpope/vim-rhubarb',
-- competition to potamides/pantran.nvim which uses just AI backends it seems
{'uga-rosa/translate.nvim',
	config = function ()

	require("translate").setup({
		default = {
			command = "translate-shell",
		},
		preset = {
			output = {
				split = {
					append = true,
				},
			},
		},
	})
end}
}
