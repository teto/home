return {
    cmd = { 'nil' },
    init_options = {
        nix = {
            flake = {
                autoArchive = true,
                -- auto eval flake inputs for improved completion
                -- generates too many issues
                autoEvalInputs = false,
            },
        },
    },
    settings = {
        formatting = {
            command = { 'nixfmt' },
        },
        -- nix = {
        --  flake = {
        --   autoArchive = true,
        --   -- auto eval flake inputs for improved completion
        --   autoEvalInputs = true,
        --  }
        -- },
        diagnostic = {
            -- // Example: ["unused_binding", "unused_with"]
            ignored = { 'unused_binding', 'unused_with' },
            excludedFiles = {},
        },
    },
	filetypes = { "nix" }
}
