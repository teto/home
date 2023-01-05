-- To create your own lualine component:
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/component.lua
-- See this tuto as well https://github.com/nvim-lualine/lualine.nvim/discussions/486
local obsession_color  = function ()
  if vim.g.this_obsession then
    -- then we invert color
   -- return {fg = "green"}
	return "StatusLine"
  end
  return "StatusLineNC"
end


local M = {
 function () return '' end
 , color = obsession_color
  -- , color = obsession_color
 , type = "lua_expr"
 , on_click = function()
   vim.cmd([[Obsession]])
   -- force a redraw
   vim.cmd('redrawstatus')
 end
}

return M
