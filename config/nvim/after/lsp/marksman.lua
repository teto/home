return {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_dir = function(fname)
        local root_files = { '.marksman.toml', '.git' }
        -- util.root_pattern(unpack(root_files))(fname)
        return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
}
