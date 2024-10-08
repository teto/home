local M = {}

function M:peek()
    -- ya.notify {
    --     title = "chunk plugin activated !",
    --     content = "",
    --     timeout = 1
    --     -- level = "info",
    -- }
    -- ya.dbg("LOL")
    ya.dbg('chunks plugins called with ' .. tostring(self.file.url))

    ya.preview_widgets(self, { ui.Paragraph.parse(self.area, 'Loading chunks...') })
    local child = Command('view_json')
        :args({
            tostring(self.file.url),
        })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    if not child then
        -- TODO show stderr ?
        ya.err('fallback to builtins')
        ya.preview_widgets(self, { ui.Paragraph.parse(self.area, 'Loading chunks...') })
        return self:fallback_to_builtin()
    end

    local limit = self.area.h
    local i, lines = 0, ''
    repeat
        local next, event = child:read_line()
        if event == 1 then
            ya.err('event == 1: falling back to builtins')
            return self:fallback_to_builtin()
        elseif event ~= 0 then
            -- event ~= 0
            break
        end

        i = i + 1
        if i > self.skip then
            lines = lines .. next
        end
    until i >= self.skip + limit

    child:start_kill()
    if self.skip > 0 and i < self.skip + limit then
        ya.manager_emit('peek', { math.max(0, i - limit), only_if = tostring(self.file.url), upper_bound = true })
    else
        lines = lines:gsub('\t', string.rep(' ', PREVIEW.tab_size))
        ya.preview_widgets(self, { ui.Paragraph.parse(self.area, lines) })
    end
    --

    -- log("hello world")
    -- print("test logger") -- got printed in the output
    -- lines = lines:gsub("\t", string.rep(" ", 4))
    -- p = ui.Paragraph.parse(self.area, "----- TOTO -----\n\n")

    -- ya.preview_widgets(self, { ui.Paragraph.parse(self.area, {"toto", "tata" } })

    -- ya.preview_widgets(self, { p:wrap(ui.Paragraph.WRAP) })
    -- ya.preview_widgets(self, { p })
end

function M:seek(units)
    local h = cx.active.current.hovered
    if h and h.url == self.file.url then
        local step = math.floor(units * self.area.h / 10)
        ya.manager_emit('peek', {
            math.max(0, cx.active.preview.skip + step),
            only_if = tostring(self.file.url),
        })
    end
end

function M:fallback_to_builtin()
    local _, bound = ya.preview_code(self)
    if bound then
        ya.manager_emit('peek', { bound, only_if = tostring(self.file.url), upper_bound = true })
    end
end

return M
