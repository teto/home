--     fg = tonumber('0xff0000'),
--     bg = tonumber('0x0032aa'),
--     try one of https://github.com/Firanel/lua-color

local lush = require('lush')
local bit = require'bit'
local hsl = lush.hsl -- We'll use hsl a lot so its nice to bind it separately
-- local v = require'lush.vivid.hsl.convert'
-- vim.api.nvim_set_hl(0, 'Normal', { fg = "#ffffff", bg = "#333333" })
-- lua print(vim.api.nvim_get_hl(0, { name = 'Normal' }))
-- nvim_get_hl_id_by_name({name})
local sea_gull  = hsl("#c6c6c6")

local M = {}

function M.make_darker()

  local hi = vim.api.nvim_get_hl(0, {name = 'Normal', create = false})
  vim.print(hi)
  -- bg => 3159111 guibg=#303447  
  -- hsl("#c6c6c6")
  -- one can instantiate the 
  local normal_bg_hex = "#"..tostring(bit.tohex(3159111))
  print(normal_bg_hex)
  local newColor = hsl(normal_bg_hex)

  vim.api.nvim_set_hl(0, 'Normal', {bg = newColor})
  vim.print(hi)
end


return M
