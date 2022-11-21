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
                        on_click = function(nb_of_clicks, button, _modifiers)
                            print('CLICK')
                        end,
                        -- the function receives several arguments
                        -- - number of clicks incase of multiple clicks
                        -- - mouse button used (l(left)/r(right)/m(middle)/...)
                        -- - modifiers pressed (s(shift)/c(ctrl)/a(alt)/m(meta)...)
                    },
                },

                lualine_c = {
                    'lsp_progress',
                    -- component
                    -- {'lsp_progress', display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }}}
                    -- ,  gps.get_location, condition = gps.is_available
                },
                lualine_x = {
                    -- 'encoding', 'fileformat', 'filetype'
                },
                lualine_y = { 'diagnostics', 'progress' }, -- progress = %progress in file
                lualine_z = { 'location' },
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

