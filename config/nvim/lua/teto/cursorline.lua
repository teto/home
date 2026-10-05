local saved_color = vim.api.nvim_get_hl(0, { name = 'CursorLine', link = false })

-- Reflect the worst diagnostic in the current buffer, even away from its line.
local function update_cursorline()
    local counts = vim.diagnostic.count(0)
    local color
    if (counts[vim.diagnostic.severity.ERROR] or 0) > 0 then
        color = '#FF0000'
    elseif (counts[vim.diagnostic.severity.WARN] or 0) > 0 then
        color = '#FFFF00'
    end

    local highlight = vim.deepcopy(saved_color)
    if color then
        highlight.bg = color
    end
    vim.api.nvim_set_hl(0, 'CursorLine', highlight)
end

local group = vim.api.nvim_create_augroup('DiagnosticCursorLine', { clear = true })
vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter', 'WinEnter', 'VimEnter' }, {
    group = group,
    callback = update_cursorline,
})
vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
        saved_color = vim.api.nvim_get_hl(0, { name = 'CursorLine', link = false })
        update_cursorline()
    end,
})

update_cursorline()
