return {
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
   'huggingface/llm.nvim' 
  -- , config = function ()
  , opts =  {
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
