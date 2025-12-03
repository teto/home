local fzf_lua = require('fzf-lua')
-- vim.ui.select
-- gotten from https://github.com/ibhagwan/fzf-lua/wiki#ui-select-auto-size
fzf_lua.register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
        h = min_h
    elseif h > max_h then
        h = max_h
    end

    local dopreview = vim.o.columns > 200
    local hidden = 'hidden'
    if dopreview then
        hidden = 'nohidden'
    end
    return {
        winopts = {
            height = h,
            width = 0.80,
            row = 0.40,

            preview = {
                hidden = hidden,
            },
        },
    }
end)

local fzf_history_dir = vim.fn.expand(vim.fn.stdpath('data') .. '/../fzf-history')
fzf_lua.setup({
    'default', -- chose one profile
    defaults = {
        --  "path.dirname_first"
        -- formatter = 'path.filename_first',
        git_icons = false,
        file_icons = false,
        color_icons = true,

        -- jj = {
        --   previewer         = M._default_previewer_fn,
        --   cmd               = "git ls-files --exclude-standard",
        --   multiprocess      = true,
        --   file_icons        = 1,
        --   color_icons       = true,
        --   git_icons         = true,
        --   fzf_opts          = { ["--multi"] = true, ["--scheme"] = "path" },
        --   _fzf_nth_devicons = true,
        --   _actions          = function() return M.globals.actions.files end,
        --   winopts           = { preview = { winopts = { cursorline = false } } },
        --
        --  files
        -- }
    },
    previewers = {
        builtin = {
            -- fzf-lua is very fast, but it really struggled to preview a couple files
            -- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
            -- It turns out it was Treesitter having trouble parsing the files.
            -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
            -- (Yes, I know you shouldn't have 100KB minified files in source control.)
            syntax_limit_b = 1024 * 100, -- 100KB
        },
    },
    oldfiles = {
        -- In Telescope, when I used <leader>fr, it would load old buffers.
        -- fzf lua does the same, but by default buffers visited in the current
        -- session are not included. I use <leader>fr all the time to switch
        -- back to buffers I was just in. If you missed this from Telescope,
        -- give it a try.
        include_current_session = true,
        -- cwd_only = true,
        stat_file = false, -- verify files exist on disk
    },
    'default-title',
    commands = { sort_lastused = true },
    -- [...]
    buffers = {
        prompt = 'Buffers❯ ',
        file_icons = true, -- show file icons (true|"devicons"|"mini")?
        color_icons = true, -- colorize file|git icons
        sort_lastused = true, -- sort buffers() by last used
        show_unloaded = true, -- show unloaded buffers
        cwd_only = false, -- buffers for the cwd only
    },

    nvim_options = {
        actions = {
            ['enter'] = { fn = FzfLua.actions.nvim_opt_edit_local, reload = true },
            ['shift-enter'] = { fn = FzfLua.actions.nvim_opt_edit_global, reload = true },
        },
    },
    fzf_opts = {
        -- [...]
        -- it shows raw ansi codes when disabled !
        -- ['--ansi'] = false, -- for speed
        ['--history'] = fzf_history_dir,

        --   pretty important actually
        --   Tiebreak criteria explained:
        ['--tiebreak'] = 'chunk,length,begin',
        -- to get the prompt at the top
        -- ['--layout'] = 'reverse', -- reverse is the default
        -- ["--no-scrollbar"] = true,
    },
    winopts = {
        preview = {
            -- default = 'builtin'
            hidden = 'hidden',
            -- Only used with the builtin previewer:
            title = true, -- preview border title (file/buf)?
            title_pos = 'left', -- left|center|right, title alignment
            scrollbar = 'float', -- `false` or string:'float|border'
            -- float:  in-window floating border
            -- border: in-border chars (see below)
            scrolloff = '-2', -- float scrollbar offset from right
            -- applies only when scrollbar = 'float'
            scrollchars = { '█', '' }, -- scrollbar chars ({ <full>, <empty> }
        },
        layout = 'flex',
        treesitter = {
            enable = true,
        },
        -- on_create = function() end
    },
    keymap = {
        fzf = {
            -- use cltr-q to select all items and convert to quickfix list
            ['ctrl-q'] = 'select-all+accept',

            -- ["ctrl-q"] = actions.file_sel_to_qf,
            --
            -- ["alt-i"]       = actions.toggle_ignore,
            -- ["alt-h"]       = actions.toggle_hidden,
            -- ["alt-f"]       = actions.toggle_follow,
        },
    },
})
