-- require('img-clip').setup ({
--   -- use recommended settings from above
-- })
-- require('copilot').setup ({
--   -- use recommended settings from above
-- })
-- require('render-markdown').setup ({
--   -- use recommended settings from above
-- })
-- require('avante_lib').load()

local llama_hostname = "jedha.local"
-- local llama_hostname = "localhost"

-- TODO load configuration from llm-providers.json
-- lua vim.json.decode(str, opts)
require('avante').setup({
    debug = true, -- print error messages

	-- can be a function as well
	-- avante is very talkative by default
	override_prompt_dir = vim.fn.expand(vim.fn.stdpath('config').."/avante_prompts"),
	-- system_prompt = "";
  -- rules = {
  --   project_dir = nil, ---@type string | nil (could be relative dirpath)
  --   global_dir = nil, ---@type string | nil (absolute dirpath)
  -- },
  rag_service = { -- RAG service configuration
    enabled = false, -- Enables the RAG service
    host_mount = os.getenv("HOME"), -- Host mount path for the RAG service (Docker will mount this path)
    runner = "nix", -- The runner for the RAG service (can use docker or nix)
    llm = { -- Configuration for the Language Model (LLM) used by the RAG service
      provider = "claude", -- The LLM provider
      -- endpoint = "https://api.openai.com/v1", -- The LLM API endpoint
      api_key = "", -- The environment variable name for the LLM API key
      -- model = "gpt-4o-mini", -- The LLM model name
      -- extra = nil, -- Extra configuration options for the LLM
    },
    embed = { -- Configuration for the Embedding model used by the RAG service
      provider = "claude", -- The embedding provider
      -- endpoint = "https://api.openai.com/v1", -- The embedding API endpoint
      api_key = "", -- The environment variable name for the embedding API key
      -- model = "text-embedding-3-large", -- The embedding model name
      extra = nil, -- Extra configuration options for the embedding model
    },
    -- docker_extra_args = "", -- Extra arguments to pass to the docker command
  },
    behaviour = {
        auto_set_keymaps = false,
        enable_token_counting = false,
        -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
		-- support_paste_from_clipboard
		auto_focus_on_diff_view = true,
		auto_add_current_file = true,
		-- vs 'popup
		confirmation_ui_style = "inline_buttons",

    },

    -- provider = 'claude',
    provider = 'llamacpp',
    ui = { border = 'single', background_color = '#FF0000' },
    -- provider = "ollama",

    selector = {
        provider = 'fzf_lua',
    },
    input = {
        -- provider =
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
            api_key_name = 'cmd:cat /home/teto/.config/sops-nix/secrets/claude_api_key',
        },

        gemini = {
            api_key_name = 'cmd:cat /home/teto/.config/sops-nix/secrets/gemini_matt_key',
        },
        -- openai = {
        -- api_key_name = 'cmd:cat /home/teto/.config/sops-nix/secrets/OPENAI_API_KEY_NOVA',
        -- },

		-- see https://github.com/yetone/avante.nvim/issues/2238
		llamacpp = {
		  __inherited_from = "openai",
		  -- model = "",
		  -- ministral-3B-Instruct-2512
		  -- 
-- I srv   load_models:     Llama3.2-3B-Esper2.Q4_K_M
-- I srv   load_models:     Ministral-3-14B-Base-2512.Q6_K
-- I srv   load_models:     ggml-org_Qwen2.5-Coder-3B-Q8_0-GGUF_qwen2.5-coder-3b-q8_0
-- I srv   load_models:     mistral-7b-openorca.Q6_K
-- I srv   load_models:     mistralai/Ministral-3-3B-Instruct-2512-GGUF
-- I srv   load_models:     mistralai_Devstral-Small-2-24B-Instruct-2512-IQ2_M
		  model = "mistralai/Ministral-3-3B-Instruct-2512-GGUF",
		  -- model = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf",
		  endpoint = 'http://'..llama_hostname..':8080/v1',
		  timeout = 30000, -- Timeout in milliseconds

		  -- tools send a shitton of tokens
		  -- not supported by mistral (but inherited by others so...)
		  disable_tools = true,

		  -- empty key is required else avante complains
		  api_key_name = '',
		  extra_request_body = {
			max_tokens = 1000, -- to avoid infinite loops
		  }
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
        ['ollama:devstral'] = {
            model = 'devstral',
            __inherited_from = 'ollama',
        },
        ['ollama/codegemma'] = {
            model = 'codegemma',
            -- doesn't support tools apparently ?
            __inherited_from = 'ollama',
        },
        ['ollama/qwen'] = {
            model = 'qwen2.5-coder',
            __inherited_from = 'ollama',
        },
    },
    -- ollama = {
    --   model = "deepseek-r1:7b"
    --   -- model = "qwq:32b",
    -- }
    -- openai_api_key = os.getenv("OPENAI_API_KEY")

    windows = {
    position = "right",
    fillchars = "eob: ",
	-- TODO remove
    sidebar_header = {
      enabled = false, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
	spinner = {
      generating = { "·", "✢", "✳", "∗", "✻", "✽" },
      thinking = { "🤯", "🙄" },

	},
    input = {
	 -- used as sign_define
	 -- function H.signs() vim.fn.sign_define("AvanteInputPromptSign", { text = Config.windows.input.prefix }) end
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    }
    },

	 ask = {

		 floating = false, -- Open the 'AvanteAsk' prompt in a floating window
		 start_insert = true, -- Start insert mode when opening the ask window
		 border = 'rounded',
		 ---@type "ours" | "theirs"
		 focus_on_apply = 'ours', -- which diff to focus after applying
	 },
    custom_tools = {
        {
            name = 'run_model_manager_tests', -- Unique name for the tool
            description = 'run the ModelManagerSpec', -- Description shown to AI
            param = { -- Input parameters (optional)
                type = 'table',
                fields = {
                    -- {
                    --   name = "target",
                    --   description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                    --   type = "string",
                    --   optional = true,
                    -- },
                },
            },
            returns = { -- Expected return values
                {
                    name = 'result',
                    description = 'Result of the fetch',
                    type = 'string',
                },
                {
                    name = 'error',
                    description = 'Error message if the fetch was not successful',
                    type = 'string',
                    optional = true,
                },
            },
            func = function(params, on_log, on_complete) -- Custom function to execute
                -- local target = params.target or "./..."
                -- Shell command to execute
                command = 'nix run .#simwork.model-manager._tests'
                return vim.fn.system(command)
            end,
        },

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
	  log_dir = vim.fn.stdpath("cache"), -- directory where logs are saved
	},

	-- disabled_tools = { "python" },
	-- custom_tools
	-- slash_commands = 
})

-- vim.api.nvim_create_user_command('', '!hasktags .', { desc = 'Regenerate tags' })

-- https://github.com/NixOS/nixpkgs/pull/408463
-- require("avante.api").ask()
vim.keymap.set({ 'n', 'v' }, 'F2', function()
    require('avante.api').ask({ without_selection = true })
end, { noremap = true })
