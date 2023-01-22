local a = vim.api
local popup = require('popup')
local uv = require('luv')

-- lua require('plenary.reload').reload_module('notifications')
local M = {}

-- self:get_window_options(vim.o.columns, line_count)
local popup_opts = {
    -- padding = { }; -- empty defaults to 1 in every direction
    line = 10,
    col = 30,
    pos = 'topleft',
    border = true,
    highlight = true,
    borderchars = { '|' },
    -- pos = "bottomleft";
    title = 'test title',
    wrap = true, -- the default
    -- highlight
    -- border =  { }; -- a list
    close = true,
    minheight = 3,
    minwidth = 20,
    maxwidth = 200,
    -- 	prompt = "test";
    -- 	-- results.minheight = 20;
    -- 	-- popup_opts.prompt.minheight = popup_opts.prompt.height
}

function M.warn(msg)
    M.notify(msg)
end

-- kinda replace lsp's err_message that is private
function M.notify(...)
    return M.notify_external(...)
    -- return M.notify_internal(...)
end

function M.notify_internal(msg)
    -- https://vimhelp.org/popup.txt.html#popup_create-arguments
    local prompt_win, prompt_opts = popup.create('content', popup_opts)
    local prompt_bufnr = a.nvim_win_get_buf(prompt_win)
    -- a.nvim_win_set_option(prompt_win, 'winhl', 'Normal:TelescopeNormal')
    -- self.window.winblend)
    -- a.nvim_win_set_option(prompt_win, 'winblend', 100)
end

-- https://github.com/phuhl/linux_notification_center
-- https://github.com/luvit/luv/blob/master/docs.md
function M.notify_external(msg, log_level, opts)
    vim.fn.jobstart({ 'notify-send', msg })
end

return M
