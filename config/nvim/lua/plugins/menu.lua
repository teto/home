
-- require("menu").open(options,  { mouse = true, border = false }) 

vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {})
