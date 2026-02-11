-- Recommended/example keymaps.
-- vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
-- vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ 'n', 't' }, '<C-.>', function()
    require('opencode').toggle()
end, { desc = 'Toggle opencode' })

vim.keymap.set({ 'n', 'x' }, 'go', function()
    return require('opencode').operator('@this ')
end, { desc = 'Add range to opencode', expr = true })
vim.keymap.set('n', 'goo', function()
    return require('opencode').operator('@this ') .. '_'
end, { desc = 'Add line to opencode', expr = true })

vim.keymap.set('n', '<S-C-u>', function()
    require('opencode').command('session.half.page.up')
end, { desc = 'Scroll opencode up' })
vim.keymap.set('n', '<S-C-d>', function()
    require('opencode').command('session.half.page.down')
end, { desc = 'Scroll opencode down' })

-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })
