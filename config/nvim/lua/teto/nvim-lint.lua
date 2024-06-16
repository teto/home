local flake8 = require('lint').linters.flake8
-- flake8.args
require('lint').linters_by_ft = {
    -- markdown = {'vale',}
    -- --ignore E501,E265,E402 update.py
    python = { 'flake8' },
    sh = { 'shellcheck' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
        require('lint').try_lint()
    end,
})
