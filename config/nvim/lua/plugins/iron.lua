-- iron.nvim repl configuration {{{

-- doc at https://github.com/Vigemus/iron.nvim/tree/master
local iron = require('iron.core')
local view = require('iron.view')
-- iron.setup({
--     -- Whether a repl should be discarded or not
--     scratch_repl = true,
--     config = {
--         -- If iron should expose `<plug>(...)` mappings for the plugins
--         -- should_map_plug = false,
--         -- -- Whether a repl should be discarded or not
--         -- scratch_repl = true,
--         -- Your repl definitions come here
--         repl_definition = {
--             sh = { command = { 'zsh' } },
--             nix = { command = { 'nix', 'repl', '/home/teto/nixpkgs' } },
--             -- copied from the nix wrapper :/
--             -- ${pkgs.luajit}/bin
--             lua = { command = 'lua' },
--             haskell = {
--                 command = function(meta)
--                     local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
--                     -- call `require` in case iron is set up before haskell-tools
--                     return require('haskell-tools').repl.mk_repl_cmd(file)
--                 end,
--             },
--         },
--         -- repl_open_cmd = require('iron.view').left(200),
--         repl_open_cmd = view.split.vertical.botright(0.4),
--         -- how the REPL window will be opened, the default is opening
--         -- a float window of height 40 at the bottom.
--     },
-- })

-- TODO iron-config ?
-- require('teto.iron')
-- Iron doesn't set keymaps by default anymore. Set them here
-- or use `should_map_plug = true` and map from you vim files
-- keymaps = {
--     send_motion = '<space>sc',
--     visual_send = '<space>sc',
--     send_file = '<space>sf',
--     send_line = '<space>sl',
--     send_mark = '<space>sm',
--     mark_motion = '<space>mc',
--     mark_visual = '<space>mc',
--     remove_mark = '<space>md',
--     cr = '<space>s<cr>',
--     interrupt = '<space>s<space>',
--     exit = '<space>sq',
--     clear = '<space>cl',
-- },

-- }}}

local nix_deps = require('generated-by-nix')
iron.setup({
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = { 'zsh' },
            },
            python = {
                command = { 'python3' }, -- or { "ipython", "--no-autoindent" }
                format = require('iron.fts.common').bracketed_paste_python,
            },
            lua = {
                -- lua_interpreter
                command = { nix_deps.lua_interpreter },
            },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.botright(40),
        -- view.bottom(40),
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sf',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>s<space>',
        exit = '<space>sq',
        -- clear = '<space>cl',
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
        italic = true,
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
