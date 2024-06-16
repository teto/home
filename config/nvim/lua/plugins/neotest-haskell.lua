require('neotest').setup({
    adapters = {
        require('neotest-haskell')({
            -- Default: Use stack if possible and then try cabal
            build_tools = { 'stack', 'cabal' },
            -- Default: Check for tasty first and then try hspec
            frameworks = { 'tasty', 'hspec', 'sydtest' },
        }),
    },
})
