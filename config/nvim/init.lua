-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local nvim_lsp = require 'nvim_lsp'
local configs = require'nvim_lsp/configs'

local attach_cb = require 'on_attach'

-- to override all defaults
-- nvim_lsp.util.default_config = vim.tbl_extend(
--   "force",
--   nvim_lsp.util.default_config,
--   { log_level = lsp.protocol.MessageType.Warning.Error }
-- )

-- vim.lsp.util.show_current_line_diagnostics()
-- Check if it's already defined for when I reload this file.
if not configs.lua_lsp then
  configs.lua_lsp = {
    default_config = {
      cmd = {'lua-lsp'};
      filetypes = {'lua'};
	  root_dir = function(fname)
        return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
      end;
      log_level = vim.lsp.protocol.MessageType.Warning;
      settings = {};
    };
  }
end

-- if not nvim_lsp.ghcide then
--   configs.ghcide = {
-- 	  default_config = {
-- 		name = "ghcide";
-- 		cmd = {"ghcide", "--lsp"};
-- 		filetypes = { "hs", "lhs", "haskell" };
-- 		root_dir = function(fname)
-- 			return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
-- 		end;
-- 		log_level = vim.lsp.protocol.MessageType.Warning;
-- 		settings = {};
-- 	};
--   }
-- end

nvim_lsp.lua_lsp.setup{}
-- sumneko_lua
-- nvim_lsp.lua_lsp.setup{
-- 	name = "lua";
-- 	-- cmd = "lua-lsp",
-- 	-- filetypes = { "lua" };
-- })

-- vim.lsp.add_filetype_config({
-- 	name = "bash";
-- 	cmd = "bash-language-server start",
-- 	filetypes = { "sh" };
-- })



nvim_lsp.ghcide.setup({
	log_level = vim.lsp.protocol.MessageType.Log;
	root_dir = nvim_lsp.util.root_pattern(".git");

	cmd = {"ghcide", "--lsp"};
	filetypes = { "hs", "lhs", "haskell" };
	root_dir = function(fname)
		return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
	end;
	log_level = vim.lsp.protocol.MessageType.Warning;
	settings = {};
	-- on_attach=attach_cb.on_attach
})

--nvim_lsp.hie.setup({
--	name = "hie";
--	-- cmd = "otot";
--	-- "/home/teto/all-hies/result/bin/hie-wrapper"
--	-- cmd = { "toto", "--lsp", "-d", "--vomit", "--logfile", "/tmp/lsp_haskell.log"},
--	filetypes = { "hs", "lhs", "haskell" };
--	-- init_options = {};
--	root_dir = nvim_lsp.util.root_pattern(".git");
--	-- root_dir = function () return "/home/teto/test-task-2-final/solution" end;
--	log_level = vim.lsp.protocol.MessageType.Error;
--	--careful, without this, we get a warning from hie
--	init_options = {
--		languageServerHaskell = {
--			hlintOn = false;
--			-- maxNumberOfProblems = number;
--			-- diagnosticsDebounceDuration = number;
--			-- liquidOn = bool (default false);
--			completionSnippetsOn = true;
--			-- formatOnImportOn = bool (default true);
--			-- formattingProvider = string (default "brittany", alternate "floskell");
--		}
--	};
--	on_attach=diag_plugin.on_attach;

--})

-- vim.lsp.add_filetype_config({
-- 	name = "latex";
-- 	cmd = "digestif",
-- 	filetypes = { "tex" };
-- })


nvim_lsp.rust_analyzer.setup({
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
nvim_lsp.pyls_ms.setup({
    init_options = {
      analysisUpdates = true,
      asyncStartup = true,
      displayOptions = {},
      interpreter = {
        properties = {
          InterpreterPath = "/usr/bin/python",
          Version = "2.7"
        }
      }
    },
    -- on_new_config = <function 1>
    settings = {
      python = {
        analysis = {
          disabled = {},
          errors = {},
          info = {}
        }
      }
	}
})

nvim_lsp.texlab.setup({
  name = 'texlab_fancy';
  log_level = vim.lsp.protocol.MessageType.Log;
  message_level = vim.lsp.protocol.MessageType.Log;
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  }
})

--nvim_lsp.clangd.setup({
--	--compile-commands-dir=build
--    cmd = {"clangd", "--background-index", 
--		, "--log=verbose" -- error/info/verbose
--		"--pretty" -- pretty print json output
--	};
--})


-- https://github.com/MaskRay/ccls/wiki/Debugging
nvim_lsp.ccls.setup({
	name = "ccls",
	filetypes = { "c", "cpp", "objc", "objcpp" },
	cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=1" },
	log_level = vim.lsp.protocol.MessageType.Log;
	root_dir = nvim_lsp.util.root_pattern(".git");
	init_options = {
		-- "compilationDatabaseDirectory": "/home/teto/mptcp/build",
		clang = { excludeArgs = { "-m*", "-Wa*" } },
		cache = { directory = "/tmp/ccls" }
	},
	on_attach = attach_cb.on_attach
})

-- config at https://raw.githubusercontent.com/palantir/python-language-server/develop/vscode-client/package.json
nvim_lsp.pyls.setup({
	name = "pyls";
	cmd = {  "python", "-mpyls", "-vv", "--log-file" , "/tmp/lsp_python.log"},
	-- init_options = {
	enable = true;
	trace = { server = "verbose"; };
	configurationSources = { "pycodestyle" };
	settings = {
		pyls = {
		plugins = {
			pylint = { enabled = false; };
			jedi_completion = { enabled = true; };
			jedi_hover = { enabled = true; };
			jedi_references = { enabled = true; };
			jedi_signature_help = { enabled = true; };
			jedi_symbols = {
				enabled = false;
				all_scopes = false;
			};
			mccabe = {
				enabled = false;
				threshold = 15;
			};
			-- preload = { enabled = true; };
			pycodestyle = { enabled = true; };
			-- pydocstyle = {
			-- 	enabled = false;
			-- 	match = "(?!test_).*\\.py";
			-- 	matchDir = "[^\\.].*";
			-- };
			pyflakes = { enabled = false; };
			rope_completion = { enabled = false; };
			yapf = { enabled = false; };
		};
	};
	};
})


-- jsut to check if issues are mine or not
-- do
--   local method = 'textDocument/publishDiagnostics'
--   local default_callback = vim.lsp.callbacks[method]
--   vim.lsp.callbacks[method] = function(err, method, result, client_id)
--     default_callback(err, method, result, client_id)
--     if result and result.diagnostics then
--     --   for _, v in ipairs(result.diagnostics) do
--     --     v.uri = v.uri or result.uri
--     --   end
--       vim.lsp.util.set_loclist(result.diagnostics)
--     end
--   end
-- end

-- to disable virtualtext check 
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()]]
-- vim.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()]]

