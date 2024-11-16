return {

    {
        name = 'Toggling lsp_lines',
        cmd = function()
            vim.notify('Toggling lsp_lines')
            require('lsp_lines').toggle()
        end,
    },
}
