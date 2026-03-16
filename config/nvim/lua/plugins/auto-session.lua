require('auto-session').setup({
    suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    root_dir = vim.fn.stdpath('data') .. '/sessions/', -- Root dir where sessions will be stored
    session_root_dir = '.', -- vim.fn.stdpath('data').."/sessions/",
    use_git_branch = false,
    lazy_support = false,
    log_level = 'error', -- debug hijacks cmdline
    bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
    close_filetypes_on_save = { 'checkhealth' }, -- Buffers with matching filetypes will be closed before saving

    -- Not clear wether those work
    args_allow_single_directory = true, -- boolean Follow normal session save/load logic if launched with a single directory as the only argument
    args_allow_files_auto_save = false, -- boolean|function Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
})

-- used to be obsession
vim.keymap.set('n', '<Leader>$', '<Cmd>SessionSave<CR>')
