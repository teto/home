local M = {}

-- local on_click_gp = function(_nb_of_clicks, _button, _modifiers)
--     -- vim.notify("builtins GP.nvim")
--     local menu_opts = {
--         mouse = true,
--         border = false,
--     }
--
--     -- list possible agents from the api
--     -- one can look at agent_completion
--     local agents = require('gp')._chat_agents
--
--     local entries = {}
--     for _, ag in ipairs(agents) do
--         -- print("Adding entry", tostring(ag))
--         entries[#entries + 1] = {
--             -- rtxt
--             name = tostring(ag),
--             cmd = ':GpAgent ' .. tostring(ag),
--         }
--         -- print("Nb of entries", #entries)
--     end
--
--     -- vim.print(entries)
--     -- entries must be non empty else nvim will complain about 'height' being not positive
--     require('menu').open(entries, menu_opts)
-- end

function M.setup_autocmd()
    -- the prompt is long with tools, look at get_ReAct_system_prompt()
    -- add_text_message
    -- look for base_body.tools
    vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'AvanteViewBufferUpdated',
        desc = 'display provider statistics in statusline',
        callback = function(args)
            -- todo get if error or not
            vim.notify('Got an answer')
            -- print("Called matt's on_attach autocmd")
            -- todo log, get nbeovim logger
            -- if not (args.data and args.data.client_id) then
            --     return
            -- end

            -- vim.print('received args ')
            -- vim.print(args)
        end,
    })
    -- "AvanteViewBufferUpdated"
    -- vim.api.nvim_create_user_command('', '!hasktags .', { desc = 'Regenerate tags' })

    -- https://github.com/NixOS/nixpkgs/pull/408463
    -- require("avante.api").ask()
    vim.keymap.set({ 'n', 'v' }, 'F2', function()
        require('avante.api').ask({ without_selection = true })
    end, { noremap = true })
end

-- custom renderer for input prompt, to show the currently selected provider !
-- inspired by Sidebar:render_header
-- function M.render_header()
--     -- if not bufnr or not api.nvim_buf_is_valid(bufnr) then return end
--
--     local function format_segment(text, highlight)
--         return '%#' .. highlight .. '#' .. text
--     end
--
--     -- if Config.windows.sidebar_header.rounded then
--     --   header_text = format_segment(Utils.icon("", "『"), reverse_hl)
--     --     .. format_segment(header_text, hl)
--     --     .. format_segment(Utils.icon("", "』"), reverse_hl)
--     -- else
--     --   header_text = format_segment(" " .. header_text .. " ", hl)
--     -- end
--     local header_text = string.format(
--         '%s%s (%s)',
--         Utils.icon('󱜸 '),
--         'Ask' or 'Chat with',
--         Config.provider
--         -- Config.mappings.sidebar.switch_windows
--     )
--
--     local winbar_text
--     -- if Config.windows.sidebar_header.align == "left" then
--     --   winbar_text = header_text .. "%=" .. format_segment("", Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
--     -- elseif Config.windows.sidebar_header.align == "center" then
--     winbar_text = format_segment('%=', Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
--         .. header_text
--         .. format_segment('%=', Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
--     -- elseif Config.windows.sidebar_header.align == "right" then
--     --   winbar_text = format_segment("%=", Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR) .. header_text
--     -- end
--
--     -- print(winbar_text)
--     -- winbar_text = "tOTO"
--     return winbar_text
--     --  api.nvim_set_option_value("winbar", winbar_text, {
--     -- win = winid
--     --  })
-- end

vim.api.nvim_create_autocmd('User', {
    pattern = 'ToggleMyPrompt',
    callback = function()
        require('avante.config').override({ system_prompt = 'MY CUSTOM SYSTEM PROMPT' })
    end,
})

vim.keymap.set('n', '<leader>am', function()
    vim.api.nvim_exec_autocmds('User', { pattern = 'ToggleMyPrompt' })
end, { desc = 'avante: toggle my prompt' })

vim.keymap.set('n', '<Leader>lm', '<Plug>AvanteModels', { desc = 'List models' })

---@param prompt string
function M.ask(prompt)
    local rag_service = require('avante.rag_service')

    -- resp is a lua value decoded from json ?
    local on_complete = function(resp, error)
        if error then
            vim.print(error)
        else
            -- my notify override uses jobstart, which can't be called in fast context so we delay the call
            vim.schedule(function()
                vim.print(resp.response)
                vim.notify('Received RAG answer', vim.log.levels.INFO)
            end)
        end
    end

    local filename = vim.api.nvim_buf_get_name(0)

    -- ideally we dont need the filename ?
    local results, err = rag_service.retrieve(filename, prompt, on_complete)
end

return M
