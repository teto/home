-- Pull in the wezterm API
local wezterm = require('wezterm')
local io = require('io')
local os = require('os')

local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- right click on `+` button
local launch_menu = {}
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.automatically_reload_config = false
config.color_scheme = 'AdventureTime'
config.enable_scroll_bar = true
config.enable_kitty_keyboard = true
-- config.tab_bar = {
--   hidden_when_only_one_tab = true;
-- }
--
-- config.hide_tab_bar_if_only_one_tab
config.scroll_to_bottom_on_input = true
config.term = 'wezterm'
-- config.scrollback_lines = 3500
config.enable_tab_bar = false
config.notification_handling = 'SuppressFromFocusedTab'
config.check_for_updates = false
config.default_cursor_style = 'BlinkingBar'
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 150,
}
config.colors = {
    visual_bell = '#202020',
}
config.hide_mouse_cursor_when_typing = false
config.disable_default_mouse_bindings = false
config.disable_default_quick_select_patterns = true

-- You can combine modifiers using the | symbol (eg: "CMD|CTRL").
-- https://wezfurlong.org/wezterm/config/keys.html#configuring-key-assignments
config.keys = {
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
    { key = 'RightArrow', mods = 'SHIFT', action = wezterm.action({ EmitEvent = 'trigger-vim-with-scrollback' }) },
    {
        key = 'Enter',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SpawnCommandInNewWindow({
            -- args = { 'top' },
        }),
    },
}
config.mouse_bindings = {
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor('SemanticZone'),
        mods = 'NONE',
    },
}

-- https://wezfurlong.org/wezterm/config/lua/wezterm/on.html#custom-events
wezterm.on('trigger-vim-with-scrollback', function(window, pane)
    -- Retrieve the current viewport's text.
    -- Pass an optional number of lines (eg: 2000) to retrieve
    -- that number of lines starting from the bottom of the viewport
    local scrollback = pane:get_lines_as_text()

    -- Create a temporary file to pass to vim
    local name = os.tmpname()
    local f = io.open(name, 'w+')
    f:write(scrollback)
    f:flush()
    f:close()

    -- Open a new window running vim and tell it to open the file
    window:perform_action(
        wezterm.action({ SpawnCommandInNewWindow = {
            args = { 'vim', name },
        } }),
        pane
    )

    -- wait "enough" time for vim to read the file before we remove it.
    -- The window creation and process spawn are asynchronous
    -- wrt. running this script and are not awaitable, so we just pick
    -- a number.
    wezterm.sleep_ms(1000)
    os.remove(name)
end)

-- TODO
-- config.tiling_desktop_environments
return config
