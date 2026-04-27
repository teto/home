-- vim: fdm=marker
require('vim._core.ui2').enable({})

vim.pack.add({
    -- "github.com/rachartier/tiny-cmdline.nvim"
    'https://github.com/rachartier/tiny-cmdline.nvim.git',
    'https://github.com/luukvbaal/statuscol.nvim',
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/ibhagwan/fzf-lua',
})

vim.g.tiny_cmdline = {
    width = {
        value = '80%', -- "N%" = fraction of editor columns, integer = absolute columns
        min = 40, -- minimum width in columns
        max = 80, -- maximum width in columns
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

-- makes more readable screenshots
vim.opt.background = 'light'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldlevel = 99
vim.opt.foldcolumn = 'auto'
vim.opt.foldmethod = 'manual'

-- dap config
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

local builtin = require('statuscol.builtin')
require('statuscol').setup({
    setopt = true,
    thousands = false, -- or line number thousands separator string ("." / ",")
    relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
    -- Builtin 'statuscolumn' options
    ft_ignore = nil, -- Lua table with 'filetype' values for which 'statuscolumn' will be unset
    bt_ignore = nil, -- Lua table with 'buftype' values for which 'statuscolumn' will be unset

    segments = {
        {
            sign = {
                name = { '.*' },
                text = { '.*' },
            },
            click = 'v:lua.ScSa',
        },
        {
            text = { builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            -- lnum_click
            -- line action
            click = 'v:lua.ScLa',
        },
        {
            sign = { namespace = { 'gitsigns' }, colwidth = 1, wrap = true },
            -- Sign action
            click = 'v:lua.ScSa',
        },
        {
            text = {
                function(args)
                    args.fold.close = ''
                    args.fold.open = ''
                    args.fold.sep = '▕'
                    return builtin.foldfunc(args)
                end,
            },
            -- Fa => Fold action
            click = 'v:lua.ScFa',
        },
    },
})

vim.diagnostic.config({
    signs = {
        severity = { min = vim.diagnostic.severity.WARN },
        text = {
            -- ⚡
            [vim.diagnostic.severity.ERROR] = '⛔',
            [vim.diagnostic.severity.WARN] = '⚠',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
    severity_sort = true,

    float = {
        source = true,
        severity_sort = true,
        border = 'rounded',
    },
})

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
})
-- }}}

vim.go.showtabline = 2
require('tabline')
vim.cmd('tabnew')

vim.api.nvim_set_hl(0, 'TablineMore', { bg = '#00FF00' })
vim.api.nvim_set_hl(0, 'TablineSel', { link = 'Statusline' })
vim.api.nvim_set_hl(0, 'TablineModeInsert', { bg = 'red' })
vim.api.nvim_set_hl(0, 'TablineModeNormal', { bg = 'blue' })
vim.api.nvim_set_hl(0, 'TablineModeReplace', { bg = 'green' })
vim.api.nvim_set_hl(0, 'TablineModeVisual', { bg = 'yellow' })


vim.cmd [[
amenu PopUp.Custom\ Entry :echo 'hello world'
]]

-- to showcase customized cases
-- checkhealth | 
vim.cmd([[
e src/nvim/fold.c | tabn | help 'tabline' | tabn | tabn | term
]])
