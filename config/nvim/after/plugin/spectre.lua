
local menu = require'teto.context_menu'

local set_spectre_rclick_menu = function()
    -- nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
    -- vnoremap <leader>s <cmd>lua require('spectre').open_visual()<CR>
    -- "  search in current file
    -- nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>

    M.set_rclick_submenu('MenuSpectre', 'Replace         ', {
        {'Replace',  '<cmd>lua require("spectre").open()<cr>'},
        {'Replace word',  '<cmd>lua require("spectre").open_visual({select_word=true})<cr>'},
        {'Search file',  '<cmd>lua require("spectre").open()<cr>'},
    }, function () return true end)
end

menu.set_spectre_rclick_menu()
