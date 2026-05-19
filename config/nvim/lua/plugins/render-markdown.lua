require('render-markdown').setup({
    -- to appease checkhealth
    html = { enabled = false },
    -- use recommended settings from above
    file_types = { 'markdown', 'Avante' },
})
