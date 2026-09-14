-- vim.wo.statusline = 'TOTO'
-- displayed in front of wrapped lines
vim.opt.showbreak = '↳ ' 

-- during testing
-- vim.o.laststatus = 2
-- see avante's self.containers.result =
-- sidebar_post_render
-- we have a User "AvanteInputSubmitted" event
-- react to  "AvanteViewBufferUpdated"
-- Interesting functions
-- - handle_submit
-- - update_content
-- - on_state_change

local sidebar = require('avante').get()

-- vim.api.nvim_create_autocmd('WinEnter', {
--     group = sidebar.augroup,
--     buffer = sidebar.containers.result.bufnr,
--     callback = function()
--         vim.print('token count: ', sidebar.token_count)
--     end,
-- })
--

-- vim.o.winbar = vim.b.token
