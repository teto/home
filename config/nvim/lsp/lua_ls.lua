return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                -- path = vim.split(package.path, ';')
            },
            completion = { keywordSnippet = 'Disable' },
            diagnostics = {
                enable = true,
                workspaceRate = 50, -- spare CPU
                globals = {
                    -- nvim and its tests
                    'vim',
                    'describe',
                    'it',
                    'before_each',
                    'after_each',
                    'pending',
                    'teardown',

                    -- for uv
                    'os_name',
                    -- for luasnip
                    's',
                    't',
                    'i',
                    'fmt',
                    'f', -- function node
                    'c', -- for choice
                    -- available in wireplumber
                    'alsa_monitor',
                    -- for yazi
                    'ya',
                    'ui',
                    'cx',
                    'Command',
                },
                -- Define variable names that will not be reported as an unused local by unused-local.
                unusedLocalExclude = { '_*' },

                disable = {
                    'lowercase-global',
                    'unused-function',
                    -- these are buggy
                    'duplicate-doc-field',
                    'duplicate-set-field',
                    --
                    'missing-fields', -- to silence vim.uv.os_name warnings for instance
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files,
                -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
                -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
                maxPreload = 1000,
                preloadFileSize = 500,
                checkThirdParty = false,
                ignoreDir = {
                    'config/wireshark',
                    'config/mpv',
                },

                library = {
                    -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    -- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    -- ['/home/teto/neovim/neovim/runtime/lua'] = true,
                    -- ['/home/teto/neovim/neovim/runtime/lua/vim/lsp'] = true,
                },
            },
            -- workspace = {
            -- },
            format = {
                enable = true,
                -- Put format options here
                -- NOTE: the value should be String!
                defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2',
                },
            },
        },
        hint = {
            enable = true,
        },
    },
}
