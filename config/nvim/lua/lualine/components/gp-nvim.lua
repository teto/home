-- lualine extension for gp.nvim

local lualine_require = require('lualine_require')
local require = lualine_require.require
local modules = lualine_require.lazy_require({
    highlight = 'lualine.highlight',
    utils_notices = 'lualine.utils.notices',
    fn_store = 'lualine.utils.fn_store',
})

-- TODO add a context menu
local on_click_toto = function(_nb_of_clicks, _button, _modifiers)
    vim.notify('builtins GP.nvim')
end

local GpComponent = require('lualine.component'):extend()

GpComponent.default = {}

GpComponent.init = function(self, options)
    GpComponent.super.init(self, options)
    -- self.options.colors = vim.tbl_extend('force', GpComponent.default.colors, self.options.colors or {})

    -- self.options.on_click = on_click_toto
    -- self.on_click_id = modules.fn_store.register_fn(self.component_no, self.options.on_click)
end

GpComponent.update_status = function(_self)
    -- self:update_progress()
    -- return self.progress_message
    local has_gp, gp = pcall(require, 'gp')
    if has_gp then
        return gp._state.chat_agent
    else
        return 'gp.nvim unavailable'
    end
end

-- local function location()
--     -- local line = vim.fn.line('.')
--     -- local col = vim.fn.charcol('.')
--     -- return "GP"
-- end

return GpComponent
