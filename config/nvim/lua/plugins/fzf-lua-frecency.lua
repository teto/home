-- else frecency doesnt appear
local _has_fzf_lua_frecency, fzf_lua_frecency = pcall(require, 'fzf-lua-frecency')

-- if has_fzf_lua_frecency then
fzf_lua_frecency.setup({
    cwd_only = true,
    -- all_files = nil,
    stat_file = true,
    display_score = true,
    fzf_opts = {
        ['--multi'] = true,
        -- ,begin
        ['--tiebreak'] = 'length,chunk',

        -- ["--scheme"] = "path",
        -- ["--no-sort"] = true,
    },
})
-- end
