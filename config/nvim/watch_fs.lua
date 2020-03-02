--
package.path = "/home/teto/neovim3/runtime/lua/vim/?.lua;" .. package.path
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
    "BufDelete"   ,   "*", [[lua fswatch.stop(vim.fn.expand('<afile>'))]],
    "BufWritePre" ,   "*", [[lua fswatch.stop(vim.fn.expand('<afile>'), 0)]],
    "FileWritePre",   "*", [[lua fswatch.stop(vim.fn.expand('<afile>'), 0)]],
    "FileAppendPre",  "*", [[lua fswatch.stop(vim.fn.expand('<afile>'), 0)]],
    "BufWritePost",   "*", [[call notify_register(vim.fn.expand('<afile>'))]],
    "FileWritePost",  "*", [[call notify_register(vim.fn.expand('<afile>'))]],
    "FileAppendPost", "*", [[call notify_register(vim.fn.expand('<afile>'))]],
 
    "BufFilePre",     "*", [[lua fswatch.stop(vim.fn.expand('<afile>'))]],
    "BufFilePost",    "*", [[call notify_register(vim.fn.expand('<afile>'))]]


  }
}

local function test_watcher()
    -- "BufRead"     ,   "*", [[lua fswatch.watch_file(vim.fn.expand('<afile>')) ]],
	vim.api.nvim_command("autocmd! BufRead * lua fswatch.watch_file(vim.fn.expand('<afile>'))")
end
-- test_watcher()
nvim_create_augroups(autocmds)

