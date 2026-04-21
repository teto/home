-- https://codecompanion.olimorris.dev/getting-started#interactions
-- look in tests/config.lua for example
require('codecompanion').setup({
    opts = {
        log_level = 'DEBUG',
    },
    prompt_library = {

        -- markdown = {
        --   dirs = {},
        -- },

        ['Test Cursor'] = {
            strategy = 'chat',
            description = 'Test cursor position',
            opts = {
                alias = 'test_cursor',
                auto_submit = false,
            },
            prompts = {
                {
                    role = 'user',
                    content = 'Test',
                },
            },
        },
    },
    display = { action_palette = { opts = { show_preset_prompts = false } } },

    secret = { 'bash', '-c', 'cat $XDG_CONFIG_HOME/sops-nix/secrets/claude_api_key' },
    interactions = {
        chat = {
            -- adapter = 'anthropic',
            -- model = 'claude-sonnet-4-20250514',
            -- adapter = 'mistral_cloud',
            adapter = 'mistral_vibe',
        },
        inline = {
            adapter = 'mistral_vibe',
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
                -- model = "mistral-vibe", -- Or the specific model name
            },

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
