return {
    'kitty-scrollback.nvim',
    cmd = {
        'KittyScrollbackGenerateKittens',
        'KittyScrollbackCheckHealth',
        'KittyScrollbackGenerateCommandLineEditing',
    },
    event = { 'User KittyScrollbackLaunch' },
    after = function()
        require('kitty-scrollback').setup(
            -- global configuration
            {
                status_window = {
                    style_simple = true, -- user may not have Nerd Fonts installed

                    -- autoclose = true,
                },
            }
        )
    end,
}
