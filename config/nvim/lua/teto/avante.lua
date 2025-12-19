-- return the Sidebar
-- local s = require'avante.sidebar'
local s = require("avante").get()
-- if not sidebar then return nil, "No sidebar" end

-- if not Utils.is_valid_container(self.containers.result, true) then return end
-- look at transform_result_content / generate_display_content
vim.print(s.containers.result.winid)
