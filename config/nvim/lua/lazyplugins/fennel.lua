return ({
    'rktjmp/hotpot.nvim',
    config = function()
        require('hotpot').setup({
            -- allows you to call `(require :fennel)`.
            -- recommended you enable this unless you have another fennel in your path.
            -- you can always call `(require :hotpot.fennel)`.
            provide_require_fennel = false,
            -- show fennel compiler results in when editing fennel files
            enable_hotpot_diagnostics = true,
            -- compiler options are passed directly to the fennel compiler, see
            -- fennels own documentation for details.
            compiler = {
                -- options passed to fennel.compile for modules, defaults to {}
                modules = {
                    -- not default but recommended, align lua lines with fnl source
                    -- for more debuggable errors, but less readable lua.
                    -- correlate = true
                },
                -- options passed to fennel.compile for macros, defaults as shown
                macros = {
                    env = '_COMPILER', -- MUST be set along with any other options
                },
            },
        })
    end,
})

