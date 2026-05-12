require('nvim-biscuits').setup({
    default_config = {
        -- max_length = 12,
        min_distance = 5,
        prefix_string = ' 📎 ',
    },
    max_file_size = '100kb',
    cursor_line_only = true,
    language_config = {
        html = {
            prefix_string = ' 🌐 ',
        },
        javascript = {
            prefix_string = ' ✨ ',
            max_length = 80,
        },
        python = {
            disabled = true,
        },
    },
})
