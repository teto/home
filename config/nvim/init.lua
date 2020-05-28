-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local nvim_lsp = require 'nvim_lsp'
local configs = require'nvim_lsp/configs'
local lsp_status = require'lsp-status'

-- completion_customize_lsp_label as used in completion-nvim
lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

-- Register the progress callback
-- lsp_status.register_progress()


-- custom attach callback
local attach_cb = require 'on_attach'


-- this generates an error
-- to override all defaults
--   { log_level = lsp.protocol.MessageType.Warning.Error }
nvim_lsp.util.default_config.capabilities = vim.tbl_extend(
  "force",
  nvim_lsp.util.default_config.capabilities or {},
  -- enable 'progress' support in lsp servers
  lsp_status.capabilities
)

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

		-- ".stack.yaml",
        -- ".hie-bios",
        -- "BUILD.bazel",
        -- "cabal.config",
        -- "package.yaml"
	root_dir = function(fname)
		return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
	end;
	log_level = vim.lsp.protocol.MessageType.Warning;
	settings = {};
	on_attach=attach_cb.on_attach
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
	cmd = { "python-language-server" };
    init_options = {
      analysisUpdates = true,
      asyncStartup = true,
      displayOptions = {},
    },
	-- as per lsp_status doc
	callbacks = lsp_status.extensions.pyls_ms.setup(),
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

nvim_lsp.clangd.setup({
	--compile-commands-dir=build
    cmd = {"clangd", "--background-index", 
		"--log=info", -- error/info/verbose
		"--pretty" -- pretty print json output
	};
	-- 'build/compile_commands.json',
	root_dir = nvim_lsp.util.root_pattern( '.git'),
	-- mandated by lsp-status
	init_options = { clangdFileStatus = true },
	callbacks = lsp_status.extensions.clangd.setup()
})


-- https://github.com/MaskRay/ccls/wiki/Debugging
-- nvim_lsp.ccls.setup({
-- 	name = "ccls",
-- 	filetypes = { "c", "cpp", "objc", "objcpp" },
-- 	cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=1" },
-- 	log_level = vim.lsp.protocol.MessageType.Log;
-- 	root_dir = nvim_lsp.util.root_pattern(".git");
-- 	init_options = {
-- 		-- "compilationDatabaseDirectory": "/home/teto/mptcp/build",
-- 		clang = { excludeArgs = { "-m*", "-Wa*" } },
-- 		cache = { directory = "/tmp/ccls" }
-- 	},
-- 	on_attach = attach_cb.on_attach
-- })

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

-- taken from https://github.com/neovim/neovim/pull/12368
function peek_definition()
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

function StatusLineLSP()
	return lsp_status.status()
end
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

