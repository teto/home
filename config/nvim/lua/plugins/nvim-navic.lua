local navic = require('nvim-navic')
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Attach lsp_signature on new client',
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
        -- navic.attach(client, bufnr)
        -- local on_attach = require 'on_attach'
        -- on_attach.on_attach(client, bufnr)
    end,
})
