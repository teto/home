local xdg_config = vim.env.XDG_CONFIG_HOME or os.getenv('HOME') .. '/.config'
local sops_folder = vim.fs.joinpath(xdg_config, 'sops-nix/secrets')

local jedha_default_model
jedha_default_model = 'qwen3.6-dense'

-- print("Loading avante")

local function read_secret(filename)
    local file = io.open(filename, 'r')
    if file == nil then
        return nil
    end

    local value = file:read('*a')
    file:close()

    return vim.trim(value)
end

-- providers in the gp.nvim sense, not to confuse with agents

-- llama_host of the
local function mk_llama_provider(llama_host, name, custom)
    local opts = vim.tbl_extend('force', {
        -- either that or parse_curl_args
        __inherited_from = 'openai',
        model = name,
        hide_in_model_selector = false,
        endpoint = 'http://' .. llama_host .. '/v1',
        -- Timeout in milliseconds. Make it long as server is "slow"
        timeout = 180000,
        -- empty key is required else avante complains
        -- api_key_name = 'LLAMA_API_KEY',
        api_key_name = 'cmd:echo "toto"',
        _shellenv = 'toto',

        -- extra_request_body = {
        --     max_tokens = 4000, -- to avoid infinite loops
        -- },

        -- tools send a shitton of tokens
        -- not supported by mistral (but inherited by others so...)
        -- trying to tweak prompt so we can send fewer tokens !
        prompt_opts = {
            system_prompt = 'you are zulu',
        },
    }, custom)
    return opts
end

-- TODO load configuration from llm-providers.json
-- lua vim.json.decode(str, opts)
opts = {
    acp_providers = {
        ['mistral-vibe-teto'] = {
            command = 'vibe-acp',
            env = {
                -- failed with DBUS_SESSION_BUS_ADDRESS
				MISTRAL_API_KEY = os.getenv('MISTRAL_API_KEY'), -- necessary if you setup Mistral Vibe manually
            },
        },
        -- override the default one because it was missing USER
        ['codex'] = {
            command = 'codex-acp',
            args = {
                -- "-c model="
            },
            env = {
                USER = os.getenv('USER'),
                -- lua print(vim.inspect(require("avante.providers").openai:list_models()))
                -- OPENAI_API_KEY = read_secret(sops_folder .. '/OPENAI_API_KEY_PERSO'),
            },
        },
    },
    providers = {
        azure = nil,

        --      llamacpp = {
        --          -- __inherited_from = 'llamacpp',
        --          -- hide_in_model_selector
        --          -- model = 'ministral3-3b-q4',
        --          -- model = "ministral3-14b",
        --          model = 'mistral-7b',
        --          -- model = 'toto',
        -- -- TODO set qwen
        --          -- model = 'devstral2-24b-iq2',
        --          endpoint = 'http://' .. llama_hostname .. ':8080/v1',
        --          timeout = 10000, -- Timeout in milliseconds
        --          use_ReAct_prompt = false,
        --          -- tools send a shitton of tokens
        --          -- not supported by mistral (but inherited by others so...)
        --          disable_tools = true,
        --          -- empty key is required else avante complains
        --          api_key_name = '',
        --          extra_request_body = {
        --              max_tokens = 4000, -- to avoid infinite loops
        --          },
        --      },

        -- see https://github.com/yetone/avante.nvim/issues/2238
        -- legacy
        -- qwen2.5-coder-7b-instruct-q8
        -- Ministral-3-3B-Instruct
        ['mistral_devstral_2'] = {
            __inherited_from = 'openai',
            -- hide_in_model_selector
            -- model = 'ministral3-3b-q4',
            -- model = 'devstral2-24b-iq2',
            -- model = 'ministral3-14b'
            model = 'devstral-2512',
            endpoint = 'https://api.mistral.ai/v1',
            timeout = 30000, -- Timeout in milliseconds

            -- use_response_api = true,
            api_key_name = 'cmd:cat ' .. sops_folder .. '/mistral_test_api_key',
            -- mandatory to make it work with mistral see
            -- https://github.com/yetone/avante.nvim/discussions/1570#discussioncomment-12600703
            extra_request_body = {
                -- 16384
                max_tokens = 16383, -- to avoid using max_completion_tokens
            },
        },
		mistral  = {

            api_key_name = 'cmd:cat ' .. sops_folder .. '/mistral_test_api_key',
		 -- MISTRAL_API_KEY = os.getenv('MISTRAL_API_KEY'), -- necessary if you setup Mistral Vibe manually
		},

        ['local:mistral-nemo'] = {
            model = 'devstral',
            __inherited_from = 'ollama',
        },
    },
    web_search_engine = {
        -- todo pass key
        -- provider = 'google', -- tavily, serpapi, google, kagi, brave, or searxng
        proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    },
    -- disabled_tools = {
    --     'web_search_tavily',
    -- },
    custom_tools = {
        require('avante.llm_tools.web_search').web_search_google,

        -- {
        --   name = "run_go_tests",  -- Unique name for the tool
        --   description = "Run Go unit tests and return results",  -- Description shown to AI
        --   command = "go test -v ./...",  -- Shell command to execute
        --   param = {  -- Input parameters (optional)
        --     type = "table",
        --     fields = {
        --       {
        --         name = "target",
        --         description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
        --         type = "string",
        --         optional = true,
        --       },
        --     },
        --   },
        --   returns = {  -- Expected return values
        --     {
        --       name = "result",
        --       description = "Result of the fetch",
        --       type = "string",
        --     },
        --     {
        --       name = "error",
        --       description = "Error message if the fetch was not successful",
        --       type = "string",
        --       optional = true,
        --     },
        --   },
        --   func = function(params, on_log, on_complete)  -- Custom function to execute
        --     local target = params.target or "./..."
        --     return vim.fn.system(string.format("go test -v %s", target))
        --   end,
        -- },
    },
    slash_commands = {
        -- it looks ignored ?
        {
            name = 'current_model',
            description = 'Return the current avante model',
            callback = function()
                local Config = require('avante.config')
                return Config.provider
            end,
            details = 'Nothing more',
        },
    },
    prompt_logger = {
        enabled = true, -- toggle logging entirely
        log_dir = vim.fn.stdpath('cache'), -- directory where logs are saved
    },
}

-- todo hide all of them by default ?
local hidden_models = {
    'aihubmix',
    'claude-haiku',
    'claude-opus',
    -- 'copilot',
    -- 'gemini',
    -- 'openai',
    -- 'cerebras',
    'vertex',
    'vertex_claude',
    -- 'ollama',
    'moonshot',
}

-- TODO fix this and add it to FAQ
-- hide_in_model_selector is set but doesn't work with input provider ?!
-- hides everything in hidden_models
for _, model in ipairs(hidden_models) do
    -- vim.print("disabling model ", model)
    opts.providers[model] = { hide_in_model_selector = true, is_env_set = false }
    -- is_env_set
end

local valid_file, nix_deps = pcall(require, 'generated-by-nix')

-- so it inherited the model
local res = mk_llama_provider('jedha:9931', jedha_default_model, {

    -- check default prompt w/o
    disable_tools = false,
})

-- blocks AvanteModels
-- opts.providers['jedha'] = vim.tbl_extend('force', res, {})

-- we can switch jakku_hostname
if valid_file and nix_deps.jakku_hostname or false then
    -- this is weird !
    opts.providers['neokyoto'] = mk_llama_provider(nix_deps.jakku_hostname, jedha_default_model, {
        -- check default prompt w/o
        -- add tools
        disable_tools = true,
        api_key_name = 'cmd:echo "' .. nix_deps.jakku_llama_api_secret .. '"',
    })
else
    -- notify of a failed nix_deps
end

-- for _, model in ipairs(local_models) do
-- opts.providers['gemma-4'] =
--     mk_llama_provider('localhost', 'unsloth/gemma-4-E4B-it-GGUF', { __inherited_from = 'openai' })
-- end

require('avante').setup(opts)
