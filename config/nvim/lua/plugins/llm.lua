local llm = require('llm')

llm.setup({
    api_token = nil, -- cf Install paragraph
    -- model = 'bigcode/starcoder2-15b', -- the model ID, behavior depends on backend
	--    model = 'bartowski/Code-Llama-3-8B-GGUF:IQ1_M',
	-- model = 'llama2:latest'
	model = 'codellama:7b-code',


    -- model =  "codellama:7b",
    -- model = "meta-llama/Llama-3.1-8B",
    -- backend = 'openai', -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
    backend = 'ollama',
    -- 11434 for ollama
    --

    url = 'http://localhost:11434/api/generate', -- the http url of the backend
    --
    -- url = "http://localhost:11111",

    tokens_to_clear = { '<|endoftext|>' }, -- tokens to remove from the model's output
    -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
    request_body = {
        parameters = {
            max_new_tokens = 60,
            temperature = 0.2,
            top_p = 0.95,
        },
    },
    -- set this if the model supports fill in the middle
    -- fim = {
    --   enabled = true,
    --   prefix = "<fim_prefix>",
    --   middle = "<fim_middle>",
    --   suffix = "<fim_suffix>",
    -- },
    debounce_ms = 150,

    accept_keymap = '<Tab>',
    dismiss_keymap = '<S-Tab>',
    tls_skip_verify_insecure = false,
    -- llm-ls configuration, cf llm-ls section
    lsp = {
        -- ideally it would find it in PATH instead !
        bin_path = '/etc/profiles/per-user/teto/bin/llm-ls',
        -- host = 'localhost',
        -- port = 4567, -- llm-ls --port 4657
        -- or { LLM_LOG_LEVEL = "DEBUG" } to set the log level of llm-ls
        cmd_env = {
            LLM_LOG_LEVEL = 'DEBUG',
            HF_TOKEN_PATH = '/home/teto/.config/sops-nix/secrets/huggingfaceToken',
            -- LLM_NVIM_HF_API_TOKEN_
        },
        -- version = '0.5.3',
    },
    tokenizer = nil, -- cf Tokenizer paragraph
    context_window = 1024, -- max number of tokens for the context window
    enable_suggestions_on_startup = true,
    enable_suggestions_on_files = {'*.lua', '*.nix' }, -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
    disable_url_path_completion = false, -- cf Backend
})
