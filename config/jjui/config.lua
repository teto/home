function setup(config)
    config.action('create-bookmark', function()
	 -- ideally 
        jj('bookmark', 'create', '-r', revisions.current(), input({ title = 'Create bookmark'; value = "teto/" }))
        revisions.refresh()
    end, {
        key = 'B',
        -- seq = { "\\", "c" },
        scope = 'revisions',
    })
end
