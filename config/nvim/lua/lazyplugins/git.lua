return {
    -- {
    --  "dlvhdr/gh-blame.nvim",
    --  -- dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    --  keys = {
    --    { "<leader>gg", "<cmd>GhBlameCurrentLine<cr>", desc = "GitHub Blame Current Line" },
    --  },
    -- },
    {
        'harrisoncramer/gitlab.nvim',
        enabled = false,
        build = function()
            require('gitlab.server').build(true)
        end, -- Builds the Go binary
        -- one can then run:
        -- require("gitlab").summary()
        -- require("gitlab").review()
        -- require("gitlab").pipeline()
        -- dependencies = {

        -- },
        config = function()
            require('gitlab').setup() -- Uses delta reviewer by default
        end,
    },
    -- {
    --  'lewis6991/gitsigns.nvim',
    --
    -- },
}
