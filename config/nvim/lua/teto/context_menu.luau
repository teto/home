--[[
inspired by https://gitlab.com/gabmus/nvpunk/-/blob/master/lua/nvpunk/util/context_menu.lua
one can run 'popup <name>' to go straight to the correct menu
As long as entries are submenus, they register "popup" commands
Menu is cleared
]]
--
-- TODO add the number of entries in the top-level menu
local M = {
    active_menus = {},
}

--monkey patching of the neovim vim.api
-- {{{
---@param modes string[] Accepted modes
---@param name string Fullpath to the menu
vim.api.nvim_menu_set = function(modes, name, action)
    for _, m in ipairs(modes) do
        -- .. '.' .. M.format_menu_label(label, {})
        vim.cmd(m .. 'menu ' .. name .. ' ' .. action)
    end
end
-- }}}

local menu_add = vim.api.nvim_menu_set

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function() : boolean
    return not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
    -- return "toto"
end

M.buf_has_treesitter = function() : boolean
    return vim.treesitter.get_parser()
    -- return not vim.tbl_isempty(
    --     vim.lsp.buf_get_clients(vim.api.nvim_get_current_buf())
    -- )
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
    return vim.bo.filetype == 'http'
end

M.buf_is_ft_lua = function()
    return vim.bo.filetype == 'lua'
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
    vim.ui.select(strings, { prompt = prompt }, function(_, idx)
        vim.schedule(funcs[idx])
    end)
end

local MODES = { 'i', 'n' }

--- Clear all entries from the given menu
---@param menu string
M.clear_menu = function(menu)
    pcall(function()
        vim.cmd('aunmenu ' .. menu)
    end)
end

--- Formats the label of a menu entry to avoid errors
---@param label_origin string entry name in the menu
---@param items table
---@return string
M.format_menu_label = function(label_origin, items)
    local label = label_origin
    -- TODO move it as part of the options
    local cascading_menu_suffix = ' ->'
    if items and not vim.tbl_isempty(items) then
        label = label .. cascading_menu_suffix
    end

    local res = string.gsub(label, ' ', [[\ ]])
    res = string.gsub(res, '<', [[\<]])
    res = string.gsub(res, '>', [[\>]])
    return res
end

--- Create an entry for the right click menu
---@param menu string
---@param label string
---@param action string
M.rclick_context_menu = function(menu, label, action)
    for _, m in ipairs(MODES) do
        vim.cmd(m .. 'menu ' .. menu .. '.' .. M.format_menu_label(label, {}) .. ' ' .. action)
    end
end

--- Set up a right click submenu
---@param menu_name string
---@param submenu_label string
---@param items table[{string, string}]
---@param bindif function?
M.set_rclick_submenu = function(menu_name, submenu_label, items, bindif)
    M.clear_menu(menu_name)
    -- M.clear_menu('PopUp.' .. M.format_menu_label(submenu_label, items))
    if bindif ~= nil then
        if not bindif() then
            return
        end
    end
    for _, i in ipairs(items) do
        M.rclick_context_menu(menu_name, i[1], i[2])
    end
    M.rclick_context_menu('PopUp', submenu_label, '<cmd>popup ' .. menu_name .. '<cr>')
end

-- vim.diagnostic.config({
--     -- disabled because too big in haskell
--     virtual_lines = false,
--     virtual_text = true,
--     -- {
--     -- severity = { min = vim.diagnostic.severity.WARN }
--     -- },
--     signs = true,
--     severity_sort = true,
-- })

-- This is a hack to test disabling stan works
M.restart_hls = function()
    local my_hls_tools = require('teto.haskell-tools')
    local new_settings = my_hls_tools.toggle_stan()
    vim.g.settings = new_settings
    vim.cmd([[ HlsRestart ]])
end

-- menu_get({path} [, {modes}])                                        *menu_get()*
-- menu_add('LSP')

M.set_lsp_rclick_menu = function()
    M.set_rclick_submenu('TetoMenuLsp', 'LSP         ', {
        { 'Code Actions           <space>ca', '<space>ca' },
        { 'Go to Declaration             gD', 'gD' },
        { 'Go to Definition              gd', 'gd' },
        { 'Go to Implementation          gI', 'gI' },
        { 'Signature Help             <C-k>', '<C-k>' },
        { 'Rename', '<cmd>lua vim.lsp.buf.rename()<cr>' },
        { 'References                    gr', 'gr' },
        -- { 'Expand Diagnostics      <space>e', '<space>e' },
        { 'Auto Format', '<cmd>lua vim.lsp.buf.format()<cr>' },
        -- error only
        { 'Show diagnostics inline', "<cmd>lua require'teto.lsp'.toggle_diagnostic_display()<cr>" },
        { 'Show errors only', "<cmd>lua require'teto.lsp'.set_level(vim.diagnostic.severity.ERROR)<cr>" },
        { 'Show all levels', "<cmd>lua require'teto.lsp'.set_level(vim.diagnostic.severity.HINTS)<cr>" },
        --
        --
        { 'Apply all code actions', "<cmd>echo 'TODO'" },
        -- command! LspStopAllClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())
        { 'Stop all clients', '<cmd>lua', { desc = 'stop all lsp clients' } },
        -- TODO
        {
            'Haskell: toggle stan',
            "<cmd>lua require'teto.context_menu'.restart_hls()<CR>",
            {
                -- callback = "",
                desc = 'Disable stan',
            },
        },
        -- {'Toggle hints only', ''},
    }, M.buf_has_lsp)

    -- if it is haskell we can have items to
    -- hls_tools.lsp.load_hls_settings(project_root)
end
menu_add(
    { 'n' },
    'Diagnostic.Display_in_QF',
    '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
)
menu_add(
    { 'n' },
    'Diagnostic.Set_severity_to_warning',
    '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
)
-- menu_add('Diagnostic.Set_severity_to_all', '<cmd>lua vim.diagnostic.config({virtual_text = { severity = nil }})<cr>')

M.set_dap_rclick_menu = function()
    M.set_rclick_submenu('TetoMenuDap', 'Debug       ', {
        { 'Show DAP UI           <space>bu', '<space>bu' },
        { 'Toggle Breakpoint     <space>bb', '<space>bb' },
        { 'Continue              <space>bc', '<space>bc' },
        { 'Terminate             <space>bk', '<space>bk' },
    }, M.buf_has_dap)
end

M.set_telescope_rclick_menu = function()
    M.set_rclick_submenu('TetoTelescopeMenu', 'Telescope   ', {
        { 'Find File             <space>tf', '<space>tf' },
        { 'Live Grep             <space>tg', '<space>tg' },
        { 'Recent Files          <space>th', '<space>th' },
    })
end

M.set_fzf_lua_rclick_menu = function()
    M.set_rclick_submenu('MenuFzfLua', 'FzfLua   ', {
        { 'Find File             <space>tf', '<space>tf' },
        { 'Live Grep             <space>tg', '<space>tg' },
        { 'Recent Files          <space>th', '<space>th' },
    })
end

M.set_git_rclick_menu = function()
    -- map gitsigns
    M.set_rclick_submenu('MenuTetoGit', 'Git         ', {
        { 'Preview Changes       <space>g?', '<space>g?' },
        { 'Prev Hunk             <space>g[', '<space>g[' },
        { 'Next Hunk             <space>g]', '<space>g]' },
        { 'Blame Line            <space>gb', '<space>gb' },
    }, M.buf_is_file)
end

M.set_repl_luadev_rclick_menu = function()
    M.set_rclick_submenu('MenuTetoReplLuadev', 'Luadev         ', {
        { 'Send line', [[<cmd>lua require'luadev'.exec(vim.api.nvim_get_current_line())<cr>]] },
        { 'Run       ,a', '<Plug>(Luadev-Run)' },
        { 'Run line  ,,', '<space>g[' },
    }, M.buf_is_file)
end

-- menu_add('Rest.RunRequest', "<cmd>lua require('rest-nvim').run(true)<cr>")

M.set_rest_rclick_menu = function()
    M.set_rclick_submenu('MenuRest', 'Rest', {
        { 'Run request', "<cmd>lua require('rest-nvim').run(false)<cr>" },
        { 'Run request (verbose)', "<cmd>lua require('rest-nvim').run({ verbose = true})<cr>" },
    }, M.buf_is_rest)
end

M.set_sniprun_rclick_menu = function()
    M.set_rclick_submenu('MenuSnipRun', 'SnipRun', {
        { 'SnipRun', '<cmd>SnipRun<cr>' },
        { 'SnipTerminate', '<cmd>SnipTerminate<cr>' },
    }, function()
        return true
    end)
end

M.set_repl_iron_rclick_menu = function()
    M.set_rclick_submenu('MenuTetoReplIron', 'Luadev         ', {
        { 'Run       ,a', '<Plug>(Luadev-Run)' },
        { 'Run line  ,,', '<space>g[' },
    }, M.buf_is_file)
end

M.toggle_lsp_lines = function()
    vim.notify('Toggling lsp_lines')
    -- local cfg = vim.diagnostic.config()
    -- if cfg.virtual_lines then
    --  vim.notify("Setting it to false "..tostring(cfg.virtual_lines))
    --  cfg.virtual_lines = false
    --  require'teto.lsp'.set_lsp_lines(false)

    -- else
    --  require'teto.lsp'.set_lsp_lines(true)
    --   -- only_current_line
    -- end
    require('lsp_lines').toggle()
end

local show_toggle = function(current_status)
    -- assert(type(current_status) == "boolean", "Expecting a boolean value")
    -- print(type(current_status))
    return tostring(current_status)
end

M.set_toggle_rclick_menu = function()
    local lsp_status = not vim.diagnostic.config().virtual_lines
    M.set_rclick_submenu('MenuToggle', 'Toggle ->', {
        { 'Autosave', '<cmd>MinimapToggle<cr>' },
        { 'Minimap', '<cmd>MinimapToggle<cr>' },
        { 'Obsession', '<cmd>Obsession<cr>' },
        { 'Indent guides', '<cmd>IndentBlanklineToggle<cr>' },
        {
            'Toggle lsp lines ' .. show_toggle(lsp_status),
            "<cmd>lua require('teto.context_menu').toggle_lsp_lines()<cr>",
        },
    }, function()
        return true
    end)
end

M.set_autocompletion_rclick_menu = function()
    M.set_rclick_submenu('MenuTreesitter', 'Treesitter ->', {
        { 'Show tree', '<cmd>lua vim.treesitter.show_tree()<cr>' },
        -- {'Obsession',   '<cmd>Obsession<cr>'},
        -- {'Indent guides',   '<cmd>IndentBlanklineToggle<cr>'},
    }, function()
        return true
    end)
end

M.set_treesitter_rclick_menu = function()
    M.set_rclick_submenu('MenuTreesitter', 'Treesitter ->', {
        { 'Show tree', '<cmd>lua vim.treesitter.show_tree()<cr>' },
        -- {'Obsession',   '<cmd>Obsession<cr>'},
        -- {'Indent guides',   '<cmd>IndentBlanklineToggle<cr>'},
    }, function()
        return true
    end)
end

M.add_component = function(component)
    table.insert(M.active_menus, component)
end

-- toto
M.set_tabs_rclick_menu = function(_component)
    M.set_rclick_submenu('MenuTabs', 'Tabs', {
        { 'Tabs.S2', '<cmd>set  tabstop=2 softtabstop=2 sw=2<cr>' },
        { 'Tabs.S4', '<cmd>set ts=4 sts=4 sw=4<CR>' },
        { 'Tabs.S6', '<cmd>set ts=6 sts=6 sw=6<CR>' },
        { 'Tabs.S8', '<cmd>set ts=8 sts=8 sw=8<CR>' },
    })
    -- menu_add("Tabs.SwitchExpandTabs :set expandtab!")
end

-- menu_add("Toggle.Biscuits", 'lua require("nvim-biscuits").toggle_biscuits()')

-- menu_add(
--     'Diagnostic.Display_in_QF',
--     '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
-- )
-- menu_add(
--     'Diagnostic.Set_severity_to_warning',
--     '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
-- )
-- menu_add('Diagnostic.Set_severity_to_all', '<cmd>lua vim.diagnostic.config({virtual_text = { severity = nil }})<cr>')

-- menu_add_cmd('Search.Search_and_replace', "lua require('spectre').open()")
-- menu_add('Search.Test', 'let a=3')

-- menu_add("Search.Search\ in\ current\ Buffer", :Grepper -switch -buffer")
-- menu_add("Search.Search\ across\ Buffers :Grepper -switch -buffers")
-- menu_add("Search.Search\ across\ directory :Grepper")
-- menu_add("Search.Autoopen\ results :let g:grepper.open=1<CR>")

-- menu_add("DAP.Add breakpoint", 'lua require"dap".toggle_breakpoint()')
-- menu_add("DAP.Continue", 'lua require"dap".continue()')
-- menu_add("DAP.Open repl", 'lua require"dap".repl.open()')

-- TODO this uses stylish
function open_contextual_menu()
    -- getcurpos()	Get the position of the cursor.  This is like getpos('.'), but
    --		includes an extra "curswant" in the list:
    --			[0, lnum, col, off, curswant] ~
    --		The "curswant" number is the preferred column when moving the
    --		cursor vertically.	Also see |getpos()|.
    --		The first "bufnum" item is always zero.

    local curpos = vim.fn.getcurpos()

    local menu_opts = {
        kind = 'menu',
        prompt = 'Main menu',
        experimental_mouse = true,
        position = {
            screenrow = curpos[2],
            screencol = curpos[3],
        },
        -- ignored
        -- width = 200,
        -- height = 300,
    }

    -- print('### ' ..res)
    require('stylish').ui_menu(vim.fn.menu_get(''), menu_opts, function(res)
        vim.cmd(res)
    end)
end

-- vim.g.menu

--[[ TODO the run it on filetype change too
Check 'mousemodel'
-- t'LspAttach', 'FileType'his 
]]
--
--
M.setup_rclick_menu_autocommands = function()
    -- 'LspAttach', 'FileType'
    -- local has_spectre, spectre = pcall(require, 'spectre')

    vim.api.nvim_create_autocmd({ 'MenuPopup' }, {

        -- TODO regenerate this function everytime ?
        callback = function()
            -- 1. we clear the menu
            M.clear_menu('PopUp')

            -- 2. we configure the menu
            M.add_component(M.set_lsp_rclick_menu)
            -- M.add_component(M.set_grugfar_rclick_menu)
            M.add_component(M.set_repl_iron_rclick_menu)
            M.add_component(M.set_rest_rclick_menu)
            M.add_component(M.set_sniprun_rclick_menu)
            M.add_component(M.set_toggle_rclick_menu)
            M.add_component(M.set_treesitter_rclick_menu)
            M.add_component(M.set_tabs_rclick_menu)
            M.add_component(M.set_git_rclick_menu)
            M.add_component(M.set_autocompletion_rclick_menu)
            M.add_component(M.set_diagnostic_rclick_menu)
            -- -- M.set_orgmode_rclick_menu()
            -- M.rclick_context_menu("PopUp", "Autosave", "toto"
            -- -- "
            --  -- function () require'autosave'.on() end
            --  )

            -- 3. we regenerate the menu
            for _, component in ipairs(M.active_menus) do
                component()
            end
        end,
    })
end

-- options is a table or string, if string then it will look at the table from menus* module of this repo
-- opts : { mouse = true, border = false }"
--
vim.keymap.set('n', '<C-t>', function()
    require('menu').open('default')
end, {})

return M
