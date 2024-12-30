return {
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
    cmd = { 'rust-analyzer' },
    root_dir = lspconfig.util.root_pattern('Cargo.toml', 'rust-project.json'),
}
