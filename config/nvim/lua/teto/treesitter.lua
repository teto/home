local available, config = pcall(require, 'nvim-treesitter.configs')
if not available then
    return
end

local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
ft_to_parser.http = 'http' -- the someft filetype will use the python parser and queries.
ft_to_parser.json = 'json' -- the someft filetype will use the python parser and queries.
ft_to_parser.httpResult = 'http'

config.config = config.setup({
    -- why is treesitter not using stdpath('data') ?!
    parser_install_dir = '/home/teto/parsers',
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {
            'rust',
            'bash',
            -- 'nix',
            'python',
            'http', -- while I am working on the parser !
            -- 'c',
            'lua', -- cos breaks
        }, -- list of language that will be disabled
    },
    incremental_selection = {
        enable = true,
        --         disable = { 'cpp', 'lua' },
        --         keymaps = {                       -- mappings for incremental selection (visual mappings)
        --           init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
        --           node_incremental = "grn",       -- increment to the upper named parent
        --           scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
        --           node_decremental = "grm",       -- decrement to the previous node
        --         }
    },
    --     refactor = {
    --       highlight_definitions = {
    --         enable = true
    --       },
    smart_rename = {
        enable = false,
        --         smart_rename = "grr"              -- mapping to rename reference under cursor
    },
    navigation = {
        enable = false,
        --         goto_definition = "gnd",          -- mapping to go to definition of symbol under cursor
        --         list_definitions = "gnD"          -- mapping to list all definitions in current file
        --       }
    },
    --     ensure_installed = {"c"}, -- one of 'all', 'language', or a list of languages

    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
    },
})
-- return config.config

-- mentioned here https://www.reddit.com/r/neovim/comments/wj8txv/very_slow_input_latency_for_haskell_when/
-- require('vim.treesitter.query').set_query('haskell', 'injections', '')
