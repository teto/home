-- the RESULT container of avante's sidebar
-- vim.wo.statusline = 'TOTO'
-- displayed in front of wrapped lines
vim.opt.showbreak = ''

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


-- local sidebar = require('avante').get()

-- vim.api.nvim_create_autocmd('WinEnter', {
--     group = sidebar.augroup,
--     buffer = sidebar.containers.result.bufnr,
--     callback = function()
--         vim.print('token count: ', sidebar.token_count)
--     end,
-- })
--

-- vim.wo.cursorline = false
vim.wo.foldcolumn = '3' -- auto

-- E5113: Lua chunk: [string "vim/_core/options"]:167: Invalid 'foldcolumn': expected a valid type, got Integer
-- stack traceback: [C]: in function 'nvim_set_option_value'

-- ╭─
-- ╰─
-- to test with "vim.wo.foldmarker = '╭ ,╰' "

-- vim.wo.foldmarker = '╭,╰'
-- vim.bo.marker = '╭'
-- ╰

-- vim.o.winbar = vim.b.token
