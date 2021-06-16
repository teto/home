local M = {}

-- external plugins to have some nice features
local has_completion, plug_completion = pcall(require, "completion")
-- local lspsaga = require '_lspsaga'
local has_lspsaga, lspsaga = pcall(require, 'lspsaga')
local k = require"astronauta.keymap"
local nnoremap = k.nnoremap


-- attach
local function lspsaga_attach()
	-- require'lspsaga.provider'.preview_definition()
	nnoremap { "gd", vim.lsp.buf.definition, buffer = true }
	nnoremap { "gD", require'lspsaga.provider'.preview_definition, buffer = true }
	nnoremap { "gr", vim.lsp.buf.references, buffer=true }
	nnoremap { "gA", require('lspsaga.codeaction').code_action, buffer=true }
	nnoremap { "g0", vim.lsp.buf.document_symbol, buffer=true }
	nnoremap { "gR", require'lspsaga.rename'.rename, buffer=true }

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
	nnoremap { "g0", vim.lsp.buf.document_symbol, buffer=true }

-- nmap             <C-k>           <Cmd>lua vim.lsp.diagnostic.goto_prev {wrap = true }<cr>
-- nmap             <C-j>           <Cmd>lua vim.lsp.diagnostic.goto_next {wrap = true }<cr>

	nnoremap { "[e", function () vim.lsp.diagnostic.goto_prev({wrap = true }) end, buffer=true }
	nnoremap { "]e", function () vim.lsp.diagnostic.goto_next({wrap = true }) end, buffer=true }
	nnoremap { "<c-k>", function () vim.lsp.diagnostic.goto_prev({wrap = true }) end, buffer=true }
	nnoremap { "<c-j>", function () vim.lsp.diagnostic.goto_next({wrap = true }) end, buffer=true }
end

M.on_attach = function(client)
	-- print("Attaching client")
	-- print(vim.inspect(client))
	-- vim.cmd("setlocal omnifunc=lsp#omnifunc")

	if has_completion then
		plug_completion.on_attach(client)
	end

	-- if has_lspsaga then
	if false then
	   lspsaga_attach()
	else
		default_mappings()
	end

	-- vim.bo.omnifunc = vim.lsp.omnifunc
	vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

-- " vim.lsp.buf.rename()
end

return M
