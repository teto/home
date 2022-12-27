require("vim")

-- vim.o.ignorecase = true
-- vim.o.smartcase = true
vim.o.incsearch = true

vim.o.hidden = true

vim.o.history = 5000

vim.o.tabstop = 4
vim.o.shiftwidth = vim.o.tabstop
vim.g.mapleader = " "

-- vim.keymap.set('n', '<space>q', ':qa<cr>')
-- vim.keymap.set('n', '<space>hw', function()
--    print("hello world")
-- end)
