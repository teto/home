return {
    cmd = {
        'clangd',
        '--background-index',
        -- "--log=info", -- error/info/verbose
        -- "--pretty" -- pretty print json output
        '--compile-commands-dir=build',
    },
    root_markers = { '.clangd', 'compile_commands.json' },

    -- root_dir = function(fname)
    --   return util.root_pattern(
    --     '.clangd',
    --     '.clang-tidy',
    --     '.clang-format',
    --     'compile_commands.json',
    --     'compile_flags.txt',
    --     'configure.ac' -- AutoTools
    --   )(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    -- end,

    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
}
