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

