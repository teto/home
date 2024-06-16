require('highlight-undo').setup({
    hlgroup = 'HighlightUndo',
    duration = 300,
    keymaps = {
        { 'n', 'u', 'undo', {} },
        { 'n', '<C-r>', 'redo', {} },
    },
})
