return {
 {'neovim/nvim-lspconfig' }, -- while fuzzing details out
 -- shows a lightbulb where a codeAction is available
 -- { 'kosayoda/nvim-lightbulb',
 -- 	config = function ()
 -- 		vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
 -- 	end
 --  },
 { 'lukas-reineke/lsp-format.nvim',
  config = function()
   require("lsp-format").setup {}
   -- lsp-format attaches itself on o
   vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Attach lsp-format on new client",
    callback = function(args)
     if not (args.data and args.data.client_id) then
      return
     end
     -- local client = vim.lsp.get_client_by_id(args.data.client_id)
     -- local bufnr = args.buf
     -- require("lsp-format").on_attach(client, bufnr)
    end
   })
  end
 },
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
 -- { 'MrcJkb/haskell-tools.nvim' , dev = true },
 { dir = '/home/teto/neovim/haskell-tools.nvim' },
 -- --config = function()
 -- -- local ht = require('haskell-tools')
 -- -- ht.setup({
 -- --  tools = { -- haskell-tools options

 -- --   codeLens = {
 -- --    -- Whether to automatically display/refresh codeLenses
 -- --    autoRefresh = true,
 -- --   },
 -- --   -- hoogle = {
 -- --   --     -- 'auto': Choose a mode automatically, based on what is available.
 -- --   --     -- 'telescope-local': Force use of a local installation.
 -- --   --     -- 'telescope-web': The online version (depends on curl).
 -- --   --     -- 'browser': Open hoogle search in the default browser.
 -- --   --     mode = 'auto',
 -- --   -- }
 -- --   -- ,
 -- --   repl = {
 -- --    -- 'builtin': Use the simple builtin repl
 -- --    -- 'toggleterm': Use akinsho/toggleterm.nvim
 -- --    handler = 'builtin',
 -- --    builtin = {
 -- --     create_repl_window = function(view)
 -- --      -- create_repl_split | create_repl_vsplit | create_repl_tabnew | create_repl_cur_win
 -- --      return view.create_repl_split({ size = vim.o.lines / 3 })
 -- --     end,
 -- --    },
 -- --   },
 -- --  },
 -- --  hls = { -- LSP client options
 -- --   on_attach = function(client, bufnr)
 -- --    local attach_cb = require('on_attach')
 -- --    attach_cb.on_attach(client, bufnr)

 -- --    -- haskell-language-server relies heavily on codeLenses,
 -- --    -- so auto-refresh (see advanced configuration) is enabled by default
 -- --    local opts = {}
 -- --    vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
 -- --    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
 -- --    -- vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
 -- --    -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
 -- --   end,
 -- --   -- ...
 -- --   -- replaces lspconfig.hls.setup
 -- --   -- README says: Do not call the nvim-lspconfig.hls setup or set up the lsp manually, as doing so may cause conflicts.
 -- --   default_settings = { -- haskell-language-server options
 -- --    haskell = {
 -- --     -- Setting this to true could have a performance impact on large mono repos.
 -- --     checkProject = false,
 -- --     checkParents = 'NeverCheck',
 -- --     --		-- "haskell.trace.server": "messages",
 -- --     logFile = '/tmp/nvim-hls.log',
 -- --     --		-- "codeLens.enable": true,
 -- --     completionSnippetsOn = true,
 -- --     -- formattingProvider = 'ormolu',
 -- --     formattingProvider = 'stylish-haskell',
 -- --     plugin = {
 -- --      refineImports = {
 -- --       codeActionsOn = true,
 -- --       codeLensOn = false,
 -- --      },
 -- --      hlint = {
 -- --       -- "config": {
 -- --       --	   "flags": []
 -- --       -- },
 -- --       diagnosticsOn = true,
 -- --       codeActionsOn = true,
 -- --      },
 -- --     },
 -- --    },
 -- --   },
 -- --   --	settings = {
 -- --   --	  haskell = {
 -- --   --		completionSnippetsOn = true,
 -- --   --		formattingProvider = "stylish-haskell",
 -- --   --		-- "haskell.trace.server": "messages",
 -- --   --		-- logFile = "/tmp/nvim-hls.log",
 -- --   --		-- "codeLens.enable": true,
 -- --   --	  -- hlintOn = false
 -- --   --plugin= {
 -- --   --	hlint = {
 -- --   --  -- "config": {
 -- --   --  --	   "flags": []
 -- --   --  -- },
 -- --   --	  diagnosticsOn= false,
 -- --   --	  codeActionsOn= false
 -- --   --	},
 -- --   --  }
 -- --   --		},
 -- --   --	  },
 -- --  },
 -- -- })
 -- --end,
 --},
 {
  url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
   require("lsp_lines").setup()
  end
 },
 -- { 'j-hui/fidget.nvim',
 --  config = function ()
 --   require"fidget".setup{
 --    align = {
 --      bottom = false,            -- align fidgets along bottom edge of buffer
 --      right = true,             -- align fidgets along right edge of buffer
 --    },
 --   }
 --  end
 -- }
}
