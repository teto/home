-- ~/.config/yazi/plugins/test.yazi/init.lua

local M = {}

function M:peek()
    -- ya.notify {
    --     title = "chunk plugin activated !",
    --     content = "",
    --     timeout = 1
    --     -- level = "info",
    -- }
    -- ya.dbg("LOL")
    -- ya.err / ya.dbg
    ya.dbg('Called with ' .. tostring(self.file.url))

    -- see https://github.com/sxyazi/yazi/pull/1033 for an example on how to parse
    ya.preview_widgets(self, { ui.Paragraph.parse(self.area, 'Loading jsonzlib...') })
    local pigz = Command('pigz')
        :args({
            '-dc',
            tostring(self.file.url),
        })
        :stdout(Command.PIPED)
        -- :stderr(Command.PIPED)
        :spawn()

    -- local echo = Command("echo"):arg("Hello"):stdout(Command.PIPED):spawn()

    local pretty = Command('jq'):arg("'.'"):stdin(pigz:take_stdout()):stdout(Command.PIPED):spawn()

    -- ya.err(pretty.stdout)

    -- TODO pipe with jq to prettify it

    -- if not child then
    -- 	return self:fallback_to_builtin()
    -- end

    local limit = self.area.h
    local i, lines = 0, ''
    repeat
        local next, event = pretty:read_line()
        ya.dbg('READLINE')
        ya.dbg(next)
        if event == 1 then
            ya.err('Falling back to builtin')
            return self:fallback_to_builtin()
        elseif event ~= 0 then
            break
        end

        i = i + 1
        if i > self.skip then
            lines = lines .. next
        end
    until i >= self.skip + limit

    -- print(lines)
    pretty:start_kill()
    if self.skip > 0 and i < self.skip + limit then
        ya.manager_emit('peek', { math.max(0, i - limit), only_if = tostring(self.file.url), upper_bound = true })
    else
        -- lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
        -- c'est cette ligne la qui fout la merde
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
