-- reimplement Sidebar:render_header for the input provider such that we can display
-- the current provider/model
-- ideally this would autoupdate after https://github.com/neovim/neovim/pull/31280
-- but for now this might be good enough
-- should I create an autocmd ? api.nvim_create_autocmd("WinEnter", {

-- local winbar_text = "TOTO"
local api = vim.api
local Config = require('avante.config')
local Utils = require('avante.utils')
local Highlights = require('avante.highlights')

-- , { win = winid })

local win_id = vim.api.nvim_get_current_win()

-- -- taken Sidebar:render_header
local render_header = function()
    -- if not bufnr or not api.nvim_buf_is_valid(bufnr) then return end

    local function format_segment(text, highlight)
        return '%#' .. highlight .. '#' .. text
    end

    -- if Config.windows.sidebar_header.rounded then
    --   header_text = format_segment(Utils.icon("", "『"), reverse_hl)
    --     .. format_segment(header_text, hl)
    --     .. format_segment(Utils.icon("", "』"), reverse_hl)
    -- else
    --   header_text = format_segment(" " .. header_text .. " ", hl)
    -- end
    local header_text = string.format(
        '%s%s (%s)',
        Utils.icon('󱜸 '),
        'Ask' or 'Chat with',
        Config.provider
        -- Config.mappings.sidebar.switch_windows
    )

    local winbar_text
    -- if Config.windows.sidebar_header.align == "left" then
    --   winbar_text = header_text .. "%=" .. format_segment("", Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
    -- elseif Config.windows.sidebar_header.align == "center" then
    winbar_text = format_segment('%=', Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
        .. header_text
        .. format_segment('%=', Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR)
    -- elseif Config.windows.sidebar_header.align == "right" then
    --   winbar_text = format_segment("%=", Highlights.AVANTE_SIDEBAR_WIN_HORIZONTAL_SEPARATOR) .. header_text
    -- end

    -- print(winbar_text)
    -- winbar_text = "tOTO"
    return winbar_text
    --  api.nvim_set_option_value("winbar", winbar_text, {
    -- win = winid
    --  })
end

-- print("winid", win_id)
-- function () winbar_text end
local result = render_header()
-- print("result:", result)
-- setting 'nil' crashes neovim
vim.api.nvim_set_option_value('winbar', result, {
    win = win_id,
})
