local M = {}

-- external plugins to have some nice features
local has_completion, plug_completion = pcall(require, "completion")


local function default_mappings()
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'K', [[<cmd>lua vim.lsp.buf.hover()<cr>]], {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})
	-- vim.api.nvim_buf_set_keymap(0, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true})

	vim.keymap.set ('n', "K", vim.lsp.buf.hover, { buffer=true })
	vim.keymap.set ('n', "gd", vim.lsp.buf.definition,{ buffer=true })
	vim.keymap.set ('n', "gr", vim.lsp.buf.references,{ buffer=true })
	vim.keymap.set ('n', "gA", vim.lsp.buf.code_action, { buffer=true })
	vim.keymap.set ('n', "g0", vim.lsp.buf.document_symbol, { buffer=true })

-- nmap             <C-k>           <Cmd>lua vim.lsp.diagnostic.goto_prev {wrap = true }<cr>
-- nmap             <C-j>           <Cmd>lua vim.lsp.diagnostic.goto_next {wrap = true }<cr>

	vim.keymap.set('n', "[e", function () vim.diagnostic.goto_prev({wrap = true }) end, { buffer=true })
	vim.keymap.set('n', "]e", function () vim.diagnostic.goto_next({wrap = true }) end, { buffer=true })
	vim.keymap.set('n', "<c-k>", function () vim.diagnostic.goto_prev({wrap = true }) end, { buffer=true })
	vim.keymap.set('n', "<c-j>", function () vim.diagnostic.goto_next({wrap = true }) end, { buffer=true })
end

M.on_attach = function(client)

	if has_completion then
		plug_completion.on_attach(client)
	end

	default_mappings()

	-- vim.bo.omnifunc = vim.lsp.omnifunc
	vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

	require "lsp_signature".on_attach()  -- Note: add in lsp client on-attach
	-- require'virtualtypes'.on_attach()
-- " vim.lsp.buf.rename()
end

return M
