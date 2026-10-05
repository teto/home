return {
    'rikai.nvim',
    cmd = 'Rikai',
    -- The local checkout is on runtimepath, rather than installed as a package.
    load = function()
        vim.cmd.runtime('plugin/rikai.lua')
    end,
}
