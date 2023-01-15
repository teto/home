return {
-- REPL (Read Execute Present Loop) {{{
-- use 'metakirby5/codi.vim', {'on': 'Codi'} -- repl
-- careful it maps cl by default
-- use 'jalvesaq/vimcmdline' -- no help files, mappings clunky
-- github mirror of use 'http://gitlab.com/HiPhish/repl.nvim'
-- use 'http://gitlab.com/HiPhish/repl.nvim' -- no commit for the past 2 years
--}}}
{
	'hkupty/iron.nvim',
	config = function ()
		local iron = require("iron.core")
		iron.setup {
		config = {
			-- If iron should expose `<plug>(...)` mappings for the plugins
			should_map_plug = false,
			-- Whether a repl should be discarded or not
			scratch_repl = true,
			-- Your repl definitions come here
			repl_definition = {
				sh = { command = {"zsh"} },
				nix = { command = {"nix",  "repl", "/home/teto/nixpkgs"} },
				-- copied from the nix wrapper :/
				lua = { command = "lua"}
			},
			repl_open_cmd = require('iron.view').bottom(40),
			-- how the REPL window will be opened, the default is opening
			-- a float window of height 40 at the bottom.
		},
		-- Iron doesn't set keymaps by default anymore. Set them here
		-- or use `should_map_plug = true` and map from you vim files
		keymaps = {
			send_motion = "<space>sc",
			visual_send = "<space>sc",
			send_file = "<space>sf",
			send_line = "<space>sl",
			send_mark = "<space>sm",
			mark_motion = "<space>mc",
			mark_visual = "<space>mc",
			remove_mark = "<space>md",
			cr = "<space>s<cr>",
			interrupt = "<space>s<space>",
			exit = "<space>sq",
			clear = "<space>cl",
		},
		-- If the highlight is on, you can change how it looks
		-- For the available options, check nvim_set_hl
		highlight = {
			italic = true
		}
		}

	end
}
}
