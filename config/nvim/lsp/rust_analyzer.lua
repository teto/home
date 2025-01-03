return {
	cmd = { 'rust-analyzer' },
	root_dir = vim.fs.root(0, {'Cargo.toml', 'rust-project.json'}),
	filetypes = { "*.rs" },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    -- commitCharactersSupport = false,
                    -- deprecatedSupport = false,
                    -- documentationFormat = { "markdown", "plaintext" },
                    -- preselectSupport = false,
                    snippetSupport = true,
                },
            },
            -- hover = {
            --	 contentFormat = { "markdown", "plaintext" },
            --	 dynamicRegistration = false
            -- },
            -- references = {
            --	 dynamicRegistration = false
            -- },
            -- signatureHelp = {
            --	 dynamicRegistration = false,
            --	 signatureInformation = {
            --	   documentationFormat = { "markdown", "plaintext" }
            --	 }
            -- },
            -- synchronization = {
            --	 didSave = true,
            --	 dynamicRegistration = false,
            --	 willSave = false,
            --	 willSaveWaitUntil = false
            -- }
        },
    },
}
