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
