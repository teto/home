return {
 {
  "kndndrj/nvim-dbee",
  -- dependencies = {
  --   "MunifTanjim/nui.nvim",
  -- },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup(--[[optional config]])
  end,
},
 {
  -- 
  'stevearc/oil.nvim'
  , config = function ()
      require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you still want to use netrw.
        default_file_explorer = true,
     })
   end
 },
{
  'mawkler/modicator.nvim',
  config = function()
    require('modicator').setup({
      -- Show warning if any required option is missing
      show_warnings = false,
     })
  end,
 },
   {
    -- dim inactive windows
    'levouh/tint.nvim',
   config = function ()
       -- Default configuration
       -- available in nixpkgs tint-nvim
       require("tint").setup({})
    end
   },
   {
      'tzachar/highlight-undo.nvim',
      config = function()
        require('highlight-undo').setup({
          hlgroup = 'HighlightUndo',
          duration = 300,
          keymaps = {
            {'n', 'u', 'undo', {}},
            {'n', '<C-r>', 'redo', {}},
          }
          })
      end
  },
  -- { 'romgrk/kirby.nvim',
  -- dependencies = {
  -- --     -- { 'romgrk/fzy-lua-native', build = 'make install' },
  --     -- { 'romgrk/kui.nvim' },
  --   },
  -- },
    -- provides 'NvimTree'
    { 'kyazdani42/nvim-tree.lua', lazy = true},

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

 -- I use my own
   -- { 'simrat39/desktop-notify.nvim',
   -- config = function ()
   --   require("desktop-notify").override_vim_notify()
   --  end
   --  -- dependencies = { 'nvim-lua/plenary.nvim'}
   -- },
    { 'protex/better-digraphs.nvim', lazy=true },

    -- colorschemes
    'craftzdog/solarized-osaka.nvim',
    'Matsuuu/pinkmare',
    'flrnd/candid.vim',
    'uga-rosa/ccc.nvim',
    -- {
    --   'NvChad/nvim-colorizer.lua',
    --     config = function ()
    --         require('colorizer').setup()
    --     end
    -- },
    -- 'whatyouhide/vim-gotham'
    'adlawson/vim-sorcerer',
    -- use 'npxbr/gruvbox.nvim' " requires lus
    'vim-scripts/Solarized',
    -- {'kevinhwang91/nvim-ufo', dependencies = {'kevinhwang91/promise-async'}},
    'romainl/flattened',
    'NLKNguyen/papercolor-theme',
    'marko-cerovac/material.nvim',
    'shaunsingh/oxocarbon.nvim',
    { "catppuccin/nvim", name = "catppuccin" },
 -- load 'after/colors'
 -- 'calvinchengx/vim-aftercolors',

    {
        'rose-pine/neovim',
        name = 'rose-pine',
        -- tag = 'v1.*',
        -- config = function()
        -- end
    },
    'raddari/last-color.nvim',

-- shade currently broken
--	''
--	shade.setup({
--		overlay_opacity = 70,
--		opacity_step = 1,
--		-- keys = {
--		--	 brightness_up	  = '<C-Up>',
--		--	 brightness_down  = '<C-Down>',
--		--	 toggle			  = '<Leader>s',
--		-- }
--	})
--end


    -- {
    --   'bufferline-nvim',
    --   config = function ()
    -- 	require'bufferline'.setup {
    -- 		options = {
    -- 			view = "default",
    -- 			numbers = "buffer_id",
    -- 			-- number_style = "superscript" | "",
    -- 			-- mappings = true,
    -- 			modified_icon = '●',
    -- 			close_icon = '',
    -- 			left_trunc_marker = '',
    -- 			right_trunc_marker = '',
    -- 			-- max_name_length = 18,
    -- 			-- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    -- 			-- tab_size = 18,
    -- 			show_buffer_close_icons = false,
    -- 			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- 			-- -- can also be a table containing 2 custom separators
    -- 			-- -- [focused and unfocused]. eg: { '|', '|' }
    -- 			-- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
    -- 			separator_style = "slant",
    -- 			-- enforce_regular_tabs = false | true,
    -- 			always_show_bufferline = false,
    -- 			-- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
    -- 			-- -- add custom logic
    -- 			-- return buffer_a.modified > buffer_b.modified
    -- 			-- end
    -- 			hover = {
    -- 				enabled = true,
    -- 				delay = 200,
    -- 				reveal = { 'close' }
    -- 			},
    -- 		}
    -- 	}
    --    end
    --  },
    -- overrides vim.ui / vim.select with the backend of my choice
    -- use({
    --     'stevearc/dressing.nvim',
    --     config = function()
    --         require('dressing').setup({
    --             input = {
    --                 -- Default prompt string
    --                 default_prompt = '➤ ',
    --                 -- When true, <Esc> will close the modal
    --                 insert_only = true,
    --                 -- These are passed to nvim_open_win
    --                 anchor = 'SW',
    --                 relative = 'cursor',
    --                 border = 'rounded',
    --                 -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    --                 prefer_width = 40,
    --                 width = nil,
    --                 -- min_width and max_width can be a list of mixed types.
    --                 -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    --                 max_width = { 140, 0.9 },
    --                 min_width = { 20, 0.2 },

    --                 -- see :help dressing_get_config
    --                 get_config = nil,
    --             },
    --             mappings = {
    --                 ['<C-c>'] = 'Close',
    --             },
    --             select = {
    --                 -- Priority list of preferred vim.select implementations
    --                 backend = { 'fzf_lua', 'telescope', 'builtin', 'nui' },

    --                 -- Options for fzf selector
    --                 fzf = {
    --                     window = {
    --                         width = 0.5,
    --                         height = 0.4,
    --                     },
    --                 },
    --                 telescope = {
    --                     window = {
    --                         width = 0.5,
    --                         height = 0.4,
    --                     },
    --                 },

    --                 -- Options for nui Menu
    --                 -- nui = {
    --                 -- position = "50%",
    --                 -- size = nil,
    --                 -- relative = "editor",
    --                 -- border = {
    --                 -- style = "rounded",
    --                 -- },
    --                 -- max_width = 80,
    --                 -- max_height = 40,
    --                 -- },
    -- -- dressing.select.builtin.win_options.winblend
    --                 -- Options for built-in selector
    --                 builtin = {
    --                     -- These are passed to nvim_open_win
    --                     anchor = 'NW',
    --                     relative = 'cursor',
    --                     border = 'rounded',

    --                     -- Window options
    -- 					win_options = {
    -- 						winblend = 10,
    -- 					},

    --                     -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    --                     -- the min_ and max_ options can be a list of mixed types.
    --                     -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
    --                     width = nil,
    --                     max_width = { 140, 0.8 },
    --                     min_width = { 40, 0.2 },
    --                     height = nil,
    --                     max_height = 0.9,
    --                     min_height = { 10, 0.2 },
    --                 },

    --                 -- see :help dressing_get_config
    --                 get_config = nil,
    --             },
    --         })
    --     end,
    -- })

}
