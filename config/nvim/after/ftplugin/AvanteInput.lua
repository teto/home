
local winbar_text = "TOTO"
-- , { win = winid })
vim.api.nvim_set_option_value("winbar", winbar_text, { scope = "local" })
