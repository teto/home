-- AvanteModels
-- return the Sidebar
-- local s = require'avante.sidebar'
local s = require('avante').get()
-- if not sidebar then return nil, "No sidebar" end

-- if not Utils.is_valid_container(self.containers.result, true) then return end
-- look at transform_result_content / generate_display_content
-- vim.print(s.containers.result.winid)

local M = {}

function M.provider_list_available_models()
end


function M.setup_autocmd()
 -- the prompt is long with tools, look at get_ReAct_system_prompt()
 -- add_text_message
 -- look for base_body.tools
 vim.api.nvim_create_autocmd({ 'User' }, {
	 pattern = 'AvanteViewBufferUpdated',
	 desc = 'display provider statistics in statusline',
	 callback = function(args)
		 -- print("Called matt's on_attach autocmd")
		 -- if not (args.data and args.data.client_id) then
		 --     return
		 -- end

		 vim.print('received args ')
		 vim.print(args)
	 end,
 })
 -- "AvanteViewBufferUpdated"
 -- vim.api.nvim_create_user_command('', '!hasktags .', { desc = 'Regenerate tags' })

 -- https://github.com/NixOS/nixpkgs/pull/408463
 -- require("avante.api").ask()
 vim.keymap.set({ 'n', 'v' }, 'F2', function()
	 require('avante.api').ask({ without_selection = true })
 end, { noremap = true })

end

return M
