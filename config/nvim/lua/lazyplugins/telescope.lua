return {
    -- telescope extension to search hackage require('telescope').load_extension('scout')

    -- telescope extension to search hackage require('telescope').load_extension('scout')
    -- 'mrcjkb/scout-fork', -- fork of 'aloussase/scout'  that disappeared
    -- {

    --   'prochri/telescope-all-recent.nvim'
    --   , config = function()
    --     require'telescope-all-recent'.setup{
    --       -- your config goes here
    --     }
    --   end
    -- },
     -- { dir = '/home/teto/neovim/nvim-telescope-zeal-cli' },

    {
        -- dir = '~/telescope.nvim',
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-telescope/telescope-github.nvim',
            'nvim-telescope/telescope-symbols.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
            'nvim-telescope/telescope-media-files.nvim',
            'MrcJkb/telescope-manix', -- :Telescope manix
            -- need a hoogle that supports --json and run 'hoogle generate'
            -- 'luc-tielen/telescope_hoogle', --  broken
            -- psiska/telescope-hoogle.nvim looks less advanced
        },
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
