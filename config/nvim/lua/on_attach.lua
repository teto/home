local M = {}

-- external plugins to have some nice features
local plug_completion_enabled, plug_completion = pcall(require, "completion")


  -- Set up autocommands for refreshing the statusline when LSP information changes
  -- vim.api.nvim_command('augroup lsp_aucmds')
  -- vim.api.nvim_command('  au! * <buffer>')
  -- if do_progress then
  --   vim.api.nvim_command('  au User LspDiagnosticsChanged redrawstatus!')
  --   vim.api.nvim_command('  au User LspMessageUpdate      redrawstatus!')
  --   vim.api.nvim_command('  au User LspStatusUpdate       redrawstatus!')
  -- end
  -- vim.api.nvim_command('augroup END')

M.on_attach = function(client)
	-- print("Attaching client")
	-- print(vim.inspect(client))

	if plug_completion_enabled then
		plug_completion.on_attach(client)
	end

	-- vim.cmd("setlocal omnifunc=lsp#omnifunc")
      vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})

	-- setup_progress(client)
	-- Register client for messages and set up buffer autocommands to update 
-- the statusline and the current function
end

return M
