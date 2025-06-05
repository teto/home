local M = {}

-- content should ideally be a list of lines
-- but for now we accept only a string
M.copy = function(content)
    -- todo convert to
    vim.cmd("call provider#clipboard#Call('set', [ ['" .. content .. "'], 'v','\"'])")
end

-- TODO
M.get = function()
    vim.cmd("call provider#clipboard#Call('get', )")
end

--- @param fullpath copy the absolute path
M.copy_filename = function (fullpath)
   local filename = vim.fn.bufname('%') -- vim.fn.getreg('%')
   local fullpath = (button == 'r')
   if copy_fullpath then
	   filename = vim.fn.fnamemodify(filename, ':p')
   end
   print('To clipboard: ' .. filename)
   M.copy(filename)
end

return M
