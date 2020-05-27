local M = {}

-- external plugins to have some nice features
local plug_diagnostic_enabled, plug_diagnostic = pcall(require, "diagnostic")
local plug_completion_enabled, plug_completion = pcall(require, "completion")
local plug_lsp_status_enabled, lsp_status = pcall(require, "lsp-status")

local do_progress = false
local setup_progress = function(client)
  if do_progress then
    lsp_status.register_progress()

    -- Register the client for messages
    lsp_status.register_client(client.name)
  end

  -- Set up autocommands for refreshing the statusline when LSP information changes
  vim.api.nvim_command('augroup lsp_aucmds')
  vim.api.nvim_command('  au! * <buffer>')
  if do_progress then
    vim.api.nvim_command('  au User LspDiagnosticsChanged redrawstatus!')
    vim.api.nvim_command('  au User LspMessageUpdate      redrawstatus!')
    vim.api.nvim_command('  au User LspStatusUpdate       redrawstatus!')
  end
  vim.api.nvim_command('augroup END')

  -- If the client is a documentSymbolProvider, set up an autocommand to update the containing function
  if client.resolved_capabilities.document_symbol then
    vim.api.nvim_command('augroup lsp_aucmds')
    vim.api.nvim_command('  au CursorHold,BufEnter <buffer> lua require("lsp-status").update_current_function()')
    vim.api.nvim_command('augroup END')
  end
end

M.on_attach = function(client)
	if plug_diagnostic_enabled then
		plug_diagnostic.on_attach(client)
	end

	if plug_completion_enabled then
		plug_completion.on_attach(client)
	end

	-- Not sure if this is right
	-- vim.cmd("setlocal omnifunc=lsp#omnifunc")

	setup_progress(client)
	-- Register client for messages and set up buffer autocommands to update 
-- the statusline and the current function
end


-- use only if require diagnostic is not null ?
-- do

-- 		print("could not require diagnostic")
-- 		local method = 'textDocument/publishDiagnostics'
-- 		local default_callback = vim.lsp.callbacks[method]
-- 		vim.lsp.callbacks[method] = function(err, method, result, client_id)
-- 			default_callback(err, method, result, client_id)
-- 			if result and result.diagnostics then
-- 			for _, v in ipairs(result.diagnostics) do
-- 				v.uri = v.uri or result.uri
-- 			end
-- 			vim.lsp.util.set_loclist(result.diagnostics)
-- 			end
-- 		end
-- 	end

return M
