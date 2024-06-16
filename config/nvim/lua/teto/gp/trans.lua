local gp = require('gp')

local M = {}

-- example of adding command which opens new chat dedicated for translation
M.Translator = function(gp, params)
    local agent = gp.get_command_agent()
    local chat_system_prompt = 'You are a Translator, please translate between English and Chinese.'
    gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
end

return M
