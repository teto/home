-- lua require'gp.setup'

-- default command agents (model + persona)
-- name, model and system_prompt are mandatory fields
-- to use agent for chat set chat = true, for command set command = true
-- to remove some default agent completely set it just with the name like:
-- agents = {  { name = "ChatGPT4" }, ... },

local defaults = require('gp.defaults')

local default_chat_system_prompt = defaults.chat_system_prompt
local chat_system_prompt = default_chat_system_prompt
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

vim.g.gp_nvim = {
    agents = {
        -- unpack(default_config.agents),
        -- Disable ChatGPT 3.5
        {
            provider = 'localai',
            name = 'Mistral',
            chat = true,
            command = true,
            model = { model = 'mistral', temperature = 1.1, top_p = 1 },
            system_prompt = chat_system_prompt,
            -- system_prompt = default_config.agents[1].system_prompt
            -- Gp: Agent Mistral is missing model or system_prompt
            -- If you want to disable an agent, use: { name = 'Mistral', disable = true },
        },
        -- {
        --
        --   provider = "openai",
        --   name = "ChatGPT4",
        --   -- name = "toto",
        --   chat = true,
        --   command = true,
        --   -- string with model name or table with model name and parameters
        --   model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
        --   -- system prompt (use this to specify the persona/role of the AI)
        --   system_prompt = "You are a general AI assistant.\n\n"
        --  .. "The user provided the additional info about how they would like you to respond:\n\n"
        --  .. "- If you're unsure don't guess and say you don't know instead.\n"
        --  .. "- Ask question if you need clarification to provide better answer.\n"
        --  .. "- Think deeply and carefully from first principles step by step.\n"
        --  .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        --  .. "- Use Socratic method to improve your thinking and coding skills.\n"
        --  .. "- Don't elide any code from your output if the answer requires coding.\n"
        --  .. "- Take a deep breath; You've got this!\n",
        -- },
    },
    -- image_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
    image = {
        store_dir = vim.fn.stdpath('cache') .. '/gp_images',
    },
    whisper = {
        store_dir = vim.fn.stdpath('cache') .. '/gp_whisper',
        language = 'en',
    },

    -- chat_agents = agents,
    -- openai_api_endpoint = "http://localhost:8080/v1/chat/completions",
    -- agents = agents,
    -- chat_topic_gen_model = 'mistral',
    -- model = { model = "mistral", temperature = 1.1, top_p = 1 },

    providers = {
        copilot = {},
        openai = {
            -- response from the config.providers.copilot.secret command { "bash", "-c", "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'" } is empty
            secret = { "bash" , "-c", "cat $XDG_CONFIG_HOME/sops-nix/secrets/OPENAI_API_KEY" },
			-- secret = os.getenv('OPENAI_API_KEY'),
            endpoint = 'https://api.openai.com/v1/chat/completions',
        },
        -- ollama = {},
        localai = {
            secret = '',
            endpoint = 'http://localhost:11111/v1/chat/completions',
        },
        googleai = {
            endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}',
            secret = os.getenv('GOOGLEAI_API_KEY'),
        },

        anthropic = {
            endpoint = 'https://api.anthropic.com/v1/messages',
            secret = os.getenv('ANTHROPIC_API_KEY'),
        },
    },
}

-- local agents =
-- Voice commands (:GpWhisper*) depend on SoX (Sound eXchange) to handle audio recording and processing:
local final_config = vim.tbl_extend('error', vim.g.gp_nvim, {
    -- cd /tmp/gp_whisper && export LC_NUMERIC='C' && sox --norm=-3 rec.wav norm.wav && t=$(sox 'norm.wav' -n channels 1 stats 2>&1 | grep 'RMS lev dB'  | sed -e 's/.* //' | awk '{print $1*1.75}') && sox -q norm.wav -C 196.5 final.mp3 silence -l 1 0.05 $t'dB' -1 1.0 $t'dB' pad 0.1 0.1 tempo 1.75 && curl  --max-time 20 https://api.openai.com/v1/audio/transcriptions -s -H \"Authorization:
    -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
    -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
    -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},

    hooks = {
        ['Translator'] = function(gp, params)
            local agent = gp.get_command_agent()
            -- local chat_system_prompt = 'You are a Translator, please translate between English and Chinese.'
            gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        end,
        -- ["Translator"] = function(gp, params)
        --   local agent = gp.get_command_agent()
        --   local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
        --   gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        -- end
    },
})

-- TODO merge here
require('gp').setup(final_config)

-- or setup with your own config (see Install > Configuration in Readme)
-- require("gp").setup(config)

-- shortcuts might be setup here (see Usage > Shortcuts in Readme)
vim.keymap.set('n', '<F2>', '<Cmd>GpChatToggle<CR>', { desc = 'Toggle gp.nvim chat' })
