return {
--   "jghauser/papis.nvim",
--   after = { "telescope.nvim", "nvim-cmp" },
--   requires = {
--     "kkharji/sqlite.lua",
--     "nvim-lua/plenary.nvim",
--     "MunifTanjim/nui.nvim",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   rocks = {
--     {
--       "lyaml"
--       -- If using macOS or Linux, you may need to install the `libyaml` package.
--       -- If you install libyaml with homebrew you will need to set the YAML_DIR
--       -- to the location of the homebrew installation of libyaml e.g.
--       -- env = { YAML_DIR = '/opt/homebrew/Cellar/libyaml/0.2.5/' },
--     }
--   },
--   config = function()
--     require("papis").setup(
--     -- Your configuration goes here
--     )
--   end,
-- })
-- use { 'ldelossa/gh.nvim',
--     requires = { { 'ldelossa/litee.nvim' } },
-- 	config = function ()
-- 		require('litee.lib').setup({
-- 			-- this is where you configure details about your panel, such as
-- 			-- whether it toggles on the left, right, top, or bottom.
-- 			-- leaving this blank will use the defaults.
-- 			-- reminder: gh.nvim uses litee.lib to implement core portions of its UI.
-- 		})
-- 		require('litee.gh').setup({
-- 			-- this is where you configure details about gh.nvim directly relating
-- 			-- to GitHub integration.
-- 		})

-- 	end
--   }
}
