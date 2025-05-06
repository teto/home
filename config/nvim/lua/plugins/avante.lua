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
    -- provider = 'openai',
   provider = "ollama",

    openai = {
        api_key_name = 'cmd:cat /home/teto/.config/sops-nix/secrets/OPENAI_API_KEY_NOVA',
    },
	ollama = {
	  model = "deepseek-r1:7b"
	  -- model = "qwq:32b",
	}
    -- openai_api_key = os.getenv("OPENAI_API_KEY")
})
