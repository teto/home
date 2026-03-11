-- see https://github.com/mikesmithgh/kitty-scrollback.nvim#-filetypes
-- if you want to create autocommands
require('kitty-scrollback').setup(
    -- global configuration
    {
        status_window = {
            style_simple = true, -- user may not have Nerd Fonts installed

            -- autoclose = true,
        },
    }
)
