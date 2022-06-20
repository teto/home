local M = {}
function M.telescope_create_keymaps()

-- lua require('telescope.builtin').vim_options{}

vim.keymap.set ('n', "<Leader>g", function () vim.cmd("FzfFiles") end)
vim.keymap.set ('n', "<Leader>o", function () vim.cmd("FzfGitFiles") end)
vim.keymap.set ('n', "<Leader>F", function () vim.cmd("FzfFiletypes") end)
vim.keymap.set ('n', "<Leader>h", function () vim.cmd("FzfHistory") end)
vim.keymap.set ('n', "<Leader>t", function () require'telescope.builtin'.tags{} end )
vim.keymap.set ('n', "<Leader>C",
  function () require'telescope.builtin'.colorscheme{ enable_preview = true; } end 
)
end

return M
