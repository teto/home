require('grug-far').setup({
    -- ... options, see Configuration section below ...
    -- ... there are no required options atm...
})


local menu = require('teto.context_menu')

-- lua require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } })
menu.set_rclick_submenu('MenuGrugFar', 'Replace         ', {
        { 'Replace', '<cmd>GrugFar<cr>' },
        { 'Replace word', '<cmd>lua require("grug-far").open_visual({select_word=true})<cr>' },
        { 'Search file', '<cmd>lua require("grug-far").open()<cr>' },
    }, function()
        return true
end)

