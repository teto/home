-- require('img-clip').setup ({
--   -- use recommended settings from above
-- })
-- require('copilot').setup ({
--   -- use recommended settings from above
-- })
-- require('avante_lib').load()

-- local llama_hostname = 

-- local provider = 'mistral'
-- provider = 'claude'
if vim.fn.hostname() == 'jedha' then
    provider = 'llamacpp'
end

-- overrule both
-- provider = 'llamacpp'
provider = 'codex' -- use acp
-- provider = 'unsloth/gemma-4-E4B-it-GGUF'
-- provider = 'mistral_devstral_2'
-- provider = 'mistral-vibe' -- default acp provider (not upstreamyed yet, might wanna add it there)

local xdg_config = vim.env.XDG_CONFIG_HOME or os.getenv('HOME') .. '/.config'

local sops_folder = vim.fs.joinpath(xdg_config, 'sops-nix/secrets')
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

-- providers in the gp.nvim sense,
-- not to confuse with agents
local providers = {
 openai = {
	-- endpoint = 'http://' .. llama_host .. ':8080/v1',
 },
 claude = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-sonnet-4-5-20250929',
            -- extra_request_body = {
            --   temperature = 0.75,
            --   max_tokens = 4096,
            -- },
            -- should use XDG_CONFIG_HOME or
            api_key_name = 'cmd:cat ' .. sops_folder .. '/claude_api_key',

            -- disabled_tools = { "python" },
        },

}

local function mk_llama_provider(llama_host, name)
    local opts = {
        __inherited_from = 'openai',
        model = name,
        -- hide_in_model_selector
        endpoint = 'http://' .. llama_host .. ':8080/v1',
        -- Timeout in milliseconds. Make it long as server is "slow"
        timeout = 180000, 
        -- parse_curl_args
        -- empty key is required else avante complains
        api_key_name = '',
        -- extra_request_body = {
        --     max_tokens = 4000, -- to avoid infinite loops
        -- },

        -- tools send a shitton of tokens
        -- not supported by mistral (but inherited by others so...)
        disable_tools = false,
        -- trying to tweak prompt so we can send fewer tokens !
        prompt_opts = {
            system_prompt = 'you are zulu',
        },
    }
    return opts
end

-- TODO load configuration from llm-providers.json
-- lua vim.json.decode(str, opts)
opts = {
    debug = true, -- print error messages
    -- log_level =
    log_level = vim.log.levels.DEBUG,

    -- seems ignored by acp ?
    mode = 'legacy', -- Switch from "agentic" to "legacy"

    -- g
    -- instructions_file =

    -- can be a function as well
    -- avante is very talkative by default
    override_prompt_dir = vim.fn.expand(vim.fn.stdpath('config') .. '/avante_prompts'),

    -- can be a function, appended as well
    system_prompt = [[
	You are a highly skilled software engineer with extensive knowledge in many programming languages, frameworks, design patterns, and best practices.

	Respect and use existing conventions, libraries, etc that are already present in the code base.

	Make sure code comments are in English when generating them.
	]],

    -- rules = {
    --   project_dir = nil, ---@type string | nil (could be relative dirpath)
    --   global_dir = nil, ---@type string | nil (absolute dirpath)
    -- },
    rag_service = { -- RAG service configuration
        enabled = false, -- Enables the RAG service
        host_mount = os.getenv('HOME'), -- Host mount path for the RAG service (Docker will mount this path)
        runner = 'nix', -- The runner for the RAG service (can use docker or nix)
        llm = { -- Configuration for the Language Model (LLM) used by the RAG service
            provider = 'claude', -- The LLM provider
            -- endpoint = "https://api.openai.com/v1", -- The LLM API endpoint
            api_key = '', -- The environment variable name for the LLM API key
            -- model = "gpt-4o-mini", -- The LLM model name
            -- extra = nil, -- Extra configuration options for the LLM
        },
        embed = { -- Configuration for the Embedding model used by the RAG service
            provider = 'claude', -- The embedding provider
            -- endpoint = "https://api.openai.com/v1", -- The embedding API endpoint
            api_key = '', -- The environment variable name for the embedding API key
            -- model = "text-embedding-3-large", -- The embedding model name
            extra = nil, -- Extra configuration options for the embedding model
        },
        -- docker_extra_args = "", -- Extra arguments to pass to the docker command
    },
    behaviour = {
        auto_set_keymaps = true,
        auto_suggestions = false, -- Experimental stage

        enable_token_counting = false,
        -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
        auto_focus_on_diff_view = true,
        auto_add_current_file = true,
        -- vs 'popup
        confirmation_ui_style = 'inline_buttons',
        include_generated_by_commit_line = true, -- Controls if 'Generated-by: <provider/model>' line is added to git commit message

        support_paste_from_clipboard = true,
    },

    -- provider = 'claude',
    provider = provider,
    ui = { border = 'single', background_color = '#FF0000' },
    selector = {
        provider = 'fzf_lua',
    },

    -- might be interesting
    input = {
        -- provider =
        --  -- Example: Using snacks.nvim as input provider
        provider = 'snacks', -- "native" | "dressing" | "snacks"
        provider_opts = {
            -- Snacks input configuration
            title = 'Avante Input',
            icon = ' ',
            placeholder = 'Enter your API key...',
        },
    },
    acp_providers = {
        ['mistral-vibe'] = {
            command = 'vibe-acp',
            env = {
                MISTRAL_API_KEY = os.getenv('MISTRAL_API_KEY'), -- necessary if you setup Mistral Vibe manually
            },
        },
        -- override the default one because it was missing USER
        ['codex'] = {
            command = 'codex-acp',
            args = {},
            env = {
                USER = os.getenv('USER'),
                -- useful for
                -- lua print(vim.inspect(require("avante.providers").openai:list_models()))
                -- (in fork only)
                OPENAI_API_KEY = read_secret(sops_folder .. '/OPENAI_API_KEY_PERSO'),
                -- OPENAI_API_KEY = 'cmd:cat ' .. sops_folder .. '/OPENAI_API_KEY_PERSO',
            },
        },
    },
    providers = {
        azure = nil,
        claude = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-sonnet-4-5-20250929',
            -- extra_request_body = {
            --   temperature = 0.75,
            --   max_tokens = 4096,
            -- },
            -- should use XDG_CONFIG_HOME or
            api_key_name = 'cmd:cat ' .. sops_folder .. '/claude_api_key',

            -- disabled_tools = { "python" },
        },

        gemini = {
            api_key_name = 'cmd:cat ' .. sops_folder .. '/gemini_matt_key',
        },
        openai = {
            api_key_name = 'cmd:cat ' .. sops_folder .. '/OPENAI_API_KEY_PERSO',
        },

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

        -- ollama = {
        --     -- model = "qwq:32b",
        --     model = 'mistral',
        --     endpoint = 'http://127.0.0.1:11434',
        --     timeout = 30000, -- Timeout in milliseconds
        --     -- disable_tools = true, -- not supported by mistral (but inherited by others so...)
        --     --   disabled_tools = { "python" }, is also possible
        --     is_env_set = require('avante.providers.ollama').check_endpoint_alive,
        --     extra_request_body = {
        --         options = {
        --             temperature = 0.75,
        --             -- 32768
        --             num_ctx = 20480,
        --             keep_alive = '10m',
        --         },
        --     },
        -- },
        ['local:mistral-nemo'] = {
            model = 'devstral',
            __inherited_from = 'ollama',
        },
    },
    web_search_engine = {
        -- todo pass key
        provider = 'tavily', -- tavily, serpapi, google, kagi, brave, or searxng
        proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    },
    -- ollama = {
    --   model = "deepseek-r1:7b"
    --   -- model = "qwq:32b",
    -- }
    -- openai_api_key = os.getenv("OPENAI_API_KEY")

    windows = {
        position = 'right',
        fillchars = 'eob: ',
        -- TODO remove
        sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = 'center', -- left, center, right for title
            rounded = true,
            include_model = true,
        },
        spinner = {
            generating = { '·', '✢', '✳', '∗', '✻', '✽' },
            thinking = { '🤯', '🙄' },
        },
        input = {
            -- used as sign_define
            -- function H.signs() vim.fn.sign_define("AvanteInputPromptSign", { text = Config.windows.input.prefix }) end
            prefix = '> ',
            height = 8, -- Height of the input window in vertical layout
        },
    },

    ask = {

        floating = false, -- Open the 'AvanteAsk' prompt in a floating window
        start_insert = true, -- Start insert mode when opening the ask window
        border = 'rounded',
        ---@type "ours" | "theirs"
        focus_on_apply = 'ours', -- which diff to focus after applying
    },
    custom_tools = {
        -- {
        --     name = 'run_model_manager_tests', -- Unique name for the tool
        --     description = 'run the ModelManagerSpec',
        --     param = { -- Input parameters (optional)
        --         type = 'table',
        --         fields = {
        --             -- {
        --             --   name = "target",
        --             --   description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
        --             --   type = "string",
        --             --   optional = true,
        --             -- },
        --         },
        --     },
        --     returns = { -- Expected return values
        --         {
        --             name = 'result',
        --             description = 'Result of the fetch',
        --             type = 'string',
        --         },
        --         {
        --             name = 'error',
        --             description = 'Error message if the fetch was not successful',
        --             type = 'string',
        --             optional = true,
        --         },
        --     },
        --     func = function(params, on_log, on_complete) -- Custom function to execute
        --         -- local target = params.target or "./..."
        --         -- Shell command to execute
        --         command = 'nix run .#simwork.model-manager._tests'
        --         return vim.fn.system(command)
        --     end,
        -- },

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

    -- custom_tools
    -- slash_commands =

    -- mappings = {
    -- submit = {
    --   normal = "<CR>",
    --   insert = "<C-s>",
    -- },
    -- }
}

local hidden_models = {
    'aihubmix',
    'copilot',
    'gemini',
    'openai',
    'openai-gpt-4o-mini',
    'vertex',
    'vertex_claude',
    'ollama',
    'moonshot',
}

-- hides everything in hidden_models
for _, model in ipairs(hidden_models) do
    opts.providers[model] = { hide_in_model_selector = true, is_env_set = false }
    -- is_env_set
end

-- todo load from contrib/ or from llama api ?
local jedha_models = {
    'llama_mistral7b',
    'llama_ministral3_3b',
    'llama_ministral3_8b',
    'llama_qwen2_5_3b',
}


for _, model in ipairs(jedha_models) do
    opts.providers[model] = mk_llama_provider('jedha.local', jedha_models)
end

local local_models = {
  'unsloth/gemma-4-E4B-it-GGUF'
}
for _, model in ipairs(local_models) do
    opts.providers[model] = mk_llama_provider("localhost", model)
end

require('avante').setup(opts)
