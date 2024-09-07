require('auto-session').setup({
    log_level = 'error',
    auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
	root_dir = vim.fn.stdpath "data" .. "/sessions/", -- Root dir where sessions will be stored
    session_root_dir = '.', -- vim.fn.stdpath('data').."/sessions/",
    use_git_branch = false,
	lazy_support = false, 
	bypass_save_filetypes = nil,
	log_level = "debug",
})

-- used to be obsession
vim.keymap.set('n', '<Leader>$', '<Cmd>SessionSave<CR>')
