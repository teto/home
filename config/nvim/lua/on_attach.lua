local M = {}

local function default_mappings()
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = true })
    vim.keymap.set('n', 'gA', vim.lsp.buf.code_action, { buffer = true })
    vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, { buffer = true })

    vim.keymap.set('n', '[e', function()
        vim.diagnostic.goto_prev({ wrap = true })
    end, { buffer = true })
    vim.keymap.set('n', ']e', function()
        vim.diagnostic.goto_next({ wrap = true })
    end, { buffer = true })
    vim.keymap.set('n', '<c-k>', function()
        vim.diagnostic.goto_prev({ wrap = true })
    end, { buffer = true })
    vim.keymap.set('n', '<c-j>', function()
        vim.diagnostic.goto_next({ wrap = true })
    end, { buffer = true })
    vim.keymap.set('n', ']l', function()
        vim.diagnostic.goto_next({ wrap = true })
    end, { buffer = true })
    vim.keymap.set('n', '[l', function()
        vim.diagnostic.goto_prev({ wrap = true })
    end, { buffer = true })
end

M.on_attach = function(client, _bufnr)
    default_mappings()
    client.server_capabilities.semanticTokensProvider = nil

    -- vim.bo.omnifunc = vim.lsp.omnifunc
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

return M
