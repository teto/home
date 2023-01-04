-- inspired by https://gitlab.com/gabmus/nvpunk/-/blob/master/lua/nvpunk/util/context_menu.lua
-- one can run 'popup <name>' to go straight to the correct menu
local M = {
 active_menus = {}

}

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function()
    return not vim.tbl_isempty(
        vim.lsp.buf_get_clients(vim.api.nvim_get_current_buf())
    )
end

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_sniprun = function()
    -- return not vim.tbl_isempty(
    --     vim.lsp.buf_get_clients(vim.api.nvim_get_current_buf())
    -- )
	return true
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

M.buf_is_rest = function()
  return vim.bo.filetype == "http"
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
        {'Rename',  '<cmd>lua vim.lsp.buf.rename()<cr>'},
        {'References                    gr',        'gr'},
        {'Expand Diagnostics      <space>e',  '<space>e'},
        {'Auto Format', '<cmd>lua vim.lsp.buf.format()<cr>'},
    }, M.buf_has_lsp)
end
-- menu_add(
--     'Diagnostic.Display_in_QF',
--     '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
-- )
-- menu_add(
--     'Diagnostic.Set_severity_to_warning',
--     '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
-- )
-- menu_add('Diagnostic.Set_severity_to_all', '<cmd>lua vim.diagnostic.config({virtual_text = { severity = nil }})<cr>')

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

M.set_fzf_lua_rclick_menu = function()
    M.set_rclick_submenu('MenuFzfLua', 'FzfLua   ', {
        {'Find File             <space>tf',   '<space>tf'},
        {'Live Grep             <space>tg',   '<space>tg'},
        {'Recent Files          <space>th',   '<space>th'},
    })
end

M.set_git_rclick_menu = function()
    M.set_rclick_submenu('MenuTetoGit', 'Git         ', {
        {'Preview Changes       <space>g?',   '<space>g?'},
        {'Prev Hunk             <space>g[',   '<space>g['},
        {'Next Hunk             <space>g]',   '<space>g]'},
        {'Blame Line            <space>gb',   '<space>gb'},
    }, M.buf_is_file)
end

M.set_spectre_rclick_menu = function()
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
-- menu_add('Rest.RunRequest', "<cmd>lua require('rest-nvim').run(true)<cr>")

M.set_rest_rclick_menu = function()
    M.set_rclick_submenu('MenuRest', 'Rest', {
        {'Run request',    "<cmd>lua require('rest-nvim').run(true)<cr>"},
    }, M.buf_is_rest)
end


M.set_sniprun_rclick_menu = function()
    M.set_rclick_submenu('MenuSnipRun', 'SnipRun', {
        {'SnipRun',   '<cmd>SnipRun<cr>'},
        {'SnipTerminate',   '<cmd>SnipTerminate<cr>'},
    }, function () return true end)
end

M.set_repl_rclick_menu = function()
    M.set_rclick_submenu('MenuRepl', 'Repl', {
	 {'Send line', [[<cmd>lua require'luadev'.exec(vim.api.nvim_get_current_line())<cr>]]}
        -- {'SnipRun',   '<cmd>SnipRun<cr>'},
        -- {'SnipTerminate',   '<cmd>SnipTerminate<cr>'},
    }, function () return true end)
end

M.set_toggle_rclick_menu = function()
    M.set_rclick_submenu('MenuToggle', 'Toggle ->', {
        {'Minimap',   '<cmd>MinimapToggle<cr>'},
        {'Obsession',   '<cmd>Obsession<cr>'},
        {'Indent guides',   '<cmd>IndentBlanklineToggle<cr>'},
    }, function () return true end)
end


M.add_component = function(component)
 table.insert(M.active_menus, component)
end

            -- M.set_lsp_rclick_menu()
            -- M.set_repl_rclick_menu()
            -- M.set_rest_rclick_menu()
            -- M.set_spectre_rclick_menu()
            -- M.set_sniprun_rclick_menu()
            -- -- M.set_orgmode_rclick_menu()
            -- M.set_telescope_rclick_menu()
            -- M.set_git_rclick_menu()
            -- M.set_toggle_rclick_menu()
M.add_component(M.set_lsp_rclick_menu)
M.add_component(M.set_spectre_rclick_menu)
M.add_component(M.set_repl_rclick_menu)
M.add_component(M.set_rest_rclick_menu)
M.add_component(M.set_sniprun_rclick_menu)
M.add_component(M.set_toggle_rclick_menu)

-- -- menu_add("Toggle.Biscuits", 'lua require("nvim-biscuits").toggle_biscuits()')

-- menu_add('REPL.Send line', [[<cmd>lua require'luadev'.exec(vim.api.nvim_get_current_line())<cr>]])
-- -- menu_add('REPL.Send selection ', 'call <SID>luadev_run_operator(v:true)')

-- menu_add ("PopUp.Lsp_declaration", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
-- menu_add ("PopUp.Lsp_definition", "<Cmd>lua vim.lsp.buf.definition()<CR>")
-- menu_add('PopUp.LSP_Rename', '<cmd>lua vim.lsp.buf.rename()<cr>')
-- menu_add('PopUp.LSP_Format', '<cmd>lua vim.lsp.buf.format()<cr>')

-- menu_add(
--     'Diagnostic.Display_in_QF',
--     '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
-- )
-- menu_add(
--     'Diagnostic.Set_severity_to_warning',
--     '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
-- )


-- TODO the run it on filetype change too
M.setup_rclick_menu_autocommands = function()
	-- M.set_dap_rclick_menu()
	-- M.set_java_rclick_menu()
	-- M.set_nvimtree_rclick_menu()
    vim.api.nvim_create_autocmd(
        {'BufEnter', 'LspAttach', 'FileType'}, {
		 -- TODO regenerate this function everytime ?
        callback = function()
		  for _, component in ipairs(M.active_menus) do
			component()
		  end
        end
    })
end

M.clear_menu'PopUp'

return M
