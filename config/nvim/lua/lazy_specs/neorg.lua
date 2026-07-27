return {
    'neorg',
    cmd = 'Norg',
    before = function()
        -- local has_norg, _norg = pcall(require, 'neorg')
        require('plugins.neorg')
    end,
}
