require('vim._core.ui2').enable({})

vim.pack.add {
 "github.com/rachartier/tiny-cmdline.nvim"

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

vim.opt.foldlevel = 99
vim.lsp.config('*', {


-- dap config
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

require('statuscol').setup({})
