-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local lspconfig = require 'lspconfig'
-- local api = vim.api

-- custom attach callback
local attach_cb = require 'on_attach'

local temp = vim.lsp.handlers["textDocument/formatting"]
vim.lsp.handlers["textDocument/formatting"] = function(...)

		vim.notify("Called formatting")
		temp(...)
end
-- override defaults for all servers
lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
			on_attach=attach_cb.on_attach,

	}
)

-- explained at https://github.com/nvim-lua/diagnostic-nvim/issues/73
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--	 vim.lsp.diagnostic.on_publish_diagnostics, {
--		-- underline = true,
--	   underline = {
--				false,
--				severity_limit = "Warning",
--		},
--	   virtual_text = {
--				true,
--				severity_limit = "Warning",
--		},
--	   signs = {
--		 priority = 20
--	   },
--	   update_in_insert = false,
--	 }
-- )

lspconfig.bashls.setup{ }

lspconfig.sumneko_lua.setup{
  cmd = {"lua-language-server"};
  settings = {
		Lua = {
				runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
				completion = { keywordSnippet = "Disable", },
				diagnostics = {
						enable = true,
						globals = {
								"vim", "describe", "it", "before_each", "after_each", "pending"
								, "teardown"
						},
						disable = { "lowercase-global", "unused-function"}
				},
				workspace = {
						library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						}
				}
		}
  }
}

lspconfig.dhall_lsp_server.setup{}
lspconfig.dockerls.setup{}
lspconfig.yamlls.setup{}

-- you can configure pyright via a pyrightconfig.json too
-- https://github.com/microsoft/pyright/blob/cf1a5790d2105ac60dd3378a46725519d14b2844/docs/configuration.md
-- https://github.com/microsoft/pyright/blob/master/docs/configuration.md
lspconfig.pyright.setup{
	-- cmd = {"pyright-langserver", "--stdio"};
	-- filetypes = {"python"};
	-- autostart = false; -- This is the important new option
	root_dir = lspconfig.util.root_pattern(".git", "setup.py",	"setup.cfg", "pyproject.toml", "requirements.txt");
	-- on_attach=attach_cb.on_attach,
	settings = {
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
		python = {
			analysis = {
				-- enum { "Error", "Warning", "Information", "Trace" }
				logLevel = "Warning";
--						autoSearchPaths= true;
			-- diagnosticMode = 'workspace';
--
			useLibraryCodeForTypes = true;
			typeCheckingMode = 'basic'; -- 'off', 'basic', 'strict'
			reportUnusedVariable = false;
			reportUnusedFunction = false;
			reportUnusedClass = false;
			disableOrganizeImports = true;
			reportConstantRedefinition = true;
			-- reportUnknownParameterType
			-- diagnosticSeverityOverrides = {
			--		reportUnusedImport = "warning";
			-- };
			};
		};
		pyright = {
			disableOrganizeImports = true;
			reportUnusedVariable = false;
		};
	};
}

-- typescript
lspconfig.tsserver.setup({ })

local function make_cmp_capabilities()
  local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_lsp then
	return cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
  end
  return vim.lsp.protocol.make_client_capabilities()
end

lspconfig.hls.setup({
	cmd = {
		  "haskell-language-server", "--lsp"
		  -- , "--debug"
		  -- , "-j2"	-- -j1 doesnt work, and more threads => crash
	},
	single_file_support = true,
	filetypes = { "haskell", "lhaskell" },
	capabilities = make_cmp_capabilities(),
	root_dir = lspconfig.util.root_pattern(
		"*.cabal"
		-- , "stack.yaml"
		-- , "cabal.project"
		-- , "package.yaml"
		, "hie.yaml"
	),
	-- message_level = vim.lsp.protocol.MessageType.Warning,
	settings = {
	  haskell = {
		completionSnippetsOn = true,
		formattingProvider = "stylish-haskell",
		-- "haskell.trace.server": "messages",
		-- logFile = "/tmp/nvim-hls.log",
		-- "codeLens.enable": true,
	  -- hlintOn = false
		plugin= {
			hlint = {
		  -- "config": {
		  --	   "flags": []
		  -- },
			  diagnosticsOn= false,
			  codeActionsOn= false
			},
		  }
		},
	  },
	  flags = {
			  -- allow_incremental_sync = false;
	  }
})


lspconfig.rust_analyzer.setup({
	capabilities = {
	  textDocument = {
		completion = {
		  completionItem = {
			-- commitCharactersSupport = false,
			-- deprecatedSupport = false,
			-- documentationFormat = { "markdown", "plaintext" },
			-- preselectSupport = false,
			snippetSupport = true
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
	  }
	},
	cmd = { "rust-analyzer" },
	-- root_dir = root_pattern("Cargo.toml", "rust-project.json")
})

lspconfig.rnix.setup{}


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

lspconfig.clangd.setup({
		--compile-commands-dir=build
	cmd = {
				"clangd", "--background-index",
				-- "--log=info", -- error/info/verbose
				-- "--pretty" -- pretty print json output
		};
		filetypes = { "c", "cpp", "objc", "objcpp" },
		-- log_level = vim.lsp.protocol.MessageType.Debug;
		-- on_attach=attach_cb.on_attach,
--		-- 'build/compile_commands.json',
--		root_dir = lspconfig.util.root_pattern( '.git'),
--		-- mandated by lsp-status
--		init_options = {
--				-- clangdFileStatus = true
--		},
--		-- callbacks = lsp_status.extensions.clangd.setup()
})


-- https://github.com/MaskRay/ccls/wiki/Debugging
-- lspconfig.ccls.setup({
--		name = "ccls",
--		filetypes = { "c", "cpp", "objc", "objcpp" },
--		cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=1" },
--		log_level = vim.lsp.protocol.MessageType.Log;
--		root_dir = lspconfig.util.root_pattern(".git");
--		init_options = {
--				-- "compilationDatabaseDirectory": "/home/teto/mptcp/build",
--				clang = { excludeArgs = { "-m*", "-Wa*" } },
--				cache = { directory = "/tmp/ccls" }
--		},
--		on_attach = attach_cb.on_attach
-- })

function lsp_diagnostic_toggle_virtual_text()
  local virtual_text = vim.b.lsp_virtual_text_enabled
  virtual_text = not virtual_text
  vim.b.lsp_virtual_text_enabled = virtual_text
  vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = virtual_text})
end
