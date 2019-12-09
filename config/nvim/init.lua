-- How to add a new server
-- https://github.com/neovim/nvim-lsp/issues/41
local nvim_lsp = require 'nvim_lsp'
local skeleton = require'nvim_lsp/skeleton'

-- vim.lsp.util.show_current_line_diagnostics()
-- Check if it's already defined for when I reload this file.
if not nvim_lsp.lua_lsp then
  skeleton.lua_lsp = {
    default_config = {
      cmd = {'lua-lsp'};
      filetypes = {'lua'};
      -- root_dir = function(fname)
      --   return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
      -- end;
      log_level = vim.lsp.protocol.MessageType.Warning;
      settings = {};
    };
  }
end

-- sumneko_lua
-- nvim_lsp.lua_lsp.setup({
-- 	name = "lua";
-- 	-- cmd = "lua-lsp",
-- 	-- filetypes = { "lua" };
-- })

-- vim.lsp.add_filetype_config({
-- 	name = "bash";
-- 	cmd = "bash-language-server start",
-- 	filetypes = { "sh" };
-- })

nvim_lsp.hie.setup({
	name = "hie";
	cmd = "hie-wrapper";
	filetypes = { "hs", "lhs", "haskell" };
	init_options = {};
	-- languageServerHaskell = {
	capabilities = {
		hlintOn = false,
		maxNumberOfProblems= 10,
		completionSnippetsOn = true,
		liquidOn = false
	};
})

-- vim.lsp.add_filetype_config({
-- 	name = "latex";
-- 	cmd = "digestif",
-- 	filetypes = { "tex" };
-- })

-- vim.lsp.add_filetype_config {
-- 	name = "clangd";
-- 	filetype = {"c", "cpp"};
-- 	cmd = "clangd-7 -background-index";
-- 	capabilities = {
-- 		offsetEncoding = {"utf-8", "utf-16"};
-- 	};
-- 	on_init = vim.schedule_wrap(function(client, result)
-- 		if result.offsetEncoding then
-- 			client.offset_encoding = result.offsetEncoding
-- 		end
-- 	end)
-- }


nvim_lsp.texlab.setup({ })

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
	}
})

-- config at https://raw.githubusercontent.com/palantir/python-language-server/develop/vscode-client/package.json
nvim_lsp.pyls.setup({
	name = "pyls";
	cmd = {  "python", "-mpyls", "-vv", "--log-file" , "/tmp/lsp_python.log"},
	init_options = {
	enable = true;
	trace = { server = "verbose"; };
	commandPath = "";
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
			preload = { enabled = true; };
			pycodestyle = { enabled = true; };
			pydocstyle = {
				enabled = false;
				match = "(?!test_).*\\.py";
				matchDir = "[^\\.].*";
			};
			pyflakes = { enabled = false; };
			rope_completion = { enabled = false; };
			yapf = { enabled = false; };
		};
	};
	};
  };
})

do
  local method = 'textDocument/publishDiagnostics'
  local default_callback = vim.lsp.callbacks[method]
  vim.lsp.callbacks[method] = function(err, method, result, client_id)
    default_callback(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
      end
      vim.lsp.util.set_qflist(result.diagnostics)
    end
  end
end
