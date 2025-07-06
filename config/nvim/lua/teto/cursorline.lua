

local saved_color

-- Function to check diagnostics and set CursorLine color
local function check_diagnostics_and_set_cursorline()
  -- Get the count of diagnostics with error severity
  local has_error = vim.diagnostic.count(0, { severity = vim.diagnostic.severity.ERROR })[1]
  -- > 0

  -- TODO log it instead
  -- vim.notify("Updating cursorline with errors ? ".. tostring(has_error))

  -- Change CursorLine color based on presence of errors
  if has_error then
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#FF0000' })  -- Red if error
  else
	-- should restore the original color
    -- vim.print("Restoring CursorLine color", saved_color)

    vim.api.nvim_set_hl(0, 'CursorLine', saved_color)  -- Green otherwise
  end
end

-- Configure autocommand
-- DiagnosticChanged instead ?
-- vim.api.nvim_create_autocmd('CursorHold', {
--   pattern = '*',
--   callback = check_diagnostics_and_set_cursorline,
-- })


-- vim.api.nvim_create_autocmd({'ColorScheme', 'VimEnter' }, {
--   pattern = '*',
--   callback = function ()
-- 	saved_color =  vim.api.nvim_get_hl(0, { name = 'CursorLine'})
-- 	-- vim.print("Saved color")
-- 	-- vim.print("Saved color", saved_color)
--   end,
-- })

