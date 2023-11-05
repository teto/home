return {
 {
  'nvim-orgmode/orgmode',
   event = 'VeryLazy',
  config = function ()
   require('orgmode').setup_ts_grammar()
   require('orgmode').setup{
      org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
      org_default_notes_file = '~/orgmode/refile.org',
      -- TODO add templates
      org_agenda_templates = {
       t = { description = 'Task', template = '* TODO %?\n  %u' }
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
     langs = { "python", "lua", "bash" },

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
