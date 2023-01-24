return {
    'neovim/nvim-lspconfig', -- while fuzzing details out
    {
        'MrcJkb/haskell-tools.nvim',
        --  'mfussenegger/nvim-dap'
        --  'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
        -- ({
        --	 "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        --	 as = "lsp_lines",
        --	 config = function()

        --	   require("lsp_lines").register_lsp_virtual_lines()
        --	 end,
        -- })
        -- {
        --	"rcarriga/nvim-dap-ui"
        --	, requires = {"mfussenegger/nvim-dap"}
        -- }
        -- use 'nvim-telescope/telescope-dap.nvim'
        config = function()
            local ht = require('haskell-tools')
            ht.setup({
                tools = { -- haskell-tools options
                    codeLens = {
                        -- Whether to automatically display/refresh codeLenses
                        autoRefresh = true,
                    },
                    -- hoogle = {
                    --     -- 'auto': Choose a mode automatically, based on what is available.
                    --     -- 'telescope-local': Force use of a local installation.
                    --     -- 'telescope-web': The online version (depends on curl).
                    --     -- 'browser': Open hoogle search in the default browser.
                    --     mode = 'auto',
                    -- }
                    -- ,
                    repl = {
                        -- 'builtin': Use the simple builtin repl
                        -- 'toggleterm': Use akinsho/toggleterm.nvim
                        handler = 'builtin',
                        builtin = {
                            create_repl_window = function(view)
                                -- create_repl_split | create_repl_vsplit | create_repl_tabnew | create_repl_cur_win
                                return view.create_repl_split({ size = vim.o.lines / 3 })
                            end,
                        },
                    },
                },
                hls = { -- LSP client options
                    on_attach = function(client, bufnr)
                        local attach_cb = require('on_attach')
                        attach_cb.on_attach(client, bufnr)

                        -- haskell-language-server relies heavily on codeLenses,
                        -- so auto-refresh (see advanced configuration) is enabled by default
                        local opts = {}
                        vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
                        vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
                        -- vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
                        -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
                    end,
                    -- ...
                    settings = { -- haskell-language-server options
                        haskell = {
                            -- Setting this to true could have a performance impact on large mono repos.
                            checkProject = false,
                            checkParents = 'NeverCheck',
                            --		-- "haskell.trace.server": "messages",
                            logFile = '/tmp/nvim-hls.log',
                            --		-- "codeLens.enable": true,
                            completionSnippetsOn = true,
                            -- formattingProvider = 'ormolu',
                            formattingProvider = 'stylish-haskell',
                            plugin = {
                                refineImports = {
                                    codeActionsOn = true,
                                    codeLensOn = false,
                                },
                                hlint = {
                                    -- "config": {
                                    --	   "flags": []
                                    -- },
                                    diagnosticsOn = false,
                                    codeActionsOn = false,
                                },
                            },
                        },
                    },
                    --	settings = {
                    --	  haskell = {
                    --		completionSnippetsOn = true,
                    --		formattingProvider = "stylish-haskell",
                    --		-- "haskell.trace.server": "messages",
                    --		-- logFile = "/tmp/nvim-hls.log",
                    --		-- "codeLens.enable": true,
                    --	  -- hlintOn = false
                    --plugin= {
                    --	hlint = {
                    --  -- "config": {
                    --  --	   "flags": []
                    --  -- },
                    --	  diagnosticsOn= false,
                    --	  codeActionsOn= false
                    --	},
                    --  }
                    --		},
                    --	  },
                },
            })
        end,
    },
    { 
    url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function ()
     require("lsp_lines").setup()
     end
   },
   -- { 'fidget.nvim',
   --  config = function () 
   --   require"fidget".setup{}
   --  end
   -- }
}
