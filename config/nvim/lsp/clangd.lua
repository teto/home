return {
    cmd = {
        'clangd',
        '--background-index',
        -- "--log=info", -- error/info/verbose
        -- "--pretty" -- pretty print json output
        --compile-commands-dir=build
    },
    root_markers = { '.clangd', 'compile_commands.json' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
}
