local start_time = 0

local on_start_request = function(req)
    -- vim.loop.gettimeofday()
    -- vim.fn.reltime()
    start_time = vim.loop.now()
    print('starting request')
end

local on_stop_request = function(req)
    local duration = vim.loop.now() - start_time
    print('stopped request with duration of ', duration)
end

-- vim.api.nvim_create_autocmd("User", {
-- pattern = "RestStartRequest",
-- once = true,
--   callback = on_start_request
-- })

-- vim.api.nvim_create_autocmd("User", {
-- pattern = "RestStopRequest",
-- once = true,
--   callback =  on_stop_request
-- })

-- while testing/developing rest.nvim
-- vim.opt.runtimepath:prepend('/home/teto/rest.nvim')
-- vim.opt.runtimepath:prepend('/home/teto/tree-sitter-http')
-- lua require'plenary.reload'.reload_module('rest-nvim.request')
-- vim.opt.runtimepath:prepend('/home/teto/nvim-treesitter')

vim.keymap.set(
    'n',
    '<f2>',
    "<cmd>lua require'plenary.reload'.reload_module('rest-nvim.request'); print(require'rest-nvim.request'.ts_get_requests())<cr>"
)
