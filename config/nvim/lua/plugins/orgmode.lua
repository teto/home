-- local M = {}
--
-- otherwise we get
--[orgmode] Cannot detect parser revision.
-- Please check your org grammar's install info.
-- maybe it should be checked/ init only for org files.
-- event = 'VeryLazy',
-- <Leader>oa
-- Open agenda prompt: <Leader>oa
-- Open capture prompt: <Leader>oc
-- In any orgmode buffer press g? for help

-- M.setup = function()
    require('orgmode').setup({
        highlight = {
            enable = false,
            additional_vim_regex_highlighting = { 
			 -- 'org'
			},
        },
        org_capture_templates = { '~/nextcloud/org/*', '~/orgmode/**/*' },
        org_default_notes_file = '~/home/refile.org',
        -- TODO add templates
        org_agenda_templates = {
            t = { description = 'Task', template = '* TODO %?\n  %u' },
        },
        -- check lua/orgmode/config/defaults.lua to see their list
        mappings = {
            disable_all = true,
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
    })
end

-- return M
