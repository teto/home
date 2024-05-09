return {
 --{ 'jackMort/ChatGPT.nvim',
 --  -- due to https://github.com/jackMort/ChatGPT.nvim/issues/265
 --   -- commit = "24bcca7",
 --   config = function()
 --    -- passing OPENAI_API_KEY in environment for this to work
 --    -- huge setup at https://github.com/jackMort/ChatGPT.nvim
 --     require("chatgpt").setup({
 --       -- api_key_cmd = "pass show chat.openai.com",
 --       -- see https://github.com/jackMort/ChatGPT.nvim/issues/314
 --       -- api_host_cmd = "echo -n api.openai.com",
 --       -- api_host_cmd = "echo -n '0.0.0.0:3000'"
 --       --
 --       -- with `ollama serve`
 --       -- api_host_cmd = "echo -n http://127.0.0.1:11434"
 --      })
 --   end,
 --},

 {
  -- :GpChatNew
  -- use :GpInspectPlugin to debug
  dir = "~/gp.nvim"
  -- , enabled = false
  , lazy = true
  -- lazy load on command
  -- , cmd = { "GpWhisper" }
  -- 'Robitx/gp.nvim'
  -- , branch = "copilot"
  , config = function()
 	-- default command agents (model + persona) 
 	-- name, model and system_prompt are mandatory fields 
 	-- to use agent for chat set chat = true, for command set command = true 
 	-- to remove some default agent completely set it just with the name like: 
 	-- agents = {  { name = "ChatGPT4" }, ... }, 

     local default_config = require('gp.config')
     -- local agents = 
     -- Voice commands (:GpWhisper*) depend on SoX (Sound eXchange) to handle audio recording and processing:
		require("gp").setup({
-- cd /tmp/gp_whisper && export LC_NUMERIC='C' && sox --norm=-3 rec.wav norm.wav && t=$(sox 'norm.wav' -n channels 1 stats 2>&1 | grep 'RMS lev dB'  | sed -e 's/.* //' | awk '{print $1*1.75}') && sox -q norm.wav -C 196.5 final.mp3 silence -l 1 0.05 $t'dB' -1 1.0 $t'dB' pad 0.1 0.1 tempo 1.75 && curl  --max-time 20 https://api.openai.com/v1/audio/transcriptions -s -H \"Authorization: 
	-- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
	-- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
	-- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
         openai_api_key = os.getenv("OPENAI_API_KEY"),

         hooks = {
           ["Translator"] = function(gp, params)
             local agent = gp.get_command_agent()
             local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
             gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
           end
           -- ["Translator"] = function(gp, params)
           --   local agent = gp.get_command_agent()
           --   local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
           --   gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
           -- end

         },
         agents = {
          -- unpack(default_config.agents),
          -- Disable ChatGPT 3.5
          {
            provider = "openai",
            name = "ChatGPT3-5",
            chat = true,  -- just name would suffice
            command = false,   -- just name would suffice
          },
          {
            provider = "localai",
            name = "Mistral",
            chat = true,
            command = true,
            model = { model = "mistral", temperature = 1.1, top_p = 1 },
            system_prompt = default_config.agents[1].system_prompt
           },
          {

            provider = "openai",
            name = "ChatGPT4",
            -- name = "toto",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
        },
        -- image_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
        image_dir = vim.fn.stdpath("cache").."/gp_images",
        whisper_dir = vim.fn.stdpath("cache").."/gp_whisper",
        whisper_language = "en",

         -- chat_agents = agents,
         -- openai_api_endpoint = "http://localhost:8080/v1/chat/completions",
         -- agents = agents,
         -- chat_topic_gen_model = 'mistral',
         -- model = { model = "mistral", temperature = 1.1, top_p = 1 },

         providers = {
          copilot = {},
          openai = {
           -- response from the config.providers.copilot.secret command { "bash", "-c", "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'" } is empty
            secret = os.getenv("OPENAI_API_KEY"),
          -- cmd_prefix = "Gp",
            endpoint = "https://api.openai.com/v1/chat/completions",
          },
          -- ollama = {},
          localai = {
            endpoint = "http://localhost:11111/v1/chat/completions",
          }

         }

        })
		-- or setup with your own config (see Install > Configuration in Readme)
		-- require("gp").setup(config)

        	-- shortcuts might be setup here (see Usage > Shortcuts in Readme)
	end,
 },
 -- {
 --  "ziontee113/ollama.nvim",
 -- },
 --{
 -- "nomnivore/ollama.nvim",
 --   -- dependencies = {
 --   --     "nvim-lua/plenary.nvim",
 --   --     "MunifTanjim/nui.nvim",
 --   -- },
 --   keys = { },
 --   config = function()
 --      -- TODO add to context menu Ollama
 --      local menu = require'teto.context_menu'
 --      local set_ollama_menu = function()
 --       M.set_rclick_submenu('TetoOllama', 'Ollama', {
 --        { 'Promt           <space>ca', '<space>ca' },
 --        -- { 'Go to Declaration             gD', 'gD' },
 --        -- { 'Go to Definition              gd', 'gd' },
 --        -- { 'Go to Implementation          gI', 'gI' },
 --       })
 --      end
 --      menu.add_component(set_ollama_menu)
 --      -- menu.
 --      -- M.set_rclick_submenu('TetoMenuDap', 'Debug       ', {
 --      --  { 'Show DAP UI           <space>bu', '<space>bu' },
 --      --  { 'Toggle Breakpoint     <space>bb', '<space>bb' },
 --      --  { 'Continue              <space>bc', '<space>bc' },
 --      --  { 'Terminate             <space>bk', '<space>bk' },
 --      -- }, M.buf_has_dap)
 --      --
 --       -- local ollama = require("ollama")
 --       -- ":<c-u>lua require('ollama').prompt()<cr>",
 --       -- ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
 --       -- vim.keymap.set("n", '<C-p>', function() ollama.show() end, {})
 --   end,
 -- }
 -- , 'David-Kunz/gen.nvim'

 -- , {



 --    -- LLMToggleAutoSuggest enables/disables automatic "suggest-as-you-type" suggestions
 --    -- LLMSuggestion is used to manually request a suggestion
 --   'huggingface/llm.nvim',
 --   enabled = false,
 --  opts =  {
 --   tokens_to_clear = { "<EOT>" },
 --   fim = {
 --     enabled = true,
 --     prefix = "<PRE> ",
 --     middle = " <MID>",
 --     suffix = " <SUF>",
 --   },
 --   -- can be overriden via LLM_NVIM_MODEL
 --   model = "codellama/CodeLlama-13b-hf",
 --   debounce_ms = 150,
 --   accept_keymap = "<M+a>",
 --   dismiss_keymap = "<S-Tab>",
 --   context_window = 4096,
 --   tokenizer = {
 --     repository = "codellama/CodeLlama-13b-hf",
 --   },
 --   lsp = {
 --     bin_path = '/nix/store/ngay8qxw0bnirwsnjsk84bdcsbd2q9kc-llm-ls-0.4.0/bin/llm-ls',
 --     -- version = "0.4.0",
 --   },
 --   enable_suggestions_on_startup = false,
 --   enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
 -- }



 --  }
 }
