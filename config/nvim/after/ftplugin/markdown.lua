-- Enable markdown concealment
-- This will hide/prettify markdown syntax elements like **bold**, *italic*, [links](url), etc.
-- setlocal textwidth=80

vim.opt_local.conceallevel = 2
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
-- vim.g.markdown_folding = 1

-- Note: concealcursor is set globally in init-manual.lua to 'nc'
-- This means concealment works in normal/command mode but not insert mode
-- so you can still see the raw syntax when editing
vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr
-- check first line for japanese and enable it
