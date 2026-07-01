local M = {}

function M.setup()
    require('base16-colorscheme').setup({
        base00 = '#fffaf3',
        base01 = '#f2e9e1',
        base02 = '#ecdfd3',
        base03 = '#9e8e8b',
        base04 = '#797593',
        base05 = '#575279',
        base06 = '#575279',
        base07 = '#575279',
        base08 = '#b4637a',
        base09 = '#286983',
        base0A = '#56949f',
        base0B = '#d7827e',
        base0C = '#1b627e',
        base0D = '#7e1f1b',
        base0E = '#1b6f7e',
        base0F = '#e4cdd4',
    })

    local hi = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    hi('TelescopeNormal', { fg = '#575279', bg = '#fffaf3' })
    hi('TelescopeBorder', { fg = '#9e8e8b', bg = '#fffaf3' })
    hi('TelescopePromptNormal', { fg = '#575279', bg = '#fffaf3' })
    hi('TelescopePromptBorder', { fg = '#9e8e8b', bg = '#fffaf3' })
    hi('TelescopePromptPrefix', { fg = '#d7827e', bg = '#fffaf3' })
    hi('TelescopePromptCounter', { fg = '#797593', bg = '#fffaf3' })
    hi('TelescopePromptTitle', { fg = '#fffaf3', bg = '#d7827e' })
    hi('TelescopePreviewTitle', { fg = '#fffaf3', bg = '#56949f' })
    hi('TelescopeResultsTitle', { fg = '#fffaf3', bg = '#286983' })
    hi('TelescopeSelection', { fg = '#575279', bg = '#ecdfd3' })
    hi('TelescopeSelectionCaret', { fg = '#d7827e', bg = '#ecdfd3' })
    hi('TelescopeMatching', { fg = '#d7827e', bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
    'sigusr1',
    vim.schedule_wrap(function()
        package.loaded['matugen'] = nil
        require('matugen').setup()
    end)
)

return M
