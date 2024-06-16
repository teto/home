-- iron.nvim repl configuration {{{

-- doc at https://github.com/Vigemus/iron.nvim/tree/master
local iron = require('iron.core')
local view = require('iron.view')
iron.setup({
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    config = {
        -- If iron should expose `<plug>(...)` mappings for the plugins
        -- should_map_plug = false,
        -- -- Whether a repl should be discarded or not
        -- scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            sh = { command = { 'zsh' } },
            nix = { command = { 'nix', 'repl', '/home/teto/nixpkgs' } },
            -- copied from the nix wrapper :/
            -- ${pkgs.luajit}/bin
            lua = { command = 'lua' },
            haskell = {
                command = function(meta)
                    local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
                    -- call `require` in case iron is set up before haskell-tools
                    return require('haskell-tools').repl.mk_repl_cmd(file)
                end,
            },
        },
        -- repl_open_cmd = require('iron.view').left(200),
        repl_open_cmd = view.split.vertical.botright(0.4),
        -- how the REPL window will be opened, the default is opening
        -- a float window of height 40 at the bottom.
    },
})
-- TODO iron-config ?
require('teto.iron')
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
