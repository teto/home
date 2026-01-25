local pyrightCapabilities = vim.lsp.protocol.make_client_capabilities()
pyrightCapabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

local root_files = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
}

return {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = pyrightCapabilities,
    root_markers = root_files,

    settings = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
        -- https://microsoft.github.io/pyright/#/settings
        python = {
            analysis = {
                -- enum { "Error", "Warning", "Information", "Trace" }
                logLevel = 'Warning',
                --						autoSearchPaths= true;
                -- diagnosticMode = 'workspace';
                --
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic', -- 'off', 'basic', 'strict'
                diagnosticSeverityOverrides = {
                    reportUnusedVariable = false,
                    reportUnusedFunction = false,
                    reportUnusedClass = false,
                    reportPrivateImportUsage = 'none',
                    reportMissingImports = false,
                },
                disableOrganizeImports = true,
                reportConstantRedefinition = true,
                autoSearchPaths = true,

                diagnosticMode = 'openFilesOnly', -- or workspace
                extraPaths = {
                    -- "pkgs/applications/editors/vim/plugins"
                    -- "/home/teto/nixpkgs3/maintainers/scripts"
                },
                -- reportUnknownParameterType
                -- diagnosticSeverityOverrides = {
                --		reportUnusedImport = "warning";
                -- };
            },
        },
        pyright = {
            disableOrganizeImports = true,
            reportUnusedVariable = false,
        },
    },
}
