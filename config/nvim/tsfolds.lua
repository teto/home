-- playing with treesitter
cquery = [[
(comment) @comment
]]

local a = vim.api

-- highlight ids are set in
-- function TSHighlighter:on_line(_, _win, buf, line)
-- TODO should be fine to
-- self referring to the parser
a.nvim__buf_set_luahl(self.buf, {
    -- on_start=function(...) return self:on_start(...) end,
    -- on_window=function(...) return self:on_window(...) end,
    on_line = function(...)
        return self:on_line(...)
    end,
})

-- instead of TSHighlighter:set_query(query)
function TSHighlighter:set_query(query)
    if type(query) == 'string' then
        query = vim.treesitter.parse_query(self.parser.lang, query)
    end
    self.query = query

    self.id_map = {}
    for i, capture in ipairs(self.query.captures) do
        local hl = 0
        local firstc = string.sub(capture, 1, 1)
        local hl_group = self.hl_map[capture]
        if firstc ~= string.lower(firstc) then
            hl_group = vim.split(capture, '.', true)[1]
        end
        if hl_group then
            hl = a.nvim_get_hl_id_by_name(hl_group)
        end
        -- self.id_map[i] = hl
    end

    a.nvim__buf_redraw_range(self.buf, 0, a.nvim_buf_line_count(self.buf))
end

c_highlight_bufs = c_highlight_bufs or {}

for _, highlighter in pairs(c_highlight_bufs) do
    highlighter:set_query(cquery)
end

local TSHighlighter = vim.treesitter.TSHighlighter

function chl_check_buf()
    local bufnr = vim.api.nvim_get_current_buf()
    if c_highlight_bufs[bufnr] == nil then
        c_highlight_bufs[bufnr] = TSHighlighter.new(cquery)
    end
end

vim.api.nvim_command([[augroup TSCHL]])
vim.api.nvim_command([[au! FileType c lua chl_check_buf() ]])
vim.api.nvim_command([[augroup END ]])

if vim.api.nvim_buf_get_option(0, 'ft') == 'c' then
    chl_check_buf()
end
