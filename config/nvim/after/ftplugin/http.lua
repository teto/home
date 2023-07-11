-- vim.keymap.set('n',  '<C-J>' , "<Plug>RestNvim<cr>")
vim.keymap.set('n', '<leader>rr', '<Plug>RestNvim<cr>', { remap = true, desc = 'Run an http request' })
vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { remap = true, desc = 'Preview an http request' })
vim.keymap.set('n', '<C-j>', "<cmd>lua require('rest-nvim').run(false)<cr>")


