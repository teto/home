local M = {

  child = nil
}

function load_file ()
end

function M:peek(job)
    ya.dbg('chunks plugins called with ' .. tostring(job.file.url))

    ya.preview_widgets(job, { ui.Text('Loading chunks...'):area(job.area):align(ui.Text.RIGHT) })


	local child = M.child
	if not self.child then
	 self.child = Command('view_json')
		 :args({
			 tostring(job.file.url),
		 })
		 :stdout(Command.PIPED)
		 :stderr(Command.PIPED)
		 :spawn()

	 ya.dbg(self.child)
	 if not self.child then
		 -- TODO show stderr ?
		 ya.err('Could not start view_json '..tostring(job.file.url)..': fallback to builtins')
		ya.notify {
			title = "Could not start view_json",
			content = "",
			timeout = 1
			-- level = "info",
		}

		 ya.preview_widgets(job, { ui.Text('fall back to builtins...'):area(job.area) })
		 return self:fallback_to_builtin()
	end


    local limit = job.area.h
    local i, lines = 0, ''
    repeat
        local next, event = child:read_line()
        if event == 1 then
            ya.err('event == 1: falling back to builtins')
            return self:fallback_to_builtin(job)
        elseif event ~= 0 then
            -- event ~= 0
            break
        end

        i = i + 1
        if i > job.skip then
            lines = lines .. next
        end
    until i >= job.skip + limit

    child:start_kill()
    if job.skip > 0 and i < job.skip + limit then
        ya.manager_emit('peek', { math.max(0, i - limit), only_if = tostring(job.file.url), upper_bound = true })
    else
        lines = lines:gsub('\t', string.rep(' ', PREVIEW.tab_size))
        ya.preview_widgets(job, { ui.Text(lines):area(job.area) })
    end
end

-- Copied from yazi-plugins
function M:seek(job) require("code"):seek(job) end

-- function M:seek(job)
--     local h = cx.active.current.hovered
--     if h and h.url == job.file.url then
--         local step = math.floor(job.units * job.area.h / 10)
--         ya.manager_emit('peek', {
--             math.max(0, cx.active.preview.skip + step),
--             only_if = tostring(job.file.url),
--         })
--     end
-- end

function M:fallback_to_builtin(job)
    local _, bound = ya.preview_code(self)
    if bound then
        ya.manager_emit('peek', { bound, only_if = tostring(job.file.url), upper_bound = true })
    end
end

return M
