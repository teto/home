local has_iron, iron = pcall(require, 'iron')

         -- function()
         --    local iron = require('iron.core')
         --    iron.setup({
         --        config = {
         --            -- If iron should expose `<plug>(...)` mappings for the plugins
         --            should_map_plug = false,
         --            -- Whether a repl should be discarded or not
         --            scratch_repl = true,
         --            -- Your repl definitions come here
         --            repl_definition = {
         --                sh = { command = { 'zsh' } },
         --                nix = { command = { 'nix', 'repl', '/home/teto/nixpkgs' } },
         --                -- copied from the nix wrapper :/
         --                lua = { command = 'lua' },
         --            },
         --            repl_open_cmd = require('iron.view').bottom(40),
         --            -- how the REPL window will be opened, the default is opening
         --            -- a float window of height 40 at the bottom.
         --        },
         --        -- If the highlight is on, you can change how it looks
         --        -- For the available options, check nvim_set_hl
         --        highlight = {
         --            italic = true,
         --        },
         --    })
        -- end,

iron.core.add_repl_definitions({
    python = {
        mycustom = {
            command = { 'mycmd' },
        },
    },
    clojure = {
        lein_connect = {
            command = { 'lein', 'repl', ':connect' },
        },
    },
})

iron.core.set_config({
    preferred = {
        python = 'ipython',
        clojure = 'lein',
    },
})
