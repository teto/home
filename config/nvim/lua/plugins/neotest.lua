-- https://github.com/nvim-neotest/neotest#usage
-- require("neotest").run.run()
require('neotest').setup({
    adapters = {
        require('neotest-busted'),
        -- require("neotest-plenary"),
        -- require("neotest-vim-test")({
        --   ignore_file_types = { "python", "vim", "lua" },
        -- }),
    },
})
