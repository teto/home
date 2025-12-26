require('codecompanion').setup({

    secret = { 'bash', '-c', 'cat $XDG_CONFIG_HOME/sops-nix/secrets/claude_api_key' },
    strategies = {
        chat = {
            adapter = 'anthropic',
            model = 'claude-sonnet-4-20250514',
        },
        inline = {
            adapter = 'anthropic',
        },
    },
    adapters = {
        http = {
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
