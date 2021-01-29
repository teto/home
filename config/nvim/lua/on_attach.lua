local M = {}

-- external plugins to have some nice features
local has_completion, plug_completion = pcall(require, "completion")


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

	if has_completion then
		plug_completion.on_attach(client)
	end

	-- vim.cmd("setlocal omnifunc=lsp#omnifunc")
	vim.api.nvim_buf_set_keymap(0, 'n', 'K', [[<cmd>lua vim.lsp.buf.hover()<cr>]], {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true})

-- nmap             <C-k>           <Cmd>lua vim.lsp.diagnostic.goto_prev {wrap = true }<cr>
-- nmap             <C-j>           <Cmd>lua vim.lsp.diagnostic.goto_next {wrap = true }<cr>

-- " nnoremap <buffer> <silent> <leader>ngd :call lsp#text_document_declaration()<CR>
-- nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
-- " todo add fallback on keyword/haskell use hoogle
-- nnoremap ,gi  <cmd>lua vim.lsp.buf.implementation()<CR>
-- nnoremap ,sh <cmd>lua vim.lsp.buf.signature_help()<CR>
-- nnoremap <silent> ,td <cmd>lua vim.lsp.buf.type_definition()<CR>
-- nnoremap <silent> ,af <cmd>lua vim.lsp.buf.formatting()<CR>
-- nnoremap <silent> ,arf <cmd>lua vim.lsp.buf.range_formatting()<CR>

-- " TODO let visual map work on range
-- nnoremap ,ga <cmd>lua vim.lsp.buf.code_action()<CR>

-- " nnoremap <silent> <leader>do :OpenDiagnostic<CR>
-- nnoremap <leader>dl <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

-- " vim.lsp.buf.rename()
end

return M
