-- trigger some deprecated warning. Is there some native equivalent ?
-- local has_signature, signature = pcall(require, 'lsp_signature')
-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'Attach lsp_signature on new client',
--     callback = function(args)
--         if not (args.data and args.data.client_id) then
--             return
--         end
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         local bufnr = args.buf
--         require('lsp_signature').on_attach(client, bufnr)
--     end,
-- })
