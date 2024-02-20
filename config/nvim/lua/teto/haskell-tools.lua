local M = {}
M.generate_settings = function ()
 return {
 tools = {  -- haskell-tools options
  log = {
   level = vim.log.levels.DEBUG
  },

  codeLens = {
   -- Whether to automatically display/refresh codeLenses
   autoRefresh = true,
  },
  hoogle = {
      -- 'auto': Choose a mode automatically, based on what is available.
      -- 'telescope-local': Force use of a local installation.
      -- 'telescope-web': The online version (depends on curl).
      -- 'browser': Open hoogle search in the default browser.
      mode = 'auto',
  },
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

 -- HaskellLspClientOpts
 hls = {  -- LSP client options
  cmd = { 'haskell-language-server', '--lsp', '--logfile', "toto.log" },
  capabilities = vim.lsp.protocol.make_client_capabilities(),

  on_attach = function(client, bufnr)
   local attach_cb = require('teto.on_attach')
   attach_cb.on_attach(client, bufnr)

   --  -- haskell-language-server relies heavily on codeLenses,
   --  -- so auto-refresh (see advanced configuration) is enabled by default
   --  local map_opts = {}
   --  vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, map_opts)
   --  vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, map_opts)
   --  -- vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, map_opts)
   --  -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
  end,
  -- ...
  -- replaces lspconfig.hls.setup
  -- README says: Do not call the nvim-lspconfig.hls setup or set up the lsp manually, as doing so may cause conflicts.
  default_settings = {  -- haskell-language-server options
   haskell = {
    -- Setting this to true could have a performance impact on large mono repos.
    checkProject = false,
    checkParents = 'NeverCheck',
    maxCompletions = 30,  -- defaults to 40
    --		-- "haskell.trace.server": "messages",
    logFile = '/tmp/nvim-hls.log',
    --		-- "codeLens.enable": true,
    completionSnippetsOn = true,
    -- formattingProvider = 'ormolu',
    formattingProvider = 'stylish-haskell',
    plugin = {
     eval= {
      config = {
       diff = true,
      }
     },
     -- experimental
     rename = {  config = {diff = true } },
     importLens = {
      globalOn = true,
     },
     refineImports = {
      codeActionsOn = true,
      codeLensOn = false,
     },
     hlint = {
      globalOn = false,
      -- "config": {
      --	   "flags": []
      -- },
      -- diagnosticsOn = true,
      -- codeActionsOn = true,
     },
     tactics = {    -- wingman
      codeLensOn = false,
     },
     moduleName = {    -- fix module names
      globalOn = false,
     },
     stan = {
      globalOn = false
     }
    },
   },
  },
  -- https://haskell-language-server.readthedocs.io/en/latest/configuration.html
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

}
end

-- do toggle hlint / plugin
M.toggle_stan = function ()
  local settings = M.generate_settings()

  settings.hls.default_settings.haskell.plugin.stan.globalOn = not settings.hls.default_settings.haskell.plugin.stan.globalOn
  return settings
end

return M
