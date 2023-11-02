return {
 {
  -- https://github.com/mrshmllow/orgmode-babel.nvim 
  -- -- commands are :OrgExecute or :OrgTangle 
  -- requires emacs
    'mrshmllow/orgmode-babel.nvim'
 },
 {
    "nvim-neorg/neorg",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ['core.ui.calendar'] = {},
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
                -- notes = "~/Nextcloud/Notes",
              },
            },
          },
          -- needs neorg-exec plugin
          ["external.exec"] = {},
        },
      }
    end,
 },
 {
  -- a plugin for neorg
  -- use with :Neorg exec cursor
  'laher/neorg-exec'
 }
}
