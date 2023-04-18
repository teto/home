return {
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
          local null =  require('null-ls')
            null.setup({
                sources = {
                    -- needs a luacheck in PATH
                    null.builtins.diagnostics.luacheck,
                    -- null.builtins.diagnostics.hlint,
                    -- require("null-ls").builtins.formatting.stylua,
                    -- require("null-ls").builtins.diagnostics.eslint,
                    -- require("null-ls").builtins.completion.spell,
                },
            })
        end,
    },
    'folke/neodev.nvim',
    -- vim.api.nvim_set_keymap('n', '<f2>',
    -- 	"<cmd>lua require'plenary.reload'.reload_module('rest-nvim.request'); print(require'rest-nvim.request'.ts_get_requests())<cr>"
    -- 	, {})

    -- to cycle between different list/listchars configurations
    'teto/vim-listchars',
  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    -- config = true, -- default settings
    -- you can specify also another config if you want
    config = function() require("gx").setup {
      open_browser_app = "os_specific", -- specify your browser app; default for macos is "open" and for linux "xdg-open"
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        package_json = true, -- open dependencies from package.json
      },
    } end,
  },
    { 'chrisbra/csv.vim' , lazy = true },
    -- provides 'NvimTree'
    { 'kyazdani42/nvim-tree.lua', lazy = true},
    { 'rhysd/committia.vim', lazy = true},
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
    { 'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

    {
        'nvim-lualine/lualine.nvim', -- fork of hoob3rt/lualine
        -- dependencies = { 'arkav/lualine-lsp-progress' },
        config = function()
            require('teto.lualine')
        end,
    },
    { -- display function signature in insert mode
     'ray-x/lsp_signature.nvim'
    , config = function ()
      -- local has_signature, signature = pcall(require, 'lsp_signature')
         vim.api.nvim_create_autocmd("LspAttach", {
          desc = "Attach lsp_signature on new client",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end
           local client = vim.lsp.get_client_by_id(args.data.client_id)
           local bufnr = args.buf
           require'lsp_signature'.on_attach(client, bufnr)
        end
       })

      end
    },

    {
        'Pocco81/AutoSave.nvim', -- :ASToggle /AsOn / AsOff
        config = function()
            local autosave = require('auto-save')
            autosave.setup({
                enabled = true,
                -- execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
                events = { 'FocusLost' }, -- "InsertLeave"
                -- conditions = {
                -- 	exists = true,
                -- 	filetype_is_not = {},
                -- 	modifiable = true
                -- },
                write_all_buffers = false,
                -- on_off_commands = true,
                -- clean_command_line_interval = 2500
            })
        end,
    },
    'tpope/vim-rhubarb',
    -- competition to potamides/pantran.nvim which uses just AI backends it seems
    {
        'uga-rosa/translate.nvim',
        lazy = true,
        config = function()
            require('translate').setup({
                default = {
                    command = 'translate-shell',
                },
                preset = {
                    output = {
                        split = {
                            append = true,
                        },
                    },
                },
            })
        end,
    },
}
