 -- https://codecompanion.olimorris.dev/getting-started#interactions
require('codecompanion').setup({
	  log_level = "DEBUG",

    secret = { 'bash', '-c', 'cat $XDG_CONFIG_HOME/sops-nix/secrets/claude_api_key' },
    interactions = {
        chat = {
            -- adapter = 'anthropic',
            -- model = 'claude-sonnet-4-20250514',
            adapter = 'mistral_cloud',
        },
        inline = {
            adapter = 'mistral_cloud',
        },

    },
    adapters = {
        http = {
            --         mistral_cloud = function()
            -- -- openai ?
            --             return require('codecompanion.adapters').extend('mistral', {
            --                 env = {
            --
            --                     api_key = 'cmd:cat ' .. (vim.fs.joinpath(xdg_config, 'sops-nix/secrets/mistral_test_api_key')),
            --                 },
            --             })
            --         end,      
			--
			--
			mistral_cloud = {
            -- model = 'devstral-2512',
            endpoint = 'https://api.mistral.ai/v1',
            -- timeout = 30000, -- Timeout in milliseconds

			  -- endpoint = "http://localhost:8000/v1", -- Replace with your endpoint                                                     
			  model = "mistral-vibe", -- Or the specific model name   
			};

            openai = function()
                return require('codecompanion.adapters').extend('openai', {
                    env = {
                        api_key = "cmd:bash -c 'cat $XDG_CONFIG_HOME/sops-nix/secrets/claude_api_key'",
                    },
                })
            end,
            anthropic = function()
                return require('codecompanion.adapters').extend('anthropic', {
                    env = {
                        api_key = 'cmd:cat /home/teto/.config/sops-nix/secrets/claude_api_key',
                    },
                })
            end,
        },
    },
})
