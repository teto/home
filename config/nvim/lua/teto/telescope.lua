local M = {}
function M.telescope_create_keymaps()
    -- lua require('telescope.builtin').vim_options{}

    vim.keymap.set('n', '<Leader>g', function()
        require('telescope.builtin').find_files({})
    end)
    vim.keymap.set('n', '<Leader>b', function()
        require('telescope.builtin').buffers({})
    end)
    vim.keymap.set('n', '<Leader>o', function()
        require('telescope.builtin').git_files({})
    end, { desc =  "Fuzzy search files" })
    -- vim.keymap.set ('n', "<Leader>F", function () vim.cmd("FzfFiletypes") end)
    vim.keymap.set('n', '<Leader>t', function()
        require('telescope.builtin').tags({})
    end)
    vim.keymap.set('n', '<Leader>l', function()
        require('telescope.builtin').live_grep({})
    end)
    vim.keymap.set('n', '<Leader>h', function()
        require('telescope.builtin').oldfiles({})
    end)

    -- TODO search menus
    -- vim.keymap.set ('n', "<Leader>m", vim.notify("NOT IMPLEMENTED YET") )
    vim.keymap.set('n', '<Leader>C', function()
        require('telescope.builtin').colorscheme({ enable_preview = true })
    end)
end

return M
