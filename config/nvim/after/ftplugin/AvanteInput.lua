-- reimplement Sidebar:render_header for the input provider such that we can display
-- the current provider/model
-- ideally this would autoupdate after https://github.com/neovim/neovim/pull/31280
-- but for now this might be good enough
-- should I create an autocmd ? api.nvim_create_autocmd("WinEnter", {

-- local winbar_text = "TOTO"
local api = vim.api
local Config = require('avante.config')
local Utils = require('avante.utils')
local Highlights = require('avante.highlights')

-- , { win = winid })

local win_id = vim.api.nvim_get_current_win()

-- print("winid", win_id)
-- function () winbar_text end
local result = render_header()
-- print("result:", result)
-- setting 'nil' crashes neovim
vim.api.nvim_set_option_value('winbar', result, {
    win = win_id,
})
