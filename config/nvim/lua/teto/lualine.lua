-- display whether we record the session or not
-- For custom components see
-- https://github.com/nvim-lualine/lualine.nvim#custom-components
local clip = require('teto.clipboard')
local obsession_component = require('teto.lualine.obsession')
-- local hl = require('lualine.highlight')
-- hl.get_stl_default_hl()
-- print(vim.inspect(hl))

-- print(vim.inspect(obsession_component))

-- sections = { lualine_a = { hello } }

-- local component = {function() return "toto" end , color = {fg= "red"}}

require('lualine').setup({
	options = {
		icons_enabled = false,
		-- theme = 'gruvbox',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		separators = { left = '', right = '' },
		globalstatus = true,
		-- disabled_filetypes = {}
	},
	sections = {
		lualine_a = { 'branch' },
		lualine_b = {
			-- path=2 => absolute path
			{
				'filename',
				path = 1,
				-- takes a function that is called when component is clicked with mouse.
				on_click = function(_nb_of_clicks, _button, _modifiers)
				 local filename = vim.fn.getreg('%')
					print('copying filename to clipboard: '..filename)
					-- copy it into clipboard
					-- vim.cmd("call provider#clipboard#Call('set', [ ['tata'], 'v','\"']))")
					clip.copy(filename)
-- lua vim.api.nvim_feedkeys("+y", "n", false)
--     return call(s:clipboard[a:method],a:args,s:clipboard)
--     echo provider#clipboard#Call('get', ['*'])
-- vim.cmd("provider#clipboard#Call('copy', )")
-- reg) abort
				end,
				-- the function receives several arguments
				-- - number of clicks incase of multiple clicks
				-- - mouse button used (l(left)/r(right)/m(middle)/...)
				-- - modifiers pressed (s(shift)/c(ctrl)/a(alt)/m(meta)...)
			},
		},

		lualine_c = {
			'lsp_progress',
			-- obsession_component,
			-- {'lsp_progress', display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }}}
			-- ,  gps.get_location, condition = gps.is_available
			-- obsession_status
			 -- { '' , type = "lua_expr"}
			--
		},
		lualine_x = {
			-- 'encoding', 'fileformat', 'filetype'
			-- obsession_status
		},
		lualine_y = { 'diagnostics', 'progress' }, -- progress = %progress in file
		lualine_z = {
		  obsession_component
		  , 'location'
		},
	},
	-- inactive_sections = {
	--	 lualine_a = {},
	--	 lualine_b = {},
	--	 lualine_c = {'filename', 'lsp_progress'},
	--	 lualine_x = {'location'},
	--	 lualine_y = {},
	--	 lualine_z = {}
	-- },
	-- tabline = {},
	extensions = { 'fzf', 'fugitive' },
})
