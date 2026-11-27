function setup(config)
    config.action('show diff in nvim', function()
        local change_id = context.change_id()
        if not change_id or change_id == '' then
            flash({ text = 'No revision selected', error = true })
            return
        end

        exec_shell(string.format(
            "jj diff -r %q --git --color never | nvim -R -c 'set filetype=diff' -",
            change_id
        ))
    end, {
        desc = 'show diff in nvim',
        key = 'd',
        scope = 'revisions',
    })

    config.action('create-bookmark', function()
        -- ideally
        jj('bookmark', 'create', '-r', revisions.current(), input({ title = 'Create bookmark', value = 'teto/' }))
        revisions.refresh()
    end, {
        key = 'B',
        -- seq = { "\\", "c" },
        scope = 'revisions',
    })
end
