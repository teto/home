local _, fzf_lua = pcall(require, "fzf-lua")

local M = {}

function M.register_keymaps()

-- autocomplete :FzfLua to see what's available
vim.keymap.set ('n', "<Leader>g", function () fzf_lua.files() end)
vim.keymap.set ('n', "<Leader>o", function () fzf_lua.git_files() end)
vim.keymap.set ('n', "<Leader>F", function () vim.cmd("FzfFiletypes") end, {desc= "Select fileype"} )
vim.keymap.set ('n', "<Leader>h", function () vim.cmd("FzfHistory") end)
vim.keymap.set ('n', "<Leader>t", function () fzf_lua.tags() end, {desc= "Fuzzysearch tags"} )
vim.keymap.set ('n', "<Leader>T", function () fzf_lua.tags() end, {desc= "Fuzzysearch tags"} )
vim.keymap.set ('n', "<Leader>b", function () fzf_lua.buffers() end, {desc= "Fuzzysearch buffers"} )
vim.keymap.set ('n', "<Leader>C", function () fzf_lua.colorschemes() end, {desc= "Select a colorscheme"} )
vim.keymap.set ('n', "<Leader>l", function () fzf_lua.live_grep() end )
vim.keymap.set ('n', "<Leader>m", function () fzf_lua.menus() end, {desc= "Fuzzy search menu entries"} )

end
return M
