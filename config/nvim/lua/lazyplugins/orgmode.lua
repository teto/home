return {
 {
  -- todo pass the branch with tangle implemetend
  -- https://github.com/nvim-orgmode/orgmode/pull/617
  'nvim-orgmode/orgmode',
  --
  -- otherwise we get 
  --[orgmode] Cannot detect parser revision.                                                                                                                                                                                                                        
 -- Please check your org grammar's install info.                                                                                                                                                                                                                   
 -- Maybe you forgot to call "require('orgmode').setup_ts_grammar()" before setup.   
 -- maybe it should be checked/ init only for org files.
   -- event = 'VeryLazy',
  config = function ()
   require('orgmode').setup_ts_grammar()
   require('orgmode').setup{
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' },
      },
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
    -- ft = "norg",
    dependencies = {
    --   -- { "pritchett/neorg-capture"},
    --   -- { 'max397574/neorg-kanban' },
    }
 },
 {
  -- a plugin for neorg
  -- use with :Neorg exec cursor
  'laher/neorg-exec'
 },

}
