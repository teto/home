return {

    {
        name = 'Toggle lines',
        cmd = function()
		  vim.diagnostic.config {
			virtual_lines = not vim.diagnostic.config().virtual_lines;
		   }
            vim.notify('Toggling lsp_lines')
        end,
    },
	{
	 name = "just errors",
	 cmd = function ()
	   -- severity = { min = vim.diagnostic.severity.WARN },
	 end


	}
}
