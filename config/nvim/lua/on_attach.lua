local M = {}

-- external plugins to have some nice features
local plug_diagnostic_enabled, plug_diagnostic = pcall(require, "diagnostic")
local plug_completion_enabled, plug_completion = pcall(require, "completion")


M.on_attach = function()
	if plug_diagnostic_enabled then
		plug_diagnostic.on_attach()
	end

	if plug_completion_enabled then
		plug_completion.on_attach()
	end
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
