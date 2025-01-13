-- To create your own lualine component:
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/component.lua
-- See this tuto as well https://github.com/nvim-lualine/lualine.nvim/discussions/486
-- local obsession_color = function()
--     if vim.g.this_obsession then
--         -- then we invert color
--         -- return {fg = "green"}
--         return 'StatusLine'
--     end
--     return 'StatusLineNC'
-- end

-- local M = require('lualine.component'):extend()
--
-- function M:update_status(is_focused) 
--
--  self.status = "TOTO"
--  return "TOTO"
-- end

local function location()
  -- local line = vim.fn.line('.')
  -- local col = vim.fn.charcol('.')
  return "TOTO"
end

return location
