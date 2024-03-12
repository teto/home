
-- while testing/developing rest.nvim
-- vim.opt.runtimepath:prepend('/home/teto/rest.nvim')
-- vim.opt.runtimepath:prepend('/home/teto/tree-sitter-http')
-- lua require'plenary.reload'.reload_module('rest-nvim.request')
-- vim.opt.runtimepath:prepend('/home/teto/nvim-treesitter')

vim.keymap.set('n', '<f2>',
	"<cmd>lua require'plenary.reload'.reload_module('rest-nvim.request'); print(require'rest-nvim.request'.ts_get_requests())<cr>"
)

