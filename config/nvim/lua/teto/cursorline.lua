local function update_highlights()
    -- Query the group directly so linked theme highlights are resolved.
    -- A copied `link` would take precedence over our diagnostic background.
    local base = vim.api.nvim_get_hl(0, { name = 'CursorLine', link = false })
    for name, color in pairs({ DiagnosticCursorLineError = '#FF0000', DiagnosticCursorLineWarn = '#FFFF00' }) do
        local highlight = vim.deepcopy(base)
        highlight.bg = color
        vim.api.nvim_set_hl(0, name, highlight)
    end
end

-- CursorLine is global; select a diagnostic highlight separately in each window.
local saved_mappings = {}
local function update_cursorline()
    for win in pairs(saved_mappings) do
        if not vim.api.nvim_win_is_valid(win) then
            saved_mappings[win] = nil
        end
    end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local counts = vim.diagnostic.count(vim.api.nvim_win_get_buf(win))
        local highlight
        if (counts[vim.diagnostic.severity.ERROR] or 0) > 0 then
            highlight = 'DiagnosticCursorLineError'
        elseif (counts[vim.diagnostic.severity.WARN] or 0) > 0 then
            highlight = 'DiagnosticCursorLineWarn'
        end

        local mappings = {}
        for mapping in vim.wo[win].winhighlight:gmatch('[^,]+') do
            if mapping:match('^CursorLine:') then
                if mapping ~= 'CursorLine:DiagnosticCursorLineError'
                    and mapping ~= 'CursorLine:DiagnosticCursorLineWarn' then
                    saved_mappings[win] = mapping
                end
            else
                table.insert(mappings, mapping)
            end
        end
        if highlight then
            table.insert(mappings, 'CursorLine:' .. highlight)
        elseif saved_mappings[win] then
            table.insert(mappings, saved_mappings[win])
            saved_mappings[win] = nil
        end
        vim.wo[win].winhighlight = table.concat(mappings, ',')
    end
end

local group = vim.api.nvim_create_augroup('DiagnosticCursorLine', { clear = true })
vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter', 'WinEnter', 'VimEnter' }, {
    group = group,
    callback = update_cursorline,
})
vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
        update_highlights()
        update_cursorline()
    end,
})

update_highlights()
update_cursorline()
