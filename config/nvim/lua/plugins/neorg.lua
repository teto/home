local M = {}

function M.setup_mappings()
    vim.keymap.set('n', '<leader>wn', '<cmd>Neorg workspace notes<CR>', { silent = true }) -- just this block or blocks within heading section
    vim.keymap.set('n', '<localleader>x', '<cmd>Neorg exec cursor<CR>', { silent = true }) -- just this block or blocks within heading section
    vim.keymap.set('n', '<localleader>X', '<cmd>Neorg exec current-file<CR>', { silent = true }) -- whole file
end

function M.setup()
    require('neorg').setup({
        load = {
            ['core.defaults'] = {}, -- Loads default behaviour
            ['core.keybinds'] = {
                config = {
                    default_keybinds = true,
                },
            },
            -- ["external.kanban"] = {},
            ['core.concealer'] = {}, -- Adds pretty icons to your documents
            ['core.ui.calendar'] = {},
            -- ['core.ui.calendar'] = {}, -- fails on stable nvim
            ['core.dirman'] = { -- Manages Neorg workspaces
                config = {
                    workspaces = {
                        offline = '~/Nextcloud/local_notes',
                        notes = '~/Nextcloud/notes',
                        -- ml = '~/Nextcloud/notes/ml',
                        -- notes = "~/Nextcloud/Notes",
                    },
                    default_workspace = 'notes',
                },
            },
            -- needs neorg-exec plugin
            -- ["external.exec"] = {},
        },
    })
end

M.setup()
M.setup_mappings()
vim.api.nvim_create_user_command('Notes', function()
    vim.cmd(':Neorg workspace notes')
end, {
    desc = 'Opens my neorg notes.',
})

return M
