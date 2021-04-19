-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local lspconfig = require 'lspconfig'
-- local configs = require 'lspconfig/configs'
-- local lsp_status_enabled, lsp_status = pcall(require, 'lsp-status')
local notifs = require 'notifications'
-- local util = require'vim.lsp.util'
local api = vim.api

local has_lsputil, lsputil = pcall(require, "lsputil")

if has_lsputil then
-- if false then
	vim.lsp.callbacks['textDocument/codeAction'] = lsputil.codeActioncode_action_handler
	vim.lsp.callbacks['textDocument/references'] = lsputil.locationsreferences_handler
	vim.lsp.callbacks['textDocument/definition'] = lsputil.locationsdefinition_handler
	vim.lsp.callbacks['textDocument/declaration'] = lsputil.locationsdeclaration_handler
	vim.lsp.callbacks['textDocument/typeDefinition'] = lsputil.locationstypeDefinition_handler
	vim.lsp.callbacks['textDocument/implementation'] = lsputil.locationsimplementation_handler
	vim.lsp.callbacks['textDocument/documentSymbol'] = lsputil.symbolsdocument_handler
	vim.lsp.callbacks['workspace/symbol'] = lsputil.symbolsworkspace_handler

	--@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#window/showMessage
	-- copy/pasted
	vim.lsp.callbacks['window/showMessage'] = function(_, _, result, client_id)
		local message_type = result.type
		local message = result.message
		local client = vim.lsp.get_client_by_id(client_id)
		local client_name = client and client.name or string.format("id=%d", client_id)
		if not client then
			notifs.notify("LSP[", client_name, "] client has shut down after sending the message")
		end
		if message_type == vim.lsp.protocol.MessageType.Error then
			notifs.notify("LSP[", client_name, "] ", message)
		else
			local message_type_name = vim.lsp.protocol.MessageType[message_type]
			api.nvim_out_write(string.format("LSP[%s][%s] %s\n", client_name, message_type_name, message))
		end
		return result
	end

end

-- custom attach callback
local attach_cb = require 'on_attach'

-- override defaults for all servers
lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		on_attach=attach_cb.on_attach,

	})

-- explained at https://github.com/nvim-lua/diagnostic-nvim/issues/73
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- underline = true,
    underline = {
		false,
		severity_limit = "Warning",
	},
    virtual_text = {
		true,
		severity_limit = "Warning",
	},
    signs = {
      priority = 20
    },
    update_in_insert = false,
  }
)

-- lspconfig.lua_lsp.setup{}

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

lspconfig.dockerls.setup{}
lspconfig.yamlls.setup{}

-- you can configure pyright via a pyrightconfig.json too
-- https://github.com/microsoft/pyright/blob/cf1a5790d2105ac60dd3378a46725519d14b2844/docs/configuration.md
-- https://github.com/microsoft/pyright/blob/master/docs/configuration.md
lspconfig.pyright.setup{
	-- cmd = {"pyright-langserver", "--stdio"};
	-- filetypes = {"python"};
	autostart = false; -- This is the important new option
	root_dir = lspconfig.util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
	-- on_attach=attach_cb.on_attach,
	settings = {
		python = {
			analysis = {
	-- 			autoSearchPaths= true;
	-- 			diagnosticMode = 'workspace';
				useLibraryCodeForTypes = true;
				typeCheckingMode = 'off'; -- 'off', 'basic', 'strict'
				reportUnusedVariable = false;
				reportUnusedFunction = false;
				reportUnusedClass = false;
				disableOrganizeImports = true;
				reportConstantRedefinition = true;
				-- reportUnknownParameterType
				-- diagnosticSeverityOverrides = {
				-- 	reportUnusedImport = "warning";
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

lspconfig.hls.setup({
    cmd = {
		"haskell-language-server"
		-- "/home/teto/nixpkgs2/result/bin/haskell-language-server-wrapper"
		-- "/home/teto/.cabal/bin/haskell-language-server"
		, "--lsp"
	},
    filetypes = { "haskell", "lhaskell" },
    root_dir = lspconfig.util.root_pattern(
		"*.cabal"
		-- , "stack.yaml"
		, "cabal.project"
		-- , "package.yaml"
		, "hie.yaml"
	),

	-- on_attach=attach_cb.on_attach,
	-- message_level = vim.lsp.protocol.MessageType.Warning,
	-- init_options = {
	settings = {
		haskell = {
			completionSnippetsOn = true,
			formattingProvider = "stylish-haskell",
		-- "haskell.trace.server": "messages",
			logFile = "/tmp/nvim-hls.log",
		-- "codeLens.enable": true,
			hlintOn = false
		}
	},
	flags = {
		allow_incremental_sync = false;
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
        --   contentFormat = { "markdown", "plaintext" },
        --   dynamicRegistration = false
        -- },
        -- references = {
        --   dynamicRegistration = false
        -- },
        -- signatureHelp = {
        --   dynamicRegistration = false,
        --   signatureInformation = {
        --     documentationFormat = { "markdown", "plaintext" }
        --   }
        -- },
        -- synchronization = {
        --   didSave = true,
        --   dynamicRegistration = false,
        --   willSave = false,
        --   willSaveWaitUntil = false
        -- }
      }
    },
    cmd = { "rust-analyzer" },
    -- root_dir = root_pattern("Cargo.toml", "rust-project.json")
})

-- lspconfig.rnix.setup{}


-- | Texlab
-- lspconfig.texlab.setup({
--   name = 'texlab_fancy';
--   log_level = vim.lsp.protocol.MessageType.Log;
--   message_level = vim.lsp.protocol.MessageType.Log;
--   settings = {
--     latex = {
--       build = {
--         onSave = true;
--       }
--     }
--   }
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
--	-- 'build/compile_commands.json',
--	root_dir = lspconfig.util.root_pattern( '.git'),
--	-- mandated by lsp-status
--	init_options = {
--		-- clangdFileStatus = true
--	},
--	-- callbacks = lsp_status.extensions.clangd.setup()
})


-- https://github.com/MaskRay/ccls/wiki/Debugging
-- lspconfig.ccls.setup({
-- 	name = "ccls",
-- 	filetypes = { "c", "cpp", "objc", "objcpp" },
-- 	cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=1" },
-- 	log_level = vim.lsp.protocol.MessageType.Log;
-- 	root_dir = lspconfig.util.root_pattern(".git");
-- 	init_options = {
-- 		-- "compilationDatabaseDirectory": "/home/teto/mptcp/build",
-- 		clang = { excludeArgs = { "-m*", "-Wa*" } },
-- 		cache = { directory = "/tmp/ccls" }
-- 	},
-- 	on_attach = attach_cb.on_attach
-- })

function lsp_diagnostic_toggle_virtual_text()
  local virtual_text = vim.b.lsp_virtual_text_enabled
  virtual_text = not virtual_text
  vim.b.lsp_virtual_text_enabled = virtual_text
  vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = virtual_text})
end
