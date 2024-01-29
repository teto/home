
local lush = require('lush')
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
  -- bg => 16643811
  -- hsl("#c6c6c6")
  local newColor = hsl(hi.bg)

  vim.api.nvim_set_hl(0, 'Normal', {bg = newColor})
  vim.print(hi)
end


return M
