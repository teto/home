
function notify()
  local prompt_win, prompt_opts = popup.create('', popup_opts.prompt)
  local prompt_bufnr = a.nvim_win_get_buf(prompt_win)
  a.nvim_win_set_option(prompt_win, 'winhl', 'Normal:TelescopeNormal')
  a.nvim_win_set_option(prompt_win, 'winblend', self.window.winblend)
end

