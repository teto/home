-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
-- local nvim_lsp = require 'nvim_lsp'
-- local configs = require'nvim_lsp/configs'
-- local lsp_status = require'lsp-status'
local plug_telescope_enabled, telescope = pcall(require, "telescope.builtin")


local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

-- taken from https://github.com/neovim/neovim/pull/12368
function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end


vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

vim.g.should_show_diagnostics_in_statusline = true

-- require('lspfuzzy').setup {}

-- local lsp = require 'lsp'


-- to disable virtualtext check 
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()]]
-- vim.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()]]

-- TELESCOPE
--
-- Fuzzy find over git files in your directory
-- telescope.git_files()

-- -- Grep as you type (requires rg currently)
-- telescope.live_grep()

-- -- Use builtin LSP to request references under cursor. Fuzzy find over results.
-- require('telescope.builtin').lsp_references()

-- -- Convert currently quickfixlist to telescope
-- require('telescope.builtin').quickfix()
