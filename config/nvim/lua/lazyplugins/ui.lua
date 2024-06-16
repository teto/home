return {
    -- {
    --  "kndndrj/nvim-dbee",
    -- dependencies = {
    --   "MunifTanjim/nui.nvim",
    -- },
    --[[ Reference
-- Open/close/toggle the UI.
require("dbee").open()
require("dbee").close()
require("dbee").toggle()
-- Run a query on the currently active connection.
require("dbee").execute(query)
-- Store the current result to file/buffer/yank-register (see "Getting Started").
require("dbee").store(format, output, opts)
]]
    --
    -- build = function()
    --   -- Install tries to automatically detect the install method.
    --   -- if it fails, try calling it with one of these parameters:
    --   --    "curl", "wget", "bitsadmin", "go"
    --   require("dbee").install()
    -- end,
    -- config = function()
    --   require("dbee").setup(--[[optional config]])
    -- end,
    -- },

    -- {
    --   'mawkler/modicator.nvim',
    --   config = function()
    --     require('modicator').setup({
    --       -- Show warning if any required option is missing
    --       show_warnings = false,
    --      })
    --   end,
    --  },

    -- {
    --  -- dim inactive windows
    --  'levouh/tint.nvim',
    -- config = function ()
    --     -- Default configuration
    --     -- available in nixpkgs tint-nvim
    --     require("tint").setup({})
    --  end
    -- },
    --  {
    --     'tzachar/highlight-undo.nvim',
    --     config = function()
    --       require('highlight-undo').setup({
    --         hlgroup = 'HighlightUndo',
    --         duration = 300,
    --         keymaps = {
    --           {'n', 'u', 'undo', {}},
    --           {'n', '<C-r>', 'redo', {}},
    --         }
    --         })
    --     end
    -- },
    -- { 'romgrk/kirby.nvim',
    -- dependencies = {
    -- --     -- { 'romgrk/fzy-lua-native', build = 'make install' },
    --     -- { 'romgrk/kui.nvim' },
    --   },
    -- },

    -- {
    --        'rcarriga/nvim-notify',
    --        config = function()
    --            require('notify').setup({
    --                -- Animation style (see below for details)
    --                stages = 'fade_in_slide_out',

    --                -- Function called when a new window is opened, use for changing win settings/config
    --                -- on_open = nil,
    --                -- Function called when a window is closed
    --                -- on_close = nil,
    --                -- Render function for notifications. See notify-render()
    --                -- render = "default",
    --                -- Default timeout for notifications
    --                timeout = 5000,
    --                -- Max number of columns for messages
    --                max_width = 100,
    --                -- Max number of lines for a message
    --                -- max_height = 50,

    --                -- For stages that change opacity this is treated as the highlight behind the window
    --                -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
    --                background_colour = 'Normal',

    --                -- Minimum width for notification windows
    --                minimum_width = 50,
    --            })

    --            vim.notify = require('notify')
    --        end,
    --    },

    -- colorschemes
    -- 'uga-rosa/ccc.nvim', -- color picker
    -- {
    --   'NvChad/nvim-colorizer.lua',
    --     config = function ()
    --         require('colorizer').setup()
    --     end
    -- },
    -- use 'npxbr/gruvbox.nvim' " requires lus
    -- {'kevinhwang91/nvim-ufo', dependencies = {'kevinhwang91/promise-async'}},
    -- load 'after/colors'
    -- 'calvinchengx/vim-aftercolors',
}
