local menu = require('teto.context_menu')

menu.set_rclick_submenu('MenuSpectre', 'Replace         ', {
    { 'Replace', '<cmd>lua require("spectre").open()<cr>' },
    { 'Replace word', '<cmd>lua require("spectre").open_visual({select_word=true})<cr>' },
    { 'Search file', '<cmd>lua require("spectre").open()<cr>' },
}, function()
    return true
end)
