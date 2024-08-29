-- treesitter testing playground
local ts = vim.treesitter

local query = [[
    (request @request_lists)
]]

local parser_name = 'http'
local parsed_query = ts.parse_query(parser_name, query)

local function print_node(title, node)
    print(string.format("%s: type '%s' isNamed '%s'", title, node:type(), node:named()))
end

local M = {}
M.test_get_node = function()
    local bufnr = 0
    local start_node = ts.get_node()
    local parser = ts.get_parser(bufnr, parser_name)
    local root = parser:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    print_node('Node at cursor', start_node)
    print('sexpr: ' .. start_node:sexpr())

    for id, node in parsed_query:iter_captures(start_node, bufnr, start_row, end_row) do
        local name = parsed_query.captures[id] -- name of the capture in the query
        print('- capture name: ' .. name)
        print_node(string.format('- capture node id(%s)', id), node)
    end
end

-- vim.api.nvim_set_keymap('n', '<leader><Space>', ':lua test_get_node()<CR>', { noremap = true, silent = false })
return M
