-- Function to check diagnostics and set CursorLine color
local function check_diagnostics_and_set_cursorline()
  -- Get the count of diagnostics with error severity
  local has_error = vim.diagnostic.count(0, { severity = vim.diagnostic.severity.ERROR })[1]
  -- > 0

  vim.notify("Updating cursorline with errors ? ".. tostring(has_error))

  -- Change CursorLine color based on presence of errors
  if has_error then
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#FF0000' })  -- Red if error
  else
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#00FF00' })  -- Green otherwise
  end
end

-- Configure autocommand
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = check_diagnostics_and_set_cursorline,
})


