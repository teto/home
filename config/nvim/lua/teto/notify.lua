local Job = require("plenary.job")

local M = {}

---@return boolean
function M.should_use_provider()
	return vim.fn.executable("notify-send") == 1
end

function M.notify_send(msg, level, opts)
	local l = "low"
	if level == vim.log.levels.WARN then
		l = "normal"
	elseif level == vim.log.levels.ERROR then
		l = "critical"
	end

	-- opts = opts or {}
	-- local title = opts.title
	-- local timeout = opts.timeout

	-- if timeout then
	-- 	vim.list_extend(command, {'-t', string.format('%d', timeout * 1000)})
	-- end

	Job
		:new({
			command = "notify-send",
			args = { "-u", l, "Neovim", msg },
		})
		:start()
end

function M.override_vim_notify()
	vim.notify = M.notify_send
end

return M
