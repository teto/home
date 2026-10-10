return {

    {
        name = 'Toggle lines',
        cmd = function()
            vim.notify('Toggling lsp_lines')
            vim.diagnostic.config({
                virtual_lines = not vim.diagnostic.config().virtual_lines,
            })
        end,
    },
    {
        name = 'Errors only',
        cmd = function()
            -- severity = { min = vim.diagnostic.severity.WARN },
        end,
    },
    {
        name = 'To loclist',
        cmd = function()
            vim.notify('To qflist')
            local opts = {

                title = 'Diagnostics from menu',
                format = function(d)
                    return d.message .. '( ' .. d.source .. ')'
                end,
            }
            vim.diagnostic.setloclist(opts)
            -- vim.diagnostic.setqflist()
        end,
    },
}
