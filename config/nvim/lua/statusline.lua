
-- called by airline to disable
local function statusline_lsp()

  -- return 'test'
-- vim.g.indicator_errors = ''
-- vim.g.indicator_warnings = ''
-- vim.g.indicator_info = '🛈'
-- vim.g.indicator_hint = '❗'
-- vim.g.indicator_ok = ''
-- vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

  -- local base_status = "S"
  local status_symbol = '🇻'
  local indicator_ok = '✅'
	-- vim.g.indicator_errors = ''
	-- vim.g.indicator_warnings = ''
	-- vim.g.indicator_info = '🛈'
	-- vim.g.indicator_hint = '❗'
	-- vim.g.indicator_ok = '✅'

  -- can we ?
  if #vim.lsp.buf_get_clients() == 0 then
    return 'no LSP clients'
  end

  local msgs = {}
  local buf_messages = vim.lsp.util.get_progress_messages()

  for _, msg in ipairs(buf_messages) do
	  -- print("statusline ", vim.inspect(msg))
    local client_name = '[' .. msg.name .. ']'
    local contents = ''
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end
-- vim.trim(table.concat(status_parts, ' ') ..
  local base_status =  ' ' .. table.concat(msgs, ' ')
  local symbol = status_symbol
  -- .. ((some_diagnostics and only_hint) and '' or ' ')
  local current_function = vim.b.lsp_current_function
  if current_function and current_function ~= '' then
    symbol = symbol .. '(' .. current_function .. ') '
  end

  if base_status ~= '' then
    return symbol .. base_status .. ' '
  end

  return symbol .. indicator_ok .. ' '
  -- return 'test'
end

local M = {

  status = statusline_lsp
}

return M
