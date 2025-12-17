return {
  cmd = { 'emmylua_ls' , '--log-level=info'},
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.emmyrc.json',
    '.luacheckrc',
    '.git',
  },
  workspace_required = false,
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                workspaceRate = 50, -- spare CPU
                globals = {
                    -- nvim and its tests
                    'vim',
                    'describe',
                    'it',
                    'before_each',
                    'after_each',
                    'pending',
                    'teardown',

                    -- for uv
                    'os_name',
                    -- for luasnip
                    's',
                    't',
                    'i',
                    'fmt',
                    'f', -- function node
                    'c', -- for choice
                    -- available in wireplumber
                    'alsa_monitor',
                    -- for yazi
                    'ya',
                    'ui',
                    'cx',
                    'Command',
                    'assert',

                    -- used by fzf-lua
                    'FzfLua',
                },
                -- Define variable names that will not be reported as an unused local by unused-local.
                unusedLocalExclude = { '_*' },

                disable = {
                    'lowercase-global',
                    'unused-function',
                    -- these are buggy
                    'duplicate-doc-field',
                    'duplicate-set-field',
                    --
                    'missing-fields', -- to silence vim.uv.os_name warnings for instance
                    'undefined-field', -- Disable undefined-field diagnostic
                },
            },
 }
 }

}
