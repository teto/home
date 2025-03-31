return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
      provideFormatter = true,
    },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,

    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            -- see https://github.com/b0o/SchemaStore.nvim/issues/8 for info about
            validate = { enable = true },
        },
    },
}
