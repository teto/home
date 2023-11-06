return {

 -- {
 --  'boltlessengineer/smart-tab.nvim',
 --  opts = {
 --    -- default options:
 --    -- list of tree-sitter node types to filter
 --    skips = { "string_content" },
 --    -- default mapping, set `false` if you don't want automatic mapping
 --    mapping = "<tab>",
 --  },
 -- },
{
 -- just needed by too many plugins, grammars are installed via nix though
 'nvim-treesitter/nvim-treesitter'
}
-- vim.keymap.set("n", "your_keymap_here", function()
--     require("query-secretary").query_window_initiate()
-- end, {})
-- , {"ziontee113/query-secretary" ,
--   config = function ()
-- require('query-secretary').setup({
--     open_win_opts = {
--         relative = "cursor",
--         width = 50,
--         height = 15,
--     },
-- })
-- end
-- }
}
