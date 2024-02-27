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
  'Robitx/gp.nvim',
	config = function()
 	-- default command agents (model + persona) 
 	-- name, model and system_prompt are mandatory fields 
 	-- to use agent for chat set chat = true, for command set command = true 
 	-- to remove some default agent completely set it just with the name like: 
 	-- agents = {  { name = "ChatGPT4" }, ... }, 

     local default_config = require('gp.config')
    -- unpack(default_config.agents),
     local agents = {
          -- Disable ChatGPT 3.5
          -- {
          --   name = "ChatGPT3-5",
          --   chat = false,  -- just name would suffice
          --   command = false,   -- just name would suffice
          -- },
          {
            name = "mistral",
            chat = true,
            command = true,
            model = { model = "mistral", temperature = 1.1, top_p = 1 },
            system_prompt = default_config.agents[1].system_prompt
           },

          {
            -- name = "ChatGPT4",
            name = "toto",
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
    }
     -- Voice commands (:GpWhisper*) depend on SoX (Sound eXchange) to handle audio recording and processing:
		require("gp").setup({

         agents = agents,
         chat_agents = agents,
         openai_api_key = os.getenv("OPENAI_API_KEY"),
         -- cmd_prefix = "Gp",
         openai_api_endpoint = "https://api.openai.com/v1/chat/completions",
         -- openai_api_endpoint = "http://localhost:8080/v1/chat/completions",
         -- agents = agents,
         chat_topic_gen_model = 'mistral',
         model = { model = "mistral", temperature = 1.1, top_p = 1 },

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
