local neotest = require('neotest')
neotest.setup({
    adapters = {
        neotest({
            -- Default: Use stack if possible and then try cabal
            build_tools = { 'stack', 'cabal' },
            -- Default: Check for tasty first and then try hspec
            frameworks = { 'tasty', 'hspec', 'sydtest' },
        }),
    },
})
