return {

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
    {'kevinhwang91/nvim-ufo', dependencies = {'kevinhwang91/promise-async'}},
    'romainl/flattened',
    { 'protex/better-digraphs.nvim', lazy=true },
    'NLKNguyen/papercolor-theme',
    'marko-cerovac/material.nvim',
    'shaunsingh/oxocarbon.nvim',
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        -- tag = 'v1.*',
        -- config = function()
        -- end
    },
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
