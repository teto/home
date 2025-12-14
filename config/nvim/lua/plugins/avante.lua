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

    behaviour = {
        auto_set_keymaps = false,
        enable_token_counting = false,
        -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
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
		  model = "Devstral-Small-2505",
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
})

-- vim.api.nvim_create_user_command('', '!hasktags .', { desc = 'Regenerate tags' })

-- https://github.com/NixOS/nixpkgs/pull/408463
-- require("avante.api").ask()
vim.keymap.set({ 'n', 'v' }, 'F2', function()
    require('avante.api').ask({ without_selection = true })
end, { noremap = true })
