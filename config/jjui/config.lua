function setup(config)
    config.action('create-bookmark', function()
        jj('bookmark', 'create', '-r', revisions.current(), input({ title = 'Create bookmark' }))
        revisions.refresh()
    end, {
        key = 'B',
        -- seq = { "\\", "c" },
        scope = 'revisions',
    })
end
