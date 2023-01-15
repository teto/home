return {
-- telescope extension to search hackage require('telescope').load_extension('scout')
{ 'aloussase/scout', rtp = 'vim' },
{
    dir = '~/telescope.nvim',
    dependencies = {
        'nvim-telescope/telescope-github.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-media-files.nvim',
        'nvim-telescope/telescope-packer.nvim', -- :Telescope pack,e
        'MrcJkb/telescope-manix',   -- :Telescope manix
		'luc-tielen/telescope_hoogle'
		-- psiska/telescope-hoogle.nvim looks less advanced
    },
},
--}
{ 'alec-gibson/nvim-tetris', opt = true }

}
