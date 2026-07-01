 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#191724',
    base01 = '#26233a',
    base02 = '#2e2b47',
    base03 = '#656182',
    base04 = '#908caa',
    base05 = '#e0def4',
    base06 = '#e0def4',
    base07 = '#e0def4',
    base08 = '#eb6f92',
    base09 = '#31748f',
    base0A = '#9ccfd8',
    base0B = '#ebbcba',
    base0C = '#96d1e9',
    base0D = '#e99996',
    base0E = '#96dce9',
    base0F = '#a00833',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e0def4',          bg = '#191724' })
  hi('TelescopeBorder',         { fg = '#656182',             bg = '#191724' })
  hi('TelescopePromptNormal',   { fg = '#e0def4',          bg = '#191724' })
  hi('TelescopePromptBorder',   { fg = '#656182',             bg = '#191724' })
  hi('TelescopePromptPrefix',   { fg = '#ebbcba',             bg = '#191724' })
  hi('TelescopePromptCounter',  { fg = '#908caa',  bg = '#191724' })
  hi('TelescopePromptTitle',    { fg = '#191724',             bg = '#ebbcba' })
  hi('TelescopePreviewTitle',   { fg = '#191724',             bg = '#9ccfd8' })
  hi('TelescopeResultsTitle',   { fg = '#191724',             bg = '#31748f' })
  hi('TelescopeSelection',      { fg = '#e0def4',          bg = '#2e2b47' })
  hi('TelescopeSelectionCaret', { fg = '#ebbcba',             bg = '#2e2b47' })
  hi('TelescopeMatching',       { fg = '#ebbcba',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
