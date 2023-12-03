return {
    -- telescope extension to search hackage require('telescope').load_extension('scout')

    -- telescope extension to search hackage require('telescope').load_extension('scout')
    'mrcjkb/scout-fork', -- fork of 'aloussase/scout'  that disappeared
    -- {

    --   'prochri/telescope-all-recent.nvim'
    --   , config = function()
    --     require'telescope-all-recent'.setup{
    --       -- your config goes here
    --     }
    --   end
    -- },
    {
        dir = '~/telescope.nvim',
        dependencies = {
            'nvim-telescope/telescope-github.nvim',
            'nvim-telescope/telescope-symbols.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
            'nvim-telescope/telescope-media-files.nvim',
            -- 'MrcJkb/telescope-manix', -- :Telescope manix
            -- need a hoogle that supports --json and run 'hoogle generate'
            'luc-tielen/telescope_hoogle',
            -- psiska/telescope-hoogle.nvim looks less advanced
        },
        config = function()
            -- TODO check for telescope github extension too
            -- telescope.load_extension('ghcli')
            local actions = require('telescope.actions')
            local trouble = require('trouble')
            -- telescope.setup{}
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                 preview = false;
                 layout_strategy = "vertical",
                 sorting_strategy = "ascending",  -- display results top->bottom
                 layout_config = {
                   prompt_position = "top",

                   -- mirror = true,
                     vertical = { width = 0.7 },
                     -- other layout configuration here
                 },
                    mappings = {
                     -- see :h telescope.defaults.history
                        i = {
                            ['<c-t>'] = trouble.open_with_trouble,
                            ["<C-n>"] = require('telescope.actions').cycle_history_next,
                            ["<C-p>"] = require('telescope.actions').cycle_history_prev,

                            -- 				-- -- To disable a keymap, put [map] = false
                            -- 				-- -- So, to not map "<C-n>", just put
                            -- 				-- ["<c-x>"] = false,
                            -- 				-- -- Otherwise, just set the mapping to the function that you want it to be.
                            -- 				-- ["<C-i>"] = actions.goto_file_selection_split,
                            -- 				-- -- Add up multiple actions
                            -- 				-- ["<CR>"] = actions.goto_file_selection_edit + actions.center,
                            -- 				-- -- You can perform as many actions in a row as you like
                            -- 				-- ["<CR>"] = actions.goto_file_selection_edit + actions.center + my_cool_custom_action,
                            ['<esc>'] = actions.close,
                        },
                        n = {
                            ['<C-t>'] = function(prompt_bufnr, mode)
                                require('trouble.providers.telescope').open_with_trouble(prompt_bufnr, mode)
                            end,
                            -- ["<c-t>"] = trouble.open_with_trouble,
                            ['<esc>'] = actions.close,
                        },
                    },
                    -- 		vimgrep_arguments = {
                    -- 		'rg',
                    -- 		'--color=never',
                    -- 		'--no-heading',
                    -- 		'--with-filename',
                    -- 		'--line-number',
                    -- 		'--column',
                    -- 		'--smart-case'
                    -- 		},
                    -- 		prompt_prefix = ">",
                    -- 		scroll_strategy = "limit", -- or cycle
                    -- 		selection_strategy = "reset",
                    -- 		sorting_strategy = "descending",
                    -- 		-- horizontal, vertical, center, flex
                    -- 		layout_strategy = "horizontal",
                    -- 		layout = {
                    -- 			width = 0.75,
                    -- 			prompt_position = "bottom",
                    -- 		},

                    -- 		file_ignore_patterns = {},
                    -- 		-- get_generic_fuzzy_sorter not very good, doesn't select an exact match
                    -- 		-- get_fzy_sorter
                    -- 		-- https://github.com/nvim-telescope/telescope.nvim#sorters
                    -- 		-- generic_sorter =  require'telescope.sorters'.get_levenshtein_sorter,
                    -- 		generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
                    -- 		file_sorter =  require'telescope.sorters'.get_fuzzy_file,
                    -- 		shorten_path = false,
                    -- 		path_display='smart',
                    -- 		winblend = 0,
                    -- 		-- preview_cutoff = 120,
                    -- 		border = true,
                    -- 		-- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
                    -- 		color_devicons = true,
                    -- 		-- use_less = true,
                    -- 		-- file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
                    -- 		-- grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
                    -- 		-- qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

                    -- 		-- Developer configurations: Not meant for general override
                    -- 		-- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
                },
                extensions = {
                    -- 		fzf = {
                    -- 			fuzzy = true,					 -- false will only do exact matching
                    -- 			override_generic_sorter = true, -- override the generic sorter
                    -- 			override_file_sorter = true,	 -- override the file sorter
                    -- 			case_mode = "smart_case",		 -- or "ignore_case" or "respect_case"
                    -- 										-- the default case_mode is "smart_case"
                    -- 		},
                    -- 		fzy_native = {
                    -- 			override_generic_sorter = false,
                    -- 			override_file_sorter = false,
                    -- 		},
                    frecency = {
                        -- 			-- workspaces = {
                        -- 				-- ["home"]	= "/home/teto/home",
                        -- 				-- ["data"]	= "/home/teto/neovim",
                        -- 				-- ["jinko"]	= "/home/teto/jinko",
                        -- 				-- -- ["wiki"]    = "/home/my_username/wiki"
                        -- },
                        -- show_scores = true,
                        -- show_unindexed = true,
                        -- ignore_patterns = {"*.git/*", "*/tmp/*"},
                        db_safe_mode = true,
                        auto_validate = false,
                        -- devicons_disabled = true
                    },
                },
            })
            -- This will load fzy_native and have it override the default file sorter
            -- telescope.load_extension('fzf')
            --jghauser/papis.nvim telescope.load_extension('fzy_native')
            -- telescope.load_extension("notify")
            telescope.load_extension('hoogle')
            -- telescope.load_extension('frecency')
            -- telescope.load_extension('manix')
            -- telescope.load_extension('scout')

            -- TODO add autocmd
            -- User TelescopePreviewerLoaded
        end,
        --}}}
    },
    --}
    -- defaults
    -- use {
    -- 	"~/telescope-frecency.nvim",
    -- 	config = function ()
    -- 		nnoremap ( "n", "<Leader>f", function () require('telescope').extensions.frecency.frecency({
    -- 			query = "toto"
    -- 		}) end )
    -- 	end
    -- 	}
}
