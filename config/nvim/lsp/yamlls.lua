

-- see https://github.com/redhat-developer/yaml-language-server for doc
return {
    cmd = { 'yaml-language-server', '--stdio' },
    --   on_attach = lsp.on_attach,
    --   capabilities = lsp.capabilities,
    settings = {
        yaml = {
            -- customTags
            schemaStore = { enable = true },
            -- schemas = require('schemastore').yaml.schemas(),

            format = {
                enable = true,
                proseWrap = 'Preserve',
                printWidth = 120,
            },
        },
    },
    -- }
}
