local M = {}

local has_signature, signature = pcall(require, 'lsp_signature')

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

M.on_attach = function(client)
    default_mappings()

    -- vim.bo.omnifunc = vim.lsp.omnifunc
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

    if has_signature then
        signature.on_attach() -- Note: add in lsp client on-attach
    end
    -- require'virtualtypes'.on_attach()
end

return M
