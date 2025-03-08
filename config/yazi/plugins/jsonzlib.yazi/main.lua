-- ~/.config/yazi/plugins/test.yazi/init.lua

local M = {}

function M:peek(job)
    -- ya.notify {
    --     title = "jsonzlib plugin enabled",
    --     content = "YO",
    --     timeout = 3
    --     -- level = "info",
    -- }
    ya.dbg('Called with ' .. tostring(job.file.url))

    -- see https://github.com/sxyazi/yazi/pull/1033 for an example on how to parse
    local temp_lines = { ui.Line('Loading jsonzlib...') }
    ya.preview_widgets(job, { ui.Text(temp_lines):area(job.area, ui.Text.RIGHT) })
    local pigz = Command('pigz')
        :args({
            '-dc',
            tostring(job.file.url),
        })
        :stdout(Command.PIPED)
        -- :stderr(Command.PIPED)
        :spawn()

    -- local echo = Command("echo"):arg("Hello"):stdout(Command.PIPED):spawn()

    local pretty = Command('jq'):arg("'.'"):stdin(pigz:take_stdout()):stdout(Command.PIPED):spawn()

    -- ya.err(pretty.stdout)

    -- TODO pipe with jq to prettify it
    local limit = job.area.h
    local i, lines = 0, ''
    repeat
        local next, event = pretty:read_line()
        ya.dbg('READLINE')
        ya.dbg(next)
        if event == 1 then
            -- TODO notify
            ya.err('Falling back to builtin')
            return self:fallback_to_builtin(job)
        elseif event ~= 0 then
            break
        end

        i = i + 1
        if i > job.skip then
            lines = lines .. next
        end
    until i >= job.skip + limit

    -- print(lines)
    pretty:start_kill()
    if job.skip > 0 and i < job.skip + limit then
        ya.manager_emit('peek', { math.max(0, i - limit), only_if = tostring(job.file.url), upper_bound = true })
    else
        -- lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
        -- c'est cette ligne la qui fout la merde
        ya.preview_widgets(job, { ui.Text(lines):area(job.area) })
    end
end

function M:seek(job)
    local h = cx.active.current.hovered
    if h and h.url == job.file.url then
        local step = math.floor(job.units * job.area.h / 10)
        ya.manager_emit('peek', {
            math.max(0, cx.active.preview.skip + step),
            only_if = tostring(job.file.url),
        })
    end
end

function M:fallback_to_builtin(job)
    local _, bound = ya.preview_code(self)
    if bound then
        ya.manager_emit('peek', { bound, only_if = tostring(job.file.url), upper_bound = true })
    end
end

return M
