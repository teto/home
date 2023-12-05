return {
 { 'jackMort/ChatGPT.nvim',
   -- due to https://github.com/jackMort/ChatGPT.nvim/issues/265
    -- commit = "24bcca7",
    config = function()
     -- passing OPENAI_API_KEY in environment for this to work
     -- huge setup at https://github.com/jackMort/ChatGPT.nvim
      require("chatgpt").setup({
        -- api_key_cmd = "pass show chat.openai.com",
        -- see https://github.com/jackMort/ChatGPT.nvim/issues/314
        -- api_host_cmd = "echo -n api.openai.com",
        -- api_host_cmd = "echo -n '0.0.0.0:3000'"
        --
        -- with `ollama serve`
        -- api_host_cmd = "echo -n http://127.0.0.1:11434"
       })
    end,
 },

 {
    "ziontee113/ollama.nvim",
    -- dependencies = {
    --     "nvim-lua/plenary.nvim",
    --     "MunifTanjim/nui.nvim",
    -- },
    keys = { },
    config = function()
        local ollama = require("ollama")
        vim.keymap.set("n", '<C-p>', function() ollama.show() end, {})
    end,
  }
 , 'David-Kunz/gen.nvim'

 , {



    -- LLMToggleAutoSuggest enables/disables automatic "suggest-as-you-type" suggestions
    -- LLMSuggestion is used to manually request a suggestion
   'huggingface/llm.nvim',
   enabled = false,
  opts =  {
   tokens_to_clear = { "<EOT>" },
   fim = {
     enabled = true,
     prefix = "<PRE> ",
     middle = " <MID>",
     suffix = " <SUF>",
   },
   -- can be overriden via LLM_NVIM_MODEL
   model = "codellama/CodeLlama-13b-hf",
   debounce_ms = 150,
   accept_keymap = "<M+a>",
   dismiss_keymap = "<S-Tab>",
   context_window = 4096,
   tokenizer = {
     repository = "codellama/CodeLlama-13b-hf",
   },
   lsp = {
     bin_path = '/nix/store/ngay8qxw0bnirwsnjsk84bdcsbd2q9kc-llm-ls-0.4.0/bin/llm-ls',
     -- version = "0.4.0",
   },
   enable_suggestions_on_startup = false,
   enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
 }



  }
 }
