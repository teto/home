
-- conflicts with iron.repl

require'snacks'.setup {

 image = {
  enabled = true;
 }
}
vim.keymap.set("n", "s", function() require'snacks'.scratch() end, { desc = "Toggle Scratch Buffer" })
