-- vim.keymap.set('n',  '<C-J>' , "<Plug>RestNvim<cr>")
vim.keymap.set('n', '<leader>rr', '<Plug>RestNvim<cr>', { remap = true, desc = 'Run an http request' })
vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { remap = true, desc = 'Preview an http request' })
vim.keymap.set('n', '<C-j>', "<cmd>lua require('rest-nvim').run_request({ verbose = false; engine = 'classic';})<cr>")

vim.api.nvim_create_user_command("RestFile", function ()
  local filename = "/home/teto/neovim/rest.nvim/tests/basic_get.http"
  local _res = require('rest-nvim').run_file(filename , { verbose = false; })
  -- print("Found ".. #requests .. " requests ! ")
 end, { desc = "Running whole file"}
  )

-- show the number of queries found
-- engine = 'classic';
vim.api.nvim_create_user_command("RestCount", function ()
  local requests = require('rest-nvim.request.classic').buf_list_requests(vim.fn.bufnr(), { verbose = false; })
  print("Found ".. #requests .. " requests ! ")
 end, { desc = "toto"}
  )
-- vim.api.nvim_create_user_command("RestCount"
-- vim.keymap.set('n', '<C-j>', "<cmd>lua require('rest-nvim').run(false)<cr>")

