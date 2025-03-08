require('ibl').setup()

-- show Blank Line only in active window
local blanklineGrp = vim.api.nvim_create_augroup('BlankLine', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, { pattern = '*', command = ':IBLEnable', group = blanklineGrp })
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, { pattern = '*', command = ':IBLDisable', group = blanklineGrp })
