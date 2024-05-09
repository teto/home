-- vim.treesitter.language.register('http', 'http')
-- vim.treesitter.language.register('json', 'json')
-- vim.treesitter.language.register('httpResult', 'http')
-- local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
-- ft_to_parser.http = 'http' -- the someft filetype will use the python parser and queries.
-- ft_to_parser.json = 'json' -- the someft filetype will use the python parser and queries.
-- ft_to_parser.httpResult = 'http'

local available, ts_config = pcall(require, 'nvim-treesitter.configs')
if not available then
    return
end

-- generated
local nix_deps = require'generated-by-nix'

require"nvim-treesitter.install".compilers = {
  nix_deps.gcc_path
}

-- ts_config.config = ts_config.setup({
ts_config.setup({
    -- why is treesitter not using stdpath('data') ?!
    parser_install_dir = '/home/teto/parsers',
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {
            'rust',
            'bash',
            'nix',
            'org',
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
    }
    -- TSInstall lua xml http json graphql
    , ensure_installed = {
     -- rest.nvim grammars
     "lua", "xml", "http", "json", "graphql"
     -- for me
     , "c"
     , "query"

     , "org", "norg"


       }, -- one of 'all', 'language', or a list of languages

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
})


