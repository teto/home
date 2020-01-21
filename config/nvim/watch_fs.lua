--
package.path = "/home/teto/neovim/runtime/lua/vim/?.lua;" .. package.path
-- print(package.path)
fswatch = require 'fswatch'


-- Inspiration taken from:
-- https://teukka.tech/luanvim.html
-- https://github.com/neovim/neovim/pull/1791
function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

local autocmds = {
  fsnotif = {
		-- -- "VimEnter",        "*",      [[lua sourceCScope()]]};

	-- -- TODO use lua
    "BufRead"     ,   "*", [[lua fswatch.watch_file(vim.fn.expand('<afile>')) ]],
  --   "BufDelete"   ,   "*", call notify_unregister(expand('<afile>'))
  --   "BufWritePre" ,   "*", call notify_set(expand('<afile>'), 0)
  --   "FileWritePre",   "*", call notify_set(expand('<afile>'), 0)
  --   "FileAppendPre",  "*", call notify_set(expand('<afile>'), 0)
  --   "BufWritePost",   "*", call notify_register(expand('<afile>'))
  --   "FileWritePost",  "*", call notify_register(expand('<afile>'))
  --   "FileAppendPost", "*", call notify_register(expand('<afile>'))
 
  --   "BufFilePre",     "*", call notify_unregister(expand('<afile>'))
  --   "BufFilePost",    "*", call notify_register(expand('<afile>'))


  }
}

local function test_watcher()
    -- "BufRead"     ,   "*", [[lua fswatch.watch_file(vim.fn.expand('<afile>')) ]],
	vim.api.nvim_command("autocmd! BufRead * lua fswatch.watch_file(vim.fn.expand('<afile>'))")
end
test_watcher()
-- nvim_create_augroups(autocmds)

