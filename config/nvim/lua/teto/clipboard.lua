local M = {}

-- content should ideally be a list of lines
-- but for now we accept only a string
M.copy = function (content)
  -- todo convert to
  vim.cmd("call provider#clipboard#Call('set', [ ['".. content .."'], 'v','\"'])")
end

-- TODO
M.get = function ()
  vim.cmd("call provider#clipboard#Call('get', )")
end

return M
