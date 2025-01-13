-- lualine extension for gp.nvim


-- local config = require("gp.config")
-- local my_extension = { 
--   sections = {
--    lualine_z = {'mode'} 
--   }
--   ,
--   -- filetypes = {'lua'} 
--  }

-- return gp._state.chat_agent

local function location()
  -- local line = vim.fn.line('.')
  -- local col = vim.fn.charcol('.')
  -- return "GP"
  local has_gp, gp = pcall(require, 'gp')
  if has_gp then
	return gp._state.chat_agent
  else 
	return "gp.nvim unavailable"
  end
end

return location
