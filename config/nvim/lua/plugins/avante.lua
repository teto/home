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
require('avante').setup({
  debug = false, -- print error messages
  behaviour = {
   auto_set_keymaps = false,
   enable_token_counting = false,
   -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
  },
    provider = 'openai',
    ui = { border = 'single', background_color = '#FF0000' },
   -- provider = "ollama",

   selector = {
	provider = "fzf_lua",
   },
   input = {
	-- provider = 
   },
   providers = {
	azure = nil,
	 openai = {
		 api_key_name = 'cmd:cat /home/teto/.config/sops-nix/secrets/OPENAI_API_KEY_NOVA',
	 },
    ollama = {
	  model = "mistral",
      endpoint = "http://127.0.0.1:11434",
      timeout = 30000, -- Timeout in milliseconds
	  -- disable_tools = true, -- not supported by mistral (but inherited by others so...)
	  --   disabled_tools = { "python" }, is also possible

      extra_request_body = {
        options = {
          temperature = 0.75,
          num_ctx = 20480,
          keep_alive = "5m",
        },
      },
    },
	["ollama:devstral"] = {
	 model = "devstral",
	 __inherited_from = 'ollama',
    },
	["ollama:codegemma"] = {
	  model = "codegemma",
	  __inherited_from = 'ollama',
    }
   },
	-- ollama = {
	--   model = "deepseek-r1:7b"
	--   -- model = "qwq:32b",
	-- }
    -- openai_api_key = os.getenv("OPENAI_API_KEY")

   windows = {
	 ask = {
	   floating = false, -- Open the 'AvanteAsk' prompt in a floating window
	   start_insert = true, -- Start insert mode when opening the ask window
	   border = "rounded",
	   ---@type "ours" | "theirs"
	   focus_on_apply = "ours", -- which diff to focus after applying
	 },

	},
	 custom_tools = {
	   {
	     name = "run_model_manager_tests",  -- Unique name for the tool
	     description = "run the ModelManagerSpec",  -- Description shown to AI
	     param = {  -- Input parameters (optional)
	       type = "table",
	       fields = {
	         -- {
	         --   name = "target",
	         --   description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
	         --   type = "string",
	         --   optional = true,
	         -- },
	       },
	     },
	     returns = {  -- Expected return values
	       {
	         name = "result",
	         description = "Result of the fetch",
	         type = "string",
	       },
	       {
	         name = "error",
	         description = "Error message if the fetch was not successful",
	         type = "string",
	         optional = true,
	       },
	     },
	     func = function(params, on_log, on_complete)  -- Custom function to execute
	       -- local target = params.target or "./..."
		   -- Shell command to execute
		   command = "nix run .#simwork.model-manager._tests"
	       return vim.fn.system(command)
	     end,
	   }

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
          name = "current_model",
          description = "Return the current avante model",
          callback = function ()
     local Config = require("avante.config")
     return Config.provider
    end,
          details = "Nothing more"
        }

  }

})

-- vim.api.nvim_create_user_command('', '!hasktags .', { desc = 'Regenerate tags' })

-- https://github.com/NixOS/nixpkgs/pull/408463
-- require("avante.api").ask()
  vim.keymap.set({ "n", "v" }, "F2", 
   function()
	require("avante.api").ask({ without_selection = true; })
   end,
   { noremap = true })

