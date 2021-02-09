local M = {}

-- external plugins to have some nice features
local has_completion, plug_completion = pcall(require, "completion")
local lspsaga = require '_lspsaga'
local has_lspsaga, lspsaga = pcall(require, 'lspsaga')
local k = require"astronauta.keymap"
local nnoremap = k.nnoremap

-- showLineDiagnostic is a wrapper around show_line_diagnostics
-- show_line_diagnostics calls open_floating_preview
-- local popup_bufnr, winnr = util.open_floating_preview(lines, 'plaintext')
-- seems like there is no way to pass options from show_line_diagnostics to open_floating_preview
-- the floating popup has "ownsyntax markdown"
function showLineDiagnostic ()
	local opts = {
		enable_popup = true;
		-- options of
		popup_opts = {

		};
	}
	-- return vim.lsp.diagnostic.show_line_diagnostics()
	-- vim.lsp.diagnostic.goto_prev {wrap = true }
	return require'lspsaga.diagnostic'.show_line_diagnostics()

end

-- attach
local function lspsaga_attach()
	nnoremap { "gd", vim.lsp.buf.definition, buffer = true }
	nnoremap { "gr", vim.lsp.buf.references, buffer=true }
	nnoremap { "gA", vim.lsp.buf.code_action, buffer=true }
	nnoremap { "g0", vim.lsp.buf.document_symbol, buffer=true }

	-- vim.api.nvim_set_keymap('n', '<C-j>', [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]], {noremap = true})
-- code action
-- nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
-- vnoremap <silent><leader>ca <cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>

-- if lspsaga
--
	nnoremap { "[e", require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev, buffer=true }
	nnoremap { "]e", require'lspsaga.diagnostic'.lsp_jump_diagnostic_next, buffer=true }
end


local function default_mappings()
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'K', [[<cmd>lua vim.lsp.buf.hover()<cr>]], {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true})

	nnoremap { "K", vim.lsp.buf.hover, buffer=true }
	nnoremap { "gd", vim.lsp.buf.definition, buffer=true }
	nnoremap { "gr", vim.lsp.buf.references, buffer=true }
	nnoremap { "gA", vim.lsp.buf.code_action, buffer=true }
	nnoremap { "g0", vim.lsp.buf.document_symbo, buffer=true }
end

M.on_attach = function(client)
	-- print("Attaching client")
	-- print(vim.inspect(client))
	-- vim.cmd("setlocal omnifunc=lsp#omnifunc")

	if has_completion then
		plug_completion.on_attach(client)
	end

	if has_lspsaga then
	   lspsaga_attach()
	end

-- " vim.lsp.buf.rename()
end

return M
