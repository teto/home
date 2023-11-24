return {
 {
  -- todo pass the branch with tangle implemetend
  -- https://github.com/nvim-orgmode/orgmode/pull/617
  'nvim-orgmode/orgmode',
   event = 'VeryLazy',
  config = function ()
   require('orgmode').setup_ts_grammar()
   require('orgmode').setup{
      org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
      org_default_notes_file = '~/home/refile.org',
      -- TODO add templates
      org_agenda_templates = {
       t = { description = 'Task', template = '* TODO %?\n  %u' }
      },
      -- check lua/orgmode/config/defaults.lua to see their list
      mappings = {
       disable_all = false,
        -- global = {
        -- }
      },
      emacs_config = {
        -- why is it needed ?
        executable_path = 'emacs',
        config_path = '$HOME/.emacs.d/init.el',
      },
      ui = {
       -- wtf is that ?
        menu = {
          handler = nil,
        },
      },

   }

  end
  -- <Leader>oa
    -- Open agenda prompt: <Leader>oa
    -- Open capture prompt: <Leader>oc
    -- In any orgmode buffer press g? for help

  -- keys = 

 },
 {
  -- https://github.com/mrshmllow/orgmode-babel.nvim 
  -- -- commands are :OrgExecute or :OrgTangle 
  -- requires emacs
    'mrshmllow/orgmode-babel.nvim',
    cmd = { "OrgExecute", "OrgTangle" },
    opts = {
     -- by default, none are enabled
     langs = { "python", "lua", "shell" },

     -- paths to emacs packages to additionally load
     load_paths = {}
   }
 },

 {
    "nvim-neorg/neorg",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.keybinds"] = {
            config = {
                default_keybinds = true,
            }
          },
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.ui.calendar"] = {},
          -- ['core.ui.calendar'] = {}, -- fails on stable nvim
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
                home = "~/home",
                work = "~/nova/norg"
                -- notes = "~/Nextcloud/Notes",
              },
              default_workspace = "notes"
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
