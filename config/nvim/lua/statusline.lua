
local function statusline_lsp()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local msgs = {}
  -- for _, msg in ipairs(buf_messages) do
  --   local name = aliases[msg.name] or msg.name
  --   local client_name = '[' .. name .. ']'
  --   local contents = ''
  --   if msg.progress then
  --     contents = msg.title
  --     if msg.message then
  --       contents = contents .. ' ' .. msg.message
  --     end

  --     if msg.percentage then
  --       contents = contents .. ' (' .. msg.percentage .. ')'
  --     end

  --     if msg.spinner then
  --       contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1] .. ' ' .. contents
  --     end
  --   elseif msg.status then
  --     contents = msg.content
  --     if msg.uri then
  --       local filename = vim.uri_to_fname(msg.uri)
  --       filename = vim.fn.fnamemodify(filename, ':~:.')
  --       local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
  --       if #filename > space then
  --         filename = vim.fn.pathshorten(filename)
  --       end

  --       contents = '(' .. filename .. ') ' .. contents
  --     end
  --   else
  --     contents = msg.content
  --   end

  --   table.insert(msgs, client_name .. ' ' .. contents)
  -- end

  return 'test'
end

local M = {

  status = statusline_lsp
}

return M
