-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local lspconfig = require('lspconfig')

-- local temp = vim.lsp.handlers['textDocument/formatting']
-- vim.lsp.handlers['textDocument/formatting'] = function(...)
--     vim.notify('Called formatting')
--     temp(...)
-- end
--
-- override defaults for all servers
-- done via autocmd now ?
-- lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
--  on_attach = attach_cb.on_attach,
-- })

-- lspconfig.bashls.setup({})

-- lspconfig.markdown_oxide.setup({})
-- lspconfig.remark_ls.setup({})

-- Note that there is config set in .luarc.json but it is ignored
-- https://github.com/LuaLS/lua-language-server/issues/2483
-- lspconfig.lua_ls.setup({
--     cmd = { 'lua-language-server' },
--     settings = {
--         Lua = {
--             runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
--             completion = { keywordSnippet = 'Disable' },
--             diagnostics = {
--                 enable = true,
--                 workspaceRate = 50, -- spare CPU
--                 globals = {
--                     -- nvim and its tests
--                     'vim',
--                     'describe',
--                     'it',
--                     'before_each',
--                     'after_each',
--                     'pending',
--                     'teardown',
--
--                     -- for uv
--                     'os_name',
--                     -- for luasnip
--                     's',
--                     't',
--                     'i',
--                     'fmt',
--                     'f', -- function node
--                     'c', -- for choice
--                     -- available in wireplumber
--                     'alsa_monitor',
--                     -- for yazi
--                     'ya',
--                     'ui',
--                     'cx',
--                     'Command',
--                 },
--                 -- Define variable names that will not be reported as an unused local by unused-local.
--                 unusedLocalExclude = { '_*' },
--
--                 disable = {
--                     'lowercase-global',
--                     'unused-function',
--                     -- these are buggy
--                     'duplicate-doc-field',
--                     'duplicate-set-field',
--                     --
--                     'missing-fields', -- to silence vim.uv.os_name warnings for instance
--                 },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files,
--                 -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
--                 -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
--                 maxPreload = 1000,
--                 preloadFileSize = 500,
--                 checkThirdParty = false,
--                 ignoreDir = {
--                     'config/wireshark',
--                     'config/mpv',
--                 },
--
--                 library = {
--                     -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--                     -- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
--                     -- ['/home/teto/neovim/neovim/runtime/lua'] = true,
--                     -- ['/home/teto/neovim/neovim/runtime/lua/vim/lsp'] = true,
--                 },
--             },
--             -- workspace = {
--             -- },
--             format = {
--                 enable = true,
--                 -- Put format options here
--                 -- NOTE: the value should be String!
--                 defaultConfig = {
--                     indent_style = 'space',
--                     indent_size = '2',
--                 },
--             },
--         },
--         hint = {
--             enable = true,
--         },
--     },
-- })

-- lspconfig.dhall_lsp_server.setup({})
-- lspconfig.dockerls.setup({})

-- see https://github.com/redhat-developer/yaml-language-server for doc
lspconfig.yamlls.setup({
    -- cmd = { 'yaml-language-server', '--stdio' },
    --   on_attach = lsp.on_attach,
    --   capabilities = lsp.capabilities,
    settings = {
        yaml = {
            -- customTags
            schemaStore = { enable = true },
            -- schemas = require('schemastore').yaml.schemas(),

            format = {
                enable = true,
                proseWrap = 'Preserve',
                printWidth = 120,
            },
        },
    },
    -- }
})

-- local pyrightCapabilities = vim.lsp.protocol.make_client_capabilities()
-- pyrightCapabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
--
-- -- you can configure pyright via a pyrightconfig.json too
-- -- https://github.com/microsoft/pyright/blob/cf1a5790d2105ac60dd3378a46725519d14b2844/docs/configuration.md
-- -- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-rule-defaults
-- lspconfig.pyright.setup({
--     -- cmd = {"pyright-langserver", "--stdio"};
--     -- filetypes = {"python"};
--     autostart = false, -- This is the important new option
--     flags = {
--         debounce_text_changes = 150,
--     },
--     capabilities = pyrightCapabilities,
--     root_dir = lspconfig.util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt'),
--     -- on_attach=attach_cb.on_attach,
--     settings = {
--         -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
--         -- https://microsoft.github.io/pyright/#/settings
--         python = {
--             analysis = {
--                 -- enum { "Error", "Warning", "Information", "Trace" }
--                 logLevel = 'Warning',
--                 --						autoSearchPaths= true;
--                 -- diagnosticMode = 'workspace';
--                 --
--                 useLibraryCodeForTypes = true,
--                 typeCheckingMode = 'basic', -- 'off', 'basic', 'strict'
--                 diagnosticSeverityOverrides = {
--                     reportUnusedVariable = false,
--                     reportUnusedFunction = false,
--                     reportUnusedClass = false,
--                     reportPrivateImportUsage = 'none',
--                     reportMissingImports = false,
--                 },
--                 disableOrganizeImports = true,
--                 reportConstantRedefinition = true,
--                 autoSearchPaths = true,
--
--                 diagnosticMode = 'openFilesOnly', -- or workspace
--                 extraPaths = {
--                     -- "pkgs/applications/editors/vim/plugins"
--                     -- "/home/teto/nixpkgs3/maintainers/scripts"
--                 },
--                 -- reportUnknownParameterType
--                 -- diagnosticSeverityOverrides = {
--                 --		reportUnusedImport = "warning";
--                 -- };
--             },
--         },
--         pyright = {
--             disableOrganizeImports = true,
--             reportUnusedVariable = false,
--         },
--     },
-- })

lspconfig.jsonls.setup({
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            -- see https://github.com/b0o/SchemaStore.nvim/issues/8 for info about
            validate = { enable = true },
        },
    },
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

-- lspconfig.gitlab_ci_ls.setup({})
