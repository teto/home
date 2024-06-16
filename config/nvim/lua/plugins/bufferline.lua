require('bufferline').setup({
    highlights = {},

    options = {
        mode = 'buffers',
        themable = true,
        -- buffer_close_icon = '',

        numbers = 'buffer_id', -- 'ordinal' ?
        indicator = {
            style = 'underline',
        },
        view = 'default',
        -- number_style = "superscript" | "",
        -- mappings = true,
        modified_icon = '●',
        close_icon = '',
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        color_icons = true, -- whether or not to add the filetype icon highlights
        -- left_trunc_marker = '',
        -- right_trunc_marker = '',
        -- max_name_length = 18,
        -- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
        -- tab_size = 18,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- -- can also be a table containing 2 custom separators
        -- -- [focused and unfocused]. eg: { '|', '|' }
        -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
        separator_style = 'thick',
        -- enforce_regular_tabs = false | true,
        always_show_bufferline = false,
        -- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
        -- -- add custom logic
        -- return buffer_a.modified > buffer_b.modified
        -- end
        hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
        },
    },
})
for i = 1, 9 do
    vim.keymap.set(
        'n',
        '<leader>' .. tostring(i),
        '<cmd>BufferLineGoToBuffer ' .. tostring(i) .. '<CR>',
        { silent = true }
    )
end
