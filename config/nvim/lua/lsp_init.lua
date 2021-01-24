-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'
-- local lsp_status_enabled, lsp_status = pcall(require, 'lsp-status')
local notifs = require 'notifications'
-- local util = require'vim.lsp.util'
local api = vim.api

local plug_lsputil_enabled, lsputil = pcall(require, "lsputil")

-- if plug_lsputil_enabled then
if false then
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

-- if lsp_status_enabled then
-- 	-- completion_customize_lsp_label as used in completion-nvim
-- 	lsp_status.config {
-- 		-- kind_labels = vim.g.completion_customize_lsp_label
-- 		indicator_errors = "×",
-- 		indicator_warnings = "!",
-- 		indicator_info = "i",
-- 		indicator_hint = "›",
-- 		status_symbol = "",
-- 	}


-- 	-- this generates an error
-- 	-- to override all defaults
-- 	--   { log_level = lsp.protocol.MessageType.Warning.Error }

-- 	lspconfig.util.default_config.capabilities = vim.tbl_extend(
-- 	"keep",
-- 	lspconfig.util.default_config.capabilities or {},
-- 	-- enable 'progress' support in lsp servers
-- 	lsp_status.capabilities
-- 	)

-- end


-- explained at https://github.com/nvim-lua/diagnostic-nvim/issues/73
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = {
      priority = 20
    },
    update_in_insert = false,
  }
)

-- vim.lsp.util.show_current_line_diagnostics()
-- Check if it's already defined for when I reload this file.
if not configs.lua_lsp then
configs.lua_lsp = {
	default_config = {
	cmd = {'lua-lsp'};
	filetypes = {'lua'};
	root_dir = function(fname)
		return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
	end;
	-- todo wrap it with nlua: require('nlua.lsp.nvim').
	on_attach=attach_cb.on_attach,
	log_level = vim.lsp.protocol.MessageType.Warning;
	settings = {};
	};
}
end

-- lspconfig.lua_lsp.setup{}

lspconfig.sumneko_lua.setup{
  cmd = {"lua-language-server"};
  settings = {
	Lua = {
		runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
		completion = { keywordSnippet = "Disable", },
		diagnostics = {
			enable = true,
			globals = { "vim", "describe", "it", "before_each", "after_each" },
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

-- configs.pyright = {
-- default_config = {
-- 	cmd = {"pyright-langserver", "--stdio"};
-- 	filetypes = {"python"};
-- 	root_dir = lspconfig.util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
-- 	settings = {
-- 	analysis = { autoSearchPaths= true; };
-- 	pyright = { useLibraryCodeForTypes = true; };
-- 	};
-- 	-- The following before_init function can be removed once https://github.com/neovim/neovim/pull/12638 is merged
-- 	before_init = function(initialize_params)
-- 	initialize_params['workspaceFolders'] = {{
-- 		name = 'workspace',
-- 		uri = initialize_params['rootUri']
-- 	}}
-- 	end
-- 	};
-- }


-- you can configure pyright via a pyrightconfig.json too
-- https://github.com/microsoft/pyright/blob/cf1a5790d2105ac60dd3378a46725519d14b2844/docs/configuration.md
lspconfig.pyright.setup{
	cmd = {"pyright-langserver", "--stdio"};
	filetypes = {"python"};
	root_dir = lspconfig.util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
	-- settings = {
	-- 	python = {
	-- 		analysis = {
	-- 			autoSearchPaths= true;
	-- 			diagnosticMode = 'workspace';
	-- 			typeCheckingMode = 'strict';
	-- 		};
	-- 	};
	-- 	pyright = {
	-- 		useLibraryCodeForTypes = true;
	-- 		disableOrganizeImports = true;
	-- 	};
	-- };
}

lspconfig.hls.setup({
    cmd = { "haskell-language-server", "--lsp" },
    filetypes = { "haskell", "lhaskell" },
    root_dir = lspconfig.util.root_pattern(
		"*.cabal", "stack.yaml", "cabal.project"
		-- , "package.yaml"
		, "hie.yaml"
	),

	on_attach=attach_cb.on_attach,
	message_level = vim.lsp.protocol.MessageType.Warning,
	-- init_options = {
	settings = {
		-- languageServerHaskell = {
		haskell = {
			completionSnippetsOn = false,
			formattingProvider = "stylish-haskell",
		-- "haskell.trace.server": "messages",
			logFile = "/tmp/nvim-hls.log",
		-- "codeLens.enable": true,
			hlintOn = false
		}
	}
})


-- vim.lsp.add_filetype_config({
-- 	name = "latex";
-- 	cmd = "digestif",
-- 	filetypes = { "tex" };
-- })


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


lspconfig.rnix.setup{}

-- Available on nix via python-language-server (microsoft)
-- lspconfig.pyls_ms.setup({
-- 	cmd = { "python-language-server" };
--     init_options = {
--       analysisUpdates = true,
--       asyncStartup = true,
--       displayOptions = {},
--     },
-- 	-- as per lsp_status doc
-- 	-- callbacks = lsp_status.extensions.pyls_ms.setup(),
--     settings = {
--       python = {
--         analysis = {
--           disabled = {},
--           errors = {},
--           info = {}
--         }
--       }
-- 	}
-- })

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
    cmd = {"clangd", "--background-index",
		-- "--log=info", -- error/info/verbose
		-- "--pretty" -- pretty print json output
	};
	filetypes = { "c", "cpp", "objc", "objcpp" },
	log_level = vim.lsp.protocol.MessageType.Debug;
	on_attach=attach_cb.on_attach,
--	-- 'build/compile_commands.json',
--	root_dir = lspconfig.util.root_pattern( '.git'),
--	-- mandated by lsp-status
--	init_options = {
--		-- clangdFileStatus = true
--	},
--	-- callbacks = lsp_status.extensions.clangd.setup()
})

-- lua vim.lsp.buf.hover()

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

-- -- config at https://raw.githubusercontent.com/palantir/python-language-server/develop/vscode-client/package.json
-- lspconfig.pyls.setup({
-- 	name = "pyls";
-- 	cmd = {  "python", "-mpyls", "-vv", "--log-file" , "/tmp/lsp_python.log"},
-- 	-- init_options = {
-- 	enable = true;
-- 	trace = { server = "verbose"; };
-- 	configurationSources = { "pycodestyle" };
-- 	settings = {
-- 		pyls = {
-- 		plugins = {
-- 			pylint = { enabled = false; };
-- 			jedi_completion = { enabled = true; };
-- 			jedi_hover = { enabled = true; };
-- 			jedi_references = { enabled = true; };
-- 			jedi_signature_help = { enabled = true; };
-- 			jedi_symbols = {
-- 				enabled = false;
-- 				all_scopes = false;
-- 			};
-- 			mccabe = {
-- 				enabled = false;
-- 				threshold = 15;
-- 			};
-- 			-- preload = { enabled = true; };
-- 			pycodestyle = { enabled = true; };
-- 			-- pydocstyle = {
-- 			-- 	enabled = false;
-- 			-- 	match = "(?!test_).*\\.py";
-- 			-- 	matchDir = "[^\\.].*";
-- 			-- };
-- 			pyflakes = { enabled = false; };
-- 			rope_completion = { enabled = false; };
-- 			yapf = { enabled = false; };
-- 		};
-- 	};
-- 	};
-- })

local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

-- -- taken from https://github.com/neovim/neovim/pull/12368
local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end


vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = ''
vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

vim.g.should_show_diagnostics_in_statusline = true


  -- if #vim.lsp.buf_get_clients() == 0 then
  --   return ''
  -- end

  -- local status_parts = {}
  -- local base_status = ''

  -- local some_diagnostics = false
  -- local only_hint = true

  -- if vim.g.should_show_diagnostics_in_statusline then
  --   local diagnostics = lsp_status.diagnostics()
  --   local buf_messages = lsp_status.messages()
  --   if diagnostics.errors and diagnostics.errors > 0 then
  --     table.insert(status_parts, vim.g.indicator_errors .. ' ' .. diagnostics.errors)
  --     only_hint = false
  --     some_diagnostics = true
  --   end

  --   if diagnostics.warnings and diagnostics.warnings > 0 then
  --     table.insert(status_parts, vim.g.indicator_warnings .. ' ' .. diagnostics.warnings)
  --     only_hint = false
  --     some_diagnostics = true
  --   end

  --   if diagnostics.info and diagnostics.info > 0 then
  --     table.insert(status_parts, vim.g.indicator_info .. ' ' .. diagnostics.info)
  --     only_hint = false
  --     some_diagnostics = true
  --   end

  --   if diagnostics.hints and diagnostics.hints > 0 then
  --     table.insert(status_parts, vim.g.indicator_hint .. ' ' .. diagnostics.hints)
  --     some_diagnostics = true
  --   end

  --   local msgs = {}
  --   for _, msg in ipairs(buf_messages) do
  --     local name = aliases[msg.name] or msg.name
  --     local client_name = '[' .. name .. ']'
  --     if msg.progress then
  --       local contents = msg.title
  --       if msg.message then
  --         contents = contents .. ' ' .. msg.message
  --       end

  --       if msg.percentage then
  --         contents = contents .. ' (' .. msg.percentage .. ')'
  --       end

  --       if msg.spinner then
  --         contents = vim.g.spinner_frames[(msg.spinner % #vim.g.spinner_frames) + 1] .. ' ' .. contents
  --       end

  --       table.insert(msgs, client_name .. ' ' .. contents)
  --     else
  --       table.insert(msgs, client_name .. ' ' .. msg.content)
  --     end
  --   end

  --   base_status = vim.trim(table.concat(status_parts, ' ') .. ' ' .. table.concat(msgs, ' '))
  -- end

  -- local symbol = ' 🇻' .. ((some_diagnostics and only_hint) and '' or ' ')
  -- local current_function = vim.b.lsp_current_function
  -- if current_function and current_function ~= '' then
  --   symbol = symbol .. '(' .. current_function .. ') '
  -- end

  -- if base_status ~= '' then
  --   return symbol .. base_status .. ' '
  -- end

  -- return symbol .. vim.g.indicator_ok .. ' '
-- end

-- to disable virtualtext check 
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()]]
-- vim.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()]]

-- TELESCOPE
--
-- Fuzzy find over git files in your directory
-- require('telescope.builtin').git_files()

-- -- Grep as you type (requires rg currently)
-- require('telescope.builtin').live_grep()

-- -- Use builtin LSP to request references under cursor. Fuzzy find over results.
-- require('telescope.builtin').lsp_references()

-- -- Convert currently quickfixlist to telescope
-- require('telescope.builtin').quickfix()

