require('oil').setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you still want to use netrw.
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    -- delete_to_trash = true
})
