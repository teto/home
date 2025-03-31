require("codecompanion").setup({


secret = { 'bash', '-c', 'cat $XDG_CONFIG_HOME/sops-nix/secrets/OPENAI_API_KEY_NOVA' },

 adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key =  "cmd:bash -c 'cat $XDG_CONFIG_HOME/sops-nix/secrets/OPENAI_API_KEY_NOVA'",
        },
      })
    end,
  },

})
