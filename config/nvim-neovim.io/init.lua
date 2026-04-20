-- vim: fdm=marker
require('vim._core.ui2').enable({})

vim.pack.add {
 -- "github.com/rachartier/tiny-cmdline.nvim"
 'https://github.com/rachartier/tiny-cmdline.nvim.git',
 'https://github.com/luukvbaal/statuscol.nvim',
 'https://github.com/mfussenegger/nvim-dap',
 'https://github.com/lewis6991/gitsigns.nvim',
 'https://github.com/neovim/nvim-lspconfig'
}

vim.g.tiny_cmdline = {
    width = {
        value = "80%",  -- "N%" = fraction of editor columns, integer = absolute columns
        min = 40,       -- minimum width in columns
        max = 80,       -- maximum width in columns
    },
    -- Border style for the floating window
    -- nil inherits vim.o.winborder at setup() time, falling back to "rounded"
    -- Set to "none" to disable the border
    border = nil,

    -- Horizontal offset of the completion menu anchor from the window's left inner edge
    -- Used to align blink.cmp / nvim-cmp menus with the cmdline window
    menu_col_offset = 3,

    -- Cmdline types rendered at the bottom of the screen instead of centered
    -- "/" and "?" (search) are kept native by default
    -- native_types = { "/", "?" },
}

vim.o.spelllang = 'en_gb,fr'

-- new option
vim.o.winborder = 'rounded'
vim.opt.guicursor =
    'n-v-c:block-blinkon250-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-blinkon250-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'


vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'manual'
-- vim.lsp.config('*', {


-- dap config
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

require('statuscol').setup({})


-- enable
vim.lsp.enable('clangd')
vim.lsp.enable('emmylua_ls')



-- gitsigns {{{
vim.api.nvim_set_hl(0, 'GitSignsAdd', {
    bg = '#00FF00', -- Green background
})
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', {
    bg = '#00FF00', -- Green background
})


require('gitsigns').setup({
 -- '│' passe mais '▎' non :s
 -- signs = {},
 signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
 signs_staged_enable = false,
 -- it doesn't work properly, sometimes it takes only
 numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
 linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
 word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
 watch_gitdir = {
  follow_files = true,
 },

})
-- }}}
