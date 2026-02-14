-- conflicts with iron.repl

require('snacks').setup({

    image = {
        enabled = true,
    },
    bigfile = {
        enabled = true,
        notify = true, -- show notification when big file detected
    },
})

-- vim.keymap.set('n', 's', function()
--     require('snacks').scratch()
-- end, { desc = 'Toggle Scratch Buffer' })
