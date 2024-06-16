local ls = require('luasnip')

-- see also :h haskell-snippets
-- needs a treesitter grammar
local haskell_snippets = require('haskell-snippets').all
ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
