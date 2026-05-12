-- display whether we record the session or not
-- For custom components see
-- https://github.com/nvim-lualine/lualine.nvim#custom-components
local clip = require('teto.clipboard')
-- local obsession_component = require('lualine.obsession')
-- local hl = require('lualine.highlight')
-- hl.get_stl_default_hl()
-- print(vim.inspect(hl))
-- print(vim.inspect(obsession_component))

-- local component = {function() return "toto" end , color = {fg= "red"}}
-- local trouble = require('trouble')
-- local symbols = trouble.statusline({
--     mode = 'lsp_document_symbols',
--     groups = {},
--     title = false,
--     filter = { range = true },
--     format = '{kind_icon}{symbol.name:Normal}',
--     -- The following line is needed to fix the background color
--     -- Set it to the lualine section you want to use
--     hl_group = 'lualine_c_normal',
-- })
-- table.insert(_opts.sections.lualine_c, )

-- Trying to display
-- local get_workspace_diagnostic_count = function()
--     local ws_diags = #vim.diagnostic.get()
--     return 'count: ' .. tostring(ws_diags)
-- end

local diagnostic_section = {
    'diagnostics',

    -- Table of diagnostic sources, available sources are:
    --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
    -- or a function that returns a table as such:
    --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
    sources = { 'nvim_diagnostic' },

    -- Displays diagnostics for the defined severity types
    sections = {
        'error',
        'warn',
        'info',
        'hint',
    },

    diagnostics_color = {
        -- Same values as the general color option can be used here.
        error = 'DiagnosticError', -- Changes diagnostics' error color.
        warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
        info = 'DiagnosticInfo', -- Changes diagnostics' info color.
        hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
    },
    symbols = {
        error = vim.g.indicator_errors,
        warn = vim.g.indicator_warnings,
        info = 'I',
        hint = 'H',
    },
    colored = true, -- Displays diagnostics status in color if set to true.
    update_in_insert = false, -- Update diagnostics in insert mode.
    always_visible = false, -- Show diagnostics even if there are none.
}

local buffers_section = {
    'buffers',
    show_filename_only = true, -- Shows shortened relative path when set to false.
    hide_filename_extension = false, -- Hide filename extension when set to true.
    show_modified_status = true, -- Shows indicator when the buffer is modified.

    mode = 2, -- 0: Shows buffer name
    -- 1: Shows buffer index
    -- 2: Shows buffer name + buffer index
    -- 3: Shows buffer number
    -- 4: Shows buffer name + buffer number

    -- max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
    --                                     -- it can also be a function that returns
    --                                     -- the value of `max_length` dynamically.
    filetype_names = {
        TelescopePrompt = 'Telescope',
        dashboard = 'Dashboard',
        packer = 'Packer',
        fzf = 'FZF',
        alpha = 'Alpha',
        AvanteInput = 'Avante Prompt',
    }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

    -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
    use_mode_colors = true,

    buffers_color = {
        -- Same values as the general color option can be used here.
        -- active = 'lualine_{section}_normal',     -- Color for active buffer.
        -- inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
    },

    symbols = {
        modified = ' ●', -- Text to show when the buffer is modified
        alternate_file = '#', -- Text to show to identify the alternate file
        directory = '', -- Text to show when the buffer is a directory
    },
}

local branch_name = ''

require('lualine').setup({
    options = {
        icons_enabled = false,
        -- theme = 'gruvbox',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        separators = { left = '', right = '' },
        globalstatus = true,
        -- If current filetype is in this list it'll
        -- always be drawn as inactive statusline
        -- and the last window will be drawn as active statusline.
        -- for example if you don't want statusline of
        -- your file tree / sidebar window to have active
        -- statusline you can add their filetypes here.
        --
        -- Can also be set to a function that takes the
        -- currently focused window as its only argument
        -- and returns a boolean representing whether the
        -- window's statusline should be drawn as inactive.
        ignore_focus = {
            -- todo add avante
            'AvanteInput',
            'AvanteSelectedFiles',
        },
        always_divide_middle = false,
        -- handled by bufferline
        always_show_tabline = false,

        -- Disable winbar for these filetypes
        disabled_filetypes = {
            winbar = {
                -- 'Avante',
                'help',
                'markdown',
                'qf',
                'AvanteInput',
                'AvanteSelectedFiles',
                -- 'AvanteConfirm',
                'Avante',
            },

            statusline = {
                'AvanteInput',
                'AvanteSelectedFiles',
                'AvanteTodos',
                -- 'AvanteConfirm',
                'Avante',
            },
        },
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                'WinEnter',
                'BufEnter',
                'BufWritePost',
                'SessionLoadPost',
                'FileChangedShellPost',
                'VimResized',
                'Filetype',
                'CursorMoved',
                'CursorMovedI',
                'ModeChanged',
            },
        },
    },
    sections = {
        lualine_a = {
            {
                'branch',
                -- truncate too long branch names !
                fmt = function(str)
                    -- truncation should be an option ?
                    branch_name = str:sub(1, 20)
                    return branch_name
                end,
                on_click = function(_nb_of_clicks, _button, _modifiers)
                    -- the component should have a 'status' output
                    -- local branch_name = 'BRANCH_PLACEHOLDER'
                    -- status()
                    clip.copy(branch_name)
                    print('To clipboard: ' .. branch_name)
                end,
            },
        },
        lualine_b = {
            {
                'filename',

                file_status = true,
                -- https://github.com/nvim-lualine/lualine.nvim#filename-component-options

                path = 4,
                symbols = {
                    modified = '[+]', -- Text to show when the file is modified.
                    readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[No Name]', -- Text to show for unnamed buffers.
                    newfile = '[New]', -- Text to show for newly created file before first write
                },

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
            -- 'lsp_progress', -- remove / outdated
            {
                'lsp_status',
                icon = '', -- f013
                symbols = {
                    -- Standard unicode symbols to cycle through for LSP progress:
                    spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                    -- Standard unicode symbol for when LSP is done:
                    done = '✓',
                    -- Delimiter inserted between LSP names:
                    separator = ' ',
                },
                -- List of LSP names to ignore (e.g., `null-ls`):
                ignore_lsp = {},
                -- Display the LSP name
                show_name = true,
            },
            -- obsession_component,
            -- {'lsp_progress', display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }}}
            -- ,  gps.get_location, condition = gps.is_available
            -- obsession_status
            -- { '' , type = "lua_expr"}
            --

            -- {
            --     symbols.get,
            --     cond = symbols.has,
            -- },
        },
        lualine_x = {
            -- 'encoding', 'fileformat', 'filetype'
            -- obsession_status
        },
        lualine_y = {
            -- diagnostic_section,
            -- progress = %progress in file
            'progress',
        },
        lualine_z = {

            -- 'obsession',
            -- 'autosession',
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
    tabline = {
        lualine_a = {
            buffers_section,
        },
        lualine_b = {
            -- 'branch'
        },
        lualine_c = {
            -- 'filename'
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    --[[ TODO :
	- add lock for readonly
	- also if diffthis is set
	]]

    winbar = {
        lualine_a = { 'filename' },
        lualine_b = { diagnostic_section },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = {},
    },

    inactive_winbar = {
        lualine_a = { 'filename' },
        lualine_b = { diagnostic_section },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {
        'fzf', -- wat ?
        'fugitive',
        'oil',
        'man',
        'trouble',
    },
})
