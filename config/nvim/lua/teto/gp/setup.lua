-- default command agents (model + persona)
-- name, model and system_prompt are mandatory fields
-- to use agent for chat set chat = true, for command set command = true
-- to remove some default agent completely set it just with the name like:
-- agents = {  { name = "ChatGPT4" }, ... },

local defaults = require('gp.defaults')

local default_chat_system_prompt = defaults.chat_system_prompt
-- default_chat_system_prompt = 'You are a general AI assistant.\n\n'
--     .. 'The user provided the additional info about how they would like you to respond:\n\n'
--     .. "- If you're unsure don't guess and say you don't know instead.\n"
--     .. '- Ask question if you need clarification to provide better answer.\n'
--     .. '- Think deeply and carefully from first principles step by step.\n'
--     .. '- Zoom out first to see the big picture and then zoom in to details.\n'
--     .. '- Use Socratic method to improve your thinking and coding skills.\n'
--     .. "- Don't elide any code from your output if the answer requires coding.\n"
--     .. "- Take a deep breath; You've got this!\n"

-- while I am working on the transition, we can refer to vim.g.gp_nvim in setup

-- vim.g.gpt_prompt

-- local agents =
-- Voice commands (:GpWhisper*) depend on SoX (Sound eXchange) to handle audio recording and processing:
local final_config = vim.tbl_extend('error', vim.g.gp_nvim, {
    -- cd /tmp/gp_whisper && export LC_NUMERIC='C' && sox --norm=-3 rec.wav norm.wav && t=$(sox 'norm.wav' -n channels 1 stats 2>&1 | grep 'RMS lev dB'  | sed -e 's/.* //' | awk '{print $1*1.75}') && sox -q norm.wav -C 196.5 final.mp3 silence -l 1 0.05 $t'dB' -1 1.0 $t'dB' pad 0.1 0.1 tempo 1.75 && curl  --max-time 20 https://api.openai.com/v1/audio/transcriptions -s -H \"Authorization:
    -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
    -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
    -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
    -- openai_api_key = os.getenv("OPENAI_API_KEY"),

    hooks = {
        ['Translator'] = function(gp, params)
            local agent = gp.get_command_agent()
            local chat_system_prompt = 'You are a Translator, please translate between English and Chinese.'
            gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        end,
        -- ["Translator"] = function(gp, params)
        --   local agent = gp.get_command_agent()
        --   local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
        --   gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        -- end
    },
})
require('gp').setup(final_config)

-- or setup with your own config (see Install > Configuration in Readme)
-- require("gp").setup(config)

-- shortcuts might be setup here (see Usage > Shortcuts in Readme)
vim.keymap.set('n', '<F2>', '<Cmd>GpChatToggle<CR>', { desc = 'Toggle gp.nvim chat' })
