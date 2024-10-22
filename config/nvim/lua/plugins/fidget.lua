require('fidget').setup({
    progress = {
        ignore_done_already = true, -- Ignore new tasks that are already complete
    },
    notification = {
        poll_rate = 20, -- How frequently to update and render notifications
        filter = vim.log.levels.INFO, -- Minimum notifications level
        override_vim_notify = false, -- Automatically override vim.notify() with Fidget
        -- How to configure notification groups when instantiated
        configs = {
            default = require('fidget.notification').default_config,
        },
        -- Options related to how notifications are rendered as text
        view = {
            stack_upwards = true, -- Display notification items from bottom to top
            icon_separator = ' ', -- Separator between group name and icon
            group_separator = '---', -- Separator between notification groups
            -- Highlight group used for group separator
            group_separator_hl = 'Comment',
        },
        -- Options related to the notification window and buffer
        window = {
            normal_hl = 'Comment', -- Base highlight group in the notification window
            winblend = 100, -- Background color opacity in the notification window
            border = 'none', -- Border around the notification window
            zindex = 45, -- Stacking priority of the notification window
            max_width = 400, -- Maximum width of the notification window
            max_height = 100, -- Maximum height of the notification window
            x_padding = 1, -- Padding from right edge of window boundary
            y_padding = 0, -- Padding from bottom edge of window boundary
            align = 'top', -- Whether to bottom-align the notification window
            relative = 'editor', -- What the notification window position is relative to
        },
    },
    -- Options related to logging
    logger = {
        level = vim.log.levels.WARN, -- Minimum logging level
        float_precision = 0.01, -- Limit the number of decimals displayed for floats
        -- Where Fidget writes its logs to
        path = string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache')),
    },
})
