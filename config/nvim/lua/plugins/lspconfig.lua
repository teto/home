-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
-- local api = vim.api

if not has_lspconfig then
    return
end

-- custom attach callback
-- local attach_cb = require('teto.on_attach')

local temp = vim.lsp.handlers['textDocument/formatting']
vim.lsp.handlers['textDocument/formatting'] = function(...)
    vim.notify('Called formatting')
    temp(...)
end

-- override defaults for all servers
-- done via autocmd now ?
-- lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
--  on_attach = attach_cb.on_attach,
-- })

lspconfig.bashls.setup({})

-- lspconfig.markdown_oxide.setup({})
-- lspconfig.remark_ls.setup({})
lspconfig.marksman.setup({})

-- Note that there is config set in .luarc.json but it is ignored
-- https://github.com/LuaLS/lua-language-server/issues/2483
lspconfig.lua_ls.setup({
    cmd = { 'lua-language-server' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
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
})

-- lspconfig.dhall_lsp_server.setup({})
lspconfig.dockerls.setup({})

--
lspconfig.gopls.setup({})

-- see https://github.com/redhat-developer/yaml-language-server for doc
-- lspconfig.yamlls.setup({
--     -- cmd = { 'yaml-language-server', '--stdio' },
--     --   on_attach = lsp.on_attach,
--     --   capabilities = lsp.capabilities,
--     settings = {
--         yaml = {
--             -- customTags
--             schemaStore = { enable = true },
--             -- schemas = require('schemastore').yaml.schemas(),
--
--             format = {
--                 enable = true,
--                 proseWrap = 'Preserve',
--                 printWidth = 120,
--             },
--         },
--     },
--     -- }
-- })

local pyrightCapabilities = vim.lsp.protocol.make_client_capabilities()
pyrightCapabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

-- you can configure pyright via a pyrightconfig.json too
-- https://github.com/microsoft/pyright/blob/cf1a5790d2105ac60dd3378a46725519d14b2844/docs/configuration.md
-- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-rule-defaults
lspconfig.pyright.setup({
    -- cmd = {"pyright-langserver", "--stdio"};
    -- filetypes = {"python"};
    autostart = false, -- This is the important new option
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = pyrightCapabilities,
    root_dir = lspconfig.util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt'),
    -- on_attach=attach_cb.on_attach,
    settings = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
        -- https://microsoft.github.io/pyright/#/settings
        python = {
            analysis = {
                -- enum { "Error", "Warning", "Information", "Trace" }
                logLevel = 'Warning',
                --						autoSearchPaths= true;
                -- diagnosticMode = 'workspace';
                --
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic', -- 'off', 'basic', 'strict'
                diagnosticSeverityOverrides = {
                    reportUnusedVariable = false,
                    reportUnusedFunction = false,
                    reportUnusedClass = false,
                    reportPrivateImportUsage = 'none',
                    reportMissingImports = false,
                },
                disableOrganizeImports = true,
                reportConstantRedefinition = true,
                autoSearchPaths = true,

                diagnosticMode = 'openFilesOnly', -- or workspace
                extraPaths = {
                    -- "pkgs/applications/editors/vim/plugins"
                    -- "/home/teto/nixpkgs3/maintainers/scripts"
                },
                -- reportUnknownParameterType
                -- diagnosticSeverityOverrides = {
                --		reportUnusedImport = "warning";
                -- };
            },
        },
        pyright = {
            disableOrganizeImports = true,
            reportUnusedVariable = false,
        },
    },
})

-- typescript
-- NOW HANDLED BY NIX IN INIT.lua (or not ?)
lspconfig.tsserver.setup({
    autostart = true,
    -- TODO should be generated/fixed in nix
    cmd = {
        'typescript-language-server',
        '--stdio',
        -- '--tsserver-path',
        -- found with 'nix build .#nodePackages.typescript'
        -- '/nix/store/34pzigggq36pk9sz9a95bz53qlqx1mpx-typescript-4.9.4/lib/node_modules/typescript/lib',
    },
    init_options = {
        preferences = {
            disableSuggestions = true,
        },
    },
})

lspconfig.jsonls.setup({
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            -- see https://github.com/b0o/SchemaStore.nvim/issues/8 for info about
            validate = { enable = true },
        },
    },
})
-- commented out because https://github.com/MrcJkb/haskell-tools.nvim recommends to disable it
--lspconfig.hls.setup({
--	-- cmd = {
--	-- 	  "haskell-language-server", "--lsp"
--		  -- , "--debug"
--		  -- , "-j2"	-- -j1 doesnt work, and more threads => crash
--	-- },
--	single_file_support = true,
--	filetypes = { "haskell", "lhaskell" },
--	capabilities = make_cmp_capabilities(),
--	root_dir = lspconfig.util.root_pattern(
--		"*.cabal"
--		-- , "stack.yaml"
--		-- , "cabal.project"
--		-- , "package.yaml"
--		, "hie.yaml"
--	),
--	-- message_level = vim.lsp.protocol.MessageType.Warning,
--	settings = {
--	  haskell = {
--		completionSnippetsOn = true,
--		formattingProvider = "stylish-haskell",
--		-- "haskell.trace.server": "messages",
--		-- logFile = "/tmp/nvim-hls.log",
--		-- "codeLens.enable": true,
--	  -- hlintOn = false
--		plugin= {
--			hlint = {
--		  -- "config": {
--		  --	   "flags": []
--		  -- },
--			  diagnosticsOn= false,
--			  codeActionsOn= false
--			},
--		  }
--		},
--	  },
--	  flags = {
--			 -- allow_incremental_sync = false;
--	  }
--})

lspconfig.rust_analyzer.setup({
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    -- commitCharactersSupport = false,
                    -- deprecatedSupport = false,
                    -- documentationFormat = { "markdown", "plaintext" },
                    -- preselectSupport = false,
                    snippetSupport = true,
                },
            },
            -- hover = {
            --	 contentFormat = { "markdown", "plaintext" },
            --	 dynamicRegistration = false
            -- },
            -- references = {
            --	 dynamicRegistration = false
            -- },
            -- signatureHelp = {
            --	 dynamicRegistration = false,
            --	 signatureInformation = {
            --	   documentationFormat = { "markdown", "plaintext" }
            --	 }
            -- },
            -- synchronization = {
            --	 didSave = true,
            --	 dynamicRegistration = false,
            --	 willSave = false,
            --	 willSaveWaitUntil = false
            -- }
        },
    },
    cmd = { 'rust-analyzer' },
    root_dir = lspconfig.util.root_pattern('Cargo.toml', 'rust-project.json'),
})

-- see https://github.com/oxalica/nil/blob/main/docs/configuration.md for config
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/42#issuecomment-1283825572
-- local caps = vim.tbl_deep_extend(
--  'force',
--  vim.lsp.protocol.make_client_capabilities(),
--  -- require('cmp_nvim_lsp').default_capabilities(),
--  -- File watching is disabled by default for neovim.
--  -- See: https://github.com/neovim/neovim/pull/22405
--  { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
-- );
--  capabilities = caps,

lspconfig.nil_ls.setup({
    init_options = {
        nix = {
            flake = {
                autoArchive = true,
                -- auto eval flake inputs for improved completion
                -- generates too many issues
                autoEvalInputs = false,
            },
        },
    },
    settings = {
        formatting = {
            command = { 'nixfmt' },
        },
        -- nix = {
        --  flake = {
        --   autoArchive = true,
        --   -- auto eval flake inputs for improved completion
        --   autoEvalInputs = true,
        --  }
        -- },
        diagnostic = {
            -- // Example: ["unused_binding", "unused_with"]
            ignored = { 'unused_binding', 'unused_with' },
            excludedFiles = {},
        },
    },
})

-- | Texlab
-- lspconfig.texlab.setup({
--	 name = 'texlab_fancy';
--	 log_level = vim.lsp.protocol.MessageType.Log;
--	 message_level = vim.lsp.protocol.MessageType.Log;
--	 settings = {
--	   latex = {
--		 build = {
--		   onSave = true;
--		 }
--	   }
--	 }
-- })

lspconfig.teal_ls.setup({})

-- set a specific type of .yaml
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = "*.gitlab-ci*.{yml,yaml}",
--   callback = function()
--     vim.bo.filetype = "yaml.gitlab"
--   end,
-- })
lspconfig.gitlab_ci_ls.setup{}

lspconfig.clangd.setup({
    --compile-commands-dir=build
    cmd = {
        'clangd',
        '--background-index',
        -- "--log=info", -- error/info/verbose
        -- "--pretty" -- pretty print json output
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    --		-- 'build/compile_commands.json',
    --		root_dir = lspconfig.util.root_pattern( '.git'),
})
