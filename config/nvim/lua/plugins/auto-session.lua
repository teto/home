require('auto-session').setup({
    log_level = 'error',
    auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    auto_session_root_dir = '.', -- vim.fn.stdpath('data').."/sessions/",
    auto_session_use_git_branch = false,
})
