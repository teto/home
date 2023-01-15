return {
'rhysd/vim-gfm-syntax' -- markdown syntax compatible with Github's
, { 'eandrju/cellular-automaton.nvim', lazy = true } -- :CellularAutomaton make_it_rain
, {'bogado/file-line', branch="main"} -- to open a file at a specific line
, 'norcalli/nvim-terminal.lua' -- to display ANSI colors
-- , '~/neovim/nvim-terminal.lua' -- to display ANSI colors
, 'chrisbra/vim-diff-enhanced',
'linty-org/readline.nvim',
{'rareitems/anki.nvim', lazy = true }, -- to create anki cards
'nvim-zh/colorful-winsep.nvim' ,
-- :Nvimesweeper / :h nvimesweeper
{ 'seandewar/nvimesweeper', lazy = true },
{ 'voldikss/vim-translator', lazy = true },
-- load 'after/colors'
'calvinchengx/vim-aftercolors',
-- Vim-cool disables search highlighting when you are done searching and re-enables it when you search again.
-- use('romainl/vim-cool')
-- 'lrangell/theme-cycler.nvim'
-- lua repl :Luadev
'bfredl/nvim-luadev',
{
    'AckslD/nvim-FeMaco.lua',
    config = 'require("femaco").setup()',
},
-- for quickreading: use :FSToggle to Toggle flow state
{'nullchilly/fsread.nvim', config = function ()

	-- vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
	-- vim.g.skip_flow_default_hl = true -- If you want to override default highlights
	-- vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
	-- vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
end},
{'tweekmonster/startuptime.vim', opt = true }, -- {'on': 'StartupTime'} " see startup time per script
'MunifTanjim/nui.nvim', -- to create UIs
'honza/vim-snippets',
{ 'ethanholz/nvim-lastplace',
    config = function()
        require('nvim-lastplace').setup({
            lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
            lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
            lastplace_open_folds = true,
        })
    end,
}

}
