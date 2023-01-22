local M = {}

-- lua print(vim.inspect(vim.lsp.get_active_clients()))
-- lsp.get_active_clients()
-- We dont have access to unitialized clients
function M.lsp_diagnose_active_client(name)
    local c
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.name == name then
            c = client
            M.lsp_dump_active_client(c)
            break
        end
    end

    if not c then
        print('Could not find the client ' .. name .. ' in the list of active clients')
    end
    -- function lsp.start_client(config)
end

local report_error = vim.fn['health#report_error']
local report_info = vim.fn['health#report_info']

function M.check_health()
    print('active clients')
    for key, client in pairs(vim.lsp.get_active_clients()) do
        -- print("loading key "..key)
        M.lsp_dump_active_client(client)
    end
end

function M.lsp_dump_active_client(client)
    local config = client.config
    vim.fn['health#report_start']('State of ' .. config.name)
    report_info('Working directory: ' .. config.root_dir)
end

return M
