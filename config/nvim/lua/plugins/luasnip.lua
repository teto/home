-- debug with :LuaSnipListAvailable
-- this removes digraphs !
-- vim.keymap.set({ 'i' }, '<C-K>', function()
--     ls.expand()
-- end, { silent = true, desc = 'Invoke luasnip' })
vim.keymap.set({ 'i', 's' }, '<C-L>', function()
    ls.jump(1)
end, { silent = true })

require('teto.snippets')
