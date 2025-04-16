local none_ls = require('null-ls')

-- none_ls.register(require("none-ls-luacheck.diagnostics.luacheck"))
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
-- none_ls.builtins.diagnostics.shellcheck.with({
-- For diagnostics sources, you can change the format of diagnostic messages by setting diagnostics_format:
-- diagnostic_config = {
-- -- see :help vim.diagnostic.config()
-- underline = true,
-- virtual_text = false,
-- signs = true,
-- update_in_insert = false,
-- severity_sort = true,
-- },
-- }),

-- `:NullLsLog`
none_ls.setup({
    debug = true,

    sources = {
        -- method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
        -- needs a luacheck in PATH
        -- none_ls.none-ls-luacheck.diagnostics.luacheck.with({
        -- TODO require none-ls-luacheck
        -- require("none-ls-luacheck.diagnostics.luacheck").with({
        --  extra_args = { '--ignore 21/_.*' }
        -- }),
        require('none-ls-shellcheck.diagnostics'),
        require('none-ls-shellcheck.code_actions'),

        -- none_ls.builtins.diagnostics.editorconfig_checker, -- too noisy
        -- none_ls.builtins.diagnostics.tsc,
        -- doc at https://yamllint.readthedocs.io/en/stable/configuration.html#default-configuration
		-- yamllint creates errors about "warning" vs "error"
        -- none_ls.builtins.diagnostics.yamllint,
        -- .with({
        --  extra_args = { }
        -- }),
        -- require'none-ls.diagnostics.flake8', -- not builtins anymore
        none_ls.builtins.diagnostics.zsh,

        -- use with vim.lsp.buf.format()
        none_ls.builtins.formatting.black,
        none_ls.builtins.formatting.just,
        none_ls.builtins.formatting.yamlfmt, -- from google
        none_ls.builtins.formatting.prettier,
        -- none_ls.builtins.formatting.markdown_toc,
        -- none_ls.builtins.formatting.nixpkgs_fmt,
        none_ls.builtins.formatting.treefmt.with({
            -- treefmt requires a config file
            condition = function(utils)
                return utils.root_has_file('treefmt.toml')
            end,
        }),
    },
})
