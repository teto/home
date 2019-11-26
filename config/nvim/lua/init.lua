-- local nvim_lsp = require 'nvim_lsp'

vim.lsp.add_filetype_config({
	name = "lua";
	cmd = "lua-lsp",
	filetypes = { "lua" };
})

vim.lsp.add_filetype_config({
	name = "bash";
	cmd = "bash-language-server start",
	filetypes = { "sh" };
})

vim.lsp.add_filetype_config({
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

vim.lsp.add_filetype_config({
	name = "latex";
	cmd = "digestif",
	filetypes = { "tex" };
})

vim.lsp.add_filetype_config {
	name = "clangd";
	filetype = {"c", "cpp"};
	cmd = "clangd-7 -background-index";
	capabilities = {
		offsetEncoding = {"utf-8", "utf-16"};
	};

	on_init = vim.schedule_wrap(function(client, result)
		if result.offsetEncoding then
			client.offset_encoding = result.offsetEncoding
		end
	end)
}

vim.lsp.add_filetype_config {
	name = "ccls",
	filetypes = { "c", "cpp", "objc", "objcpp" },
	cmd = { "ccls", "--log-file=/tmp/ccls.log", "-v=1" },

	init_options = {
		-- "compilationDatabaseDirectory": "/home/teto/mptcp/build",
		clang = { excludeArgs = { "-m*", "-Wa*" } },
		cache = { directory = "/tmp/ccls" }
	}
}

vim.lsp.add_filetype_config({
	name = "pyls";
	filetype = "python";
	root_dir = ".";
	trace = "verbose";
	init_options = {
	enable = true;
	trace = { server = "verbose"; };
	commandPath = "";
	configurationSources = { "pycodestyle" };
	plugins = {
		jedi_completion = { enabled = true; };
		jedi_hover = { enabled = true; };
		jedi_references = { enabled = true; };
		jedi_signature_help = { enabled = true; };
		jedi_symbols = {
		enabled = true;
		all_scopes = true;
		};
		mccabe = {
		enabled = true;
		threshold = 15;
		};
		preload = { enabled = true; };
		pycodestyle = { enabled = true; };
		pydocstyle = {
		enabled = false;
		match = "(?!test_).*\\.py";
		matchDir = "[^\\.].*";
		};
		pyflakes = { enabled = true; };
		rope_completion = { enabled = true; };
		yapf = { enabled = true; };
	};
	};

})
