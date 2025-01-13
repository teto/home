return {
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            -- see https://github.com/b0o/SchemaStore.nvim/issues/8 for info about
            validate = { enable = true },
        },
    },
}
