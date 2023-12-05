
vim.keymap.set('n', '<leader>wn', '<cmd>Neorg workspace notes<CR>', {silent = true}) -- just this block or blocks within heading section
vim.keymap.set('n', '<localleader>x', '<cmd>Neorg exec cursor<CR>', {silent = true}) -- just this block or blocks within heading section
vim.keymap.set('n', '<localleader>X', '<cmd>Neorg exec current-file<CR>', {silent = true}) -- whole file
