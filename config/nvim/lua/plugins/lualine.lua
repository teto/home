-- display whether we record the session or not
-- For custom components see
-- https://github.com/nvim-lualine/lualine.nvim#custom-components
local clip = require('teto.clipboard')
local obsession_component = require('teto.lualine.obsession')
-- local hl = require('lualine.highlight')
-- hl.get_stl_default_hl()
-- print(vim.inspect(hl))

-- print(vim.inspect(obsession_component))

-- local component = {function() return "toto" end , color = {fg= "red"}}
local trouble = require('trouble')
local symbols = trouble.statusline({
    mode = 'lsp_document_symbols',
    groups = {},
    title = false,
    filter = { range = true },
    format = '{kind_icon}{symbol.name:Normal}',
    -- The following line is needed to fix the background color
    -- Set it to the lualine section you want to use
    hl_group = 'lualine_c_normal',
})
-- table.insert(_opts.sections.lualine_c, )

-- Trying to display
local get_workspace_diagnostic_count = function()
    local ws_diags = #vim.diagnostic.get()
    return 'count: ' .. tostring(ws_diags)
end
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
        lualine_a = {
            {
                'branch',
                on_click = function(_nb_of_clicks, _button, _modifiers)
                    clip.copy('BRANCH_PLACEHOLDER')
                    -- the
                end,
            },
        },
        lualine_b = {
            {
                'filename',
                path = 1,
                -- takes a function that is called when component is clicked with mouse.
                -- button is 'l', 'r'
                on_click = function(_nb_of_clicks, button, _modifiers)
                    -- local bufnr = vim.fn.bufnr('%')
                    local filename = vim.fn.bufname('%') -- vim.fn.getreg('%')
                    local copy_fullpath = (button == 'r')
                    if copy_fullpath then
                        filename = vim.fn.fnamemodify(filename, ':p')
                    end
                    print('To clipboard: ' .. filename)
                    clip.copy(filename)
                end,
                -- path=2 => absolute path
                -- the function receives several arguments
                -- - number of clicks incase of multiple clicks
                -- - mouse button used (l(left)/r(right)/m(middle)/...)
                -- - modifiers pressed (s(shift)/c(ctrl)/a(alt)/m(meta)...)
            },
        },

        lualine_c = {
            -- 'lsp_progress',
            -- obsession_component,
            -- {'lsp_progress', display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }}}
            -- ,  gps.get_location, condition = gps.is_available
            -- obsession_status
            -- { '' , type = "lua_expr"}
            --
            {
                symbols.get,
                cond = symbols.has,
            },
        },
        lualine_x = {
            -- 'encoding', 'fileformat', 'filetype'
            -- obsession_status
        },
        lualine_y = { 'diagnostics', 'progress' }, -- progress = %progress in file
        lualine_z = {
            obsession_component,
            get_workspace_diagnostic_count,
            'location',
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
	-- tabline is handled by bufferline.nvim
    -- tabline = {},
	winbar = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {},
	  lualine_y = { 'diagnostics', 'progress' },
	  lualine_z = {}
	},

	inactive_winbar = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {},
	  lualine_y = {},
	  lualine_z = {}
	},
    extensions = { 'fzf', 'fugitive' },
})
