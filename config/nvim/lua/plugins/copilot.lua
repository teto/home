require('copilot').setup({
    panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
        },
        layout = {
            position = 'bottom', -- | top | left | right | bottom |
            ratio = 0.4,
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 15,
        trigger_on_accept = true,
        keymap = {
            accept = '<D-l>',
            accept_word = false,
            accept_line = false,
            next = '<D-]>',
            prev = '<D-[>',
            dismiss = '<C-]>',
            toggle_auto_trigger = false,
        },
    },

    -- next-edit-suggestion
    nes = {
        enabled = false, -- requires copilot-lsp as a dependency
        auto_trigger = false,
        keymap = {
            accept_and_goto = false,
            accept = false,
            dismiss = false,
        },
    },
    auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
    logger = {
        file = vim.fn.stdpath('log') .. '/copilot-lua.log',
        file_log_level = vim.log.levels.ON,
        print_log_level = vim.log.levels.DEBUG,
        trace_lsp = 'off', -- "off" | "debug" | "verbose"
        trace_lsp_progress = false,
        log_lsp_messages = false,
    },
    -- copilot_node_command = 'node', -- Node.js version must be > 22
    workspace_folders = {},
    -- copilot_model = "",
    disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
    root_dir = function()
        return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
    end,
    -- should_attach = function(buf_id, _)
    --   if not vim.bo[buf_id].buflisted then
    --     logger.debug("not attaching, buffer is not 'buflisted'")
    --     return false
    --   end
    --
    --   if vim.bo[buf_id].buftype ~= "" then
    --     logger.debug("not attaching, buffer 'buftype' is " .. vim.bo[buf_id].buftype)
    --     return false
    --   end
    --
    --   return true
    -- end,
    server = {
        type = 'nodejs', -- "nodejs" | "binary"
        custom_server_filepath = nil,
    },
    server_opts_overrides = {},
})
