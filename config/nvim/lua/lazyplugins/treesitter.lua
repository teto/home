return {
{
 'nvim-treesitter/nvim-treesitter'
}
-- vim.keymap.set("n", "your_keymap_here", function()
--     require("query-secretary").query_window_initiate()
-- end, {})
, {"ziontee113/query-secretary" ,
  config = function ()
require('query-secretary').setup({
    open_win_opts = {
        relative = "cursor",
        width = 50,
        height = 15,
    },
})
end
}
}
