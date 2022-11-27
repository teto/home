-- inspired by https://gitlab.com/gabmus/nvpunk/-/blob/master/lua/nvpunk/util/context_menu.lua
local M = {}

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function()
    return not vim.tbl_isempty(
        vim.lsp.buf_get_clients(vim.api.nvim_get_current_buf())
    )
end

-- local nonfile_bufs = require'nvpunk.util.nonfile_buffers'

--- Checks if current buf is a file
---@return boolean
M.buf_is_file = function()
  return true
    -- return not vim.tbl_contains(
    --     nonfile_bufs,
    --     vim.bo.filetype
    -- )
end

--- Checks if current buf has DAP support
---@return boolean
M.buf_has_dap = function()
    return M.buf_is_file()
end

--- Create a context menu
---@param prompt string
---@param strings table[string]
---@param funcs table[function]
M.uiselect_context_menu = function(prompt, strings, funcs)
    vim.ui.select(
        strings,
        { prompt = prompt },
        function(_, idx) vim.schedule(funcs[idx]) end
    )
end

local MODES = {'i', 'n'}

--- Clear all entries from the given menu
---@param menu string
M.clear_menu = function(menu)
    pcall(function()
        vim.cmd('aunmenu ' .. menu)
    end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
M.format_menu_label = function(label)
    local res = string.gsub(
        label, ' ', [[\ ]]
    )
    res = string.gsub(
        res, '<', [[\<]]
    )
    res = string.gsub(
        res, '>', [[\>]]
    )
    return res
end

--- Create an entry for the right click menu
---@param menu string
---@param label string
---@param action string
M.rclick_context_menu = function(menu, label, action)
    for _, m in ipairs(MODES) do
        vim.cmd(
            m .. 'menu ' .. menu .. '.' ..
            M.format_menu_label(label) .. ' ' ..
            action
        )
    end
end

--- Set up a right click submenu
---@param menu_name string
---@param submenu_label string
---@param items table[{string, string}]
---@param bindif function?
M.set_rclick_submenu = function(menu_name, submenu_label, items, bindif)
    M.clear_menu(menu_name)
    M.clear_menu('PopUp.' .. M.format_menu_label(submenu_label))
    if bindif ~= nil then
        if not bindif() then return end
    end
    for _, i in ipairs(items) do
        M.rclick_context_menu(menu_name, i[1], i[2])
    end
    M.rclick_context_menu(
        'PopUp', submenu_label, '<cmd>popup ' .. menu_name .. '<cr>'
    )
end

M.set_lsp_rclick_menu = function()
    M.set_rclick_submenu('TetoMenuLsp', 'LSP         ', {
        {'Code Actions           <space>ca', '<space>ca'},
        {'Go to Declaration             gD',        'gD'},
        {'Go to Definition              gd',        'gd'},
        {'Go to Implementation          gI',        'gI'},
        {'Signature Help             <C-k>',     '<C-k>'},
        {'Rename                 <space>rn', '<space>rn'},
        {'References                    gr',        'gr'},
        {'Expand Diagnostics      <space>e',  '<space>e'},
        {'Auto Format             <space>f',  '<space>f'},
    }, M.buf_has_lsp)
end

M.set_dap_rclick_menu = function()
    M.set_rclick_submenu('TetoMenuDap', 'Debug       ', {
        {'Show DAP UI           <space>bu',   '<space>bu'},
        {'Toggle Breakpoint     <space>bb',   '<space>bb'},
        {'Continue              <space>bc',   '<space>bc'},
        {'Terminate             <space>bk',   '<space>bk'},
    }, M.buf_has_dap)
end

-- M.set_nvimtree_rclick_menu = function()
--     M.set_rclick_submenu('NvpunkFileTreeMenu', 'File        ', {
--         {'New File              <space>fn',   '<space>fn'},
--         {'Rename                     <F2>',   '<F2>'},
--     }, function() return vim.bo.filetype == 'NvimTree' end)
-- end

-- M.set_neotree_rclick_menu = function()
--     M.set_rclick_submenu('NeoTreeMenu', 'File        ', {
--         {'New File              <space>fn',   '<space>fn'},
--         {'New Folder            <space>dn',   '<space>dn'},
--         {'Rename                     <F2>',   '<F2>'},
--         {'Toggle Hidden             <C-h>',   '<C-h>'},
--         {'Split Horizontally            i',   'i'},
--         {'Split Vertically              s',   's'},
--         {'Open in New Tab               t',   't'},
--         {'Git Add               <space>ga',   '<space>ga'},
--         {'Git Unstage           <space>gu',   '<space>gu'},
--     }, function() return vim.bo.filetype == 'neo-tree' end)
-- end

M.set_telescope_rclick_menu = function()
    M.set_rclick_submenu('TetoTelescopeMenu', 'Telescope   ', {
        {'Find File             <space>tf',   '<space>tf'},
        {'Live Grep             <space>tg',   '<space>tg'},
        {'Recent Files          <space>th',   '<space>th'},
    })
end

M.set_git_rclick_menu = function()
    M.set_rclick_submenu('TetoGitMenu', 'Git         ', {
        {'Preview Changes       <space>g?',   '<space>g?'},
        {'Prev Hunk             <space>g[',   '<space>g['},
        {'Next Hunk             <space>g]',   '<space>g]'},
        {'Blame Line            <space>gb',   '<space>gb'},
    }, M.buf_is_file)
end

M.setup_rclick_menu_autocommands = function()
    vim.api.nvim_create_autocmd(
        {'BufEnter', 'LspAttach'}, {
        callback = function()
            M.set_lsp_rclick_menu()
            -- M.set_dap_rclick_menu()
            -- M.set_java_rclick_menu()
            -- M.set_nvimtree_rclick_menu()
            -- M.set_neotree_rclick_menu()
            M.set_telescope_rclick_menu()
            M.set_git_rclick_menu()
        end
    })
end

M.clear_menu'PopUp'

return M
