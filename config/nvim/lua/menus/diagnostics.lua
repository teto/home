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
			vim.diagnostic.setloclist()
			-- vim.diagnostic.setqflist()
        end,
    },
}
