require('render-markdown').setup({
    -- enabled = true,
    -- debounce = 100,
    log_level = 'error',
    log_runtime = false,
    -- to appease checkhealth
    html = { enabled = false },
    -- use recommended settings from above
    file_types = { 'markdown', 'Avante' },
})
