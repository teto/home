-- require('img-clip').setup ({
--   -- use recommended settings from above
-- })
-- require('copilot').setup ({
--   -- use recommended settings from above
-- })
-- require('render-markdown').setup ({
--   -- use recommended settings from above
-- })
require('avante_lib').load()
require('avante').setup({
    provider = 'openai',

	openai = {
	 api_key_name = "cmd:cat /home/teto/.config/sops-nix/secrets/OPENAI_API_KEY_NOVA",
   }
	-- openai_api_key = os.getenv("OPENAI_API_KEY")
})
