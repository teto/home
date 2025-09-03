-- https://luals.github.io/wiki/settings
local addons_folder = vim.fn.expand("$HOME").."/lua-ls-addons"
return {
    cmd = {
        'lua-language-server',
        -- '--loglevel=trace',
        '--logpath=/home/teto/lua_ls.log',
    },
    filetypes = {
        'lua',
    },
    -- single_file_support = true,
    root_markers = { '.luarc.json', '.luarc.jsonc' },

    -- disable lua-ls since it's too annoying
    root_dir = false,
    -- root_dir = function(fname)
    --   local root = util.root_pattern(unpack(root_files))(fname)
    --   if root and root ~= vim.env.HOME then
    --     return root
    --   end
    --   local root_lua = util.root_pattern 'lua/'(fname) or ''
    --   local root_git = vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or ''
    --   if root_lua == '' and root_git == '' then
    --     return
    --   end
    --   return #root_lua >= #root_git and root_lua or root_git
    -- end,

    settings = {
     -- copied from luassert luals addon ?
        -- "words" : [ "require[%s%(\"']+luassert[%)\"']" ]

        Lua = {
            runtime = {
                version = 'LuaJIT',
                -- path = vim.split(package.path, ';')
            },
            completion = {
              keywordSnippet = 'Disable'
             },
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
                    'assert',

					-- used by fzf-lua
					'FzfLua',
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
                    'undefined-field', -- Disable undefined-field diagnostic
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files,
                -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
                -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
                maxPreload = 100,
                preloadFileSize = 500,
                checkThirdParty = false,
                ignoreDir = {
                    'config/wireshark',
                    'config/mpv',
                },

                library = {
                  addons_folder .. "/busted/library",
                  -- "${3rd}/luassert/library",
                  addons_folder .. "/luassert/library",
                    -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    -- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    -- ['/home/teto/neovim/neovim/runtime/lua'] = true,
                    -- ['/home/teto/neovim/neovim/runtime/lua/vim/lsp'] = true,
                },
            },
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
