local has_sshfs, sshfs = pcall(require, 'sshfs')
if has_sshfs then
    require('sshfs'):setup()
end
-- inspired by https://yazi-rs.github.io/docs/tips/
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return ' -> ' .. tostring(h.link_to)
    else
        return ''
    end
end, 3300, Status.LEFT)

-- show user/group on right
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= 'unix' then
        return ''
    end

    return ui.Line({
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg('magenta'),
        ':',
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg('magenta'),
        ' ',
    })
end, 500, Status.RIGHT)

-- depends if bunny is installed
local has_bunny, bunny = pcall(require, 'bunny')
if has_bunny then
    bunny:setup({
        hops = {
            { key = '/', path = '/' },
            { key = 't', path = '/tmp' },
            { key = 'n', path = '/nix/store', desc = 'Nix store' },
            { key = '~', path = '~', desc = 'Home' },
            { key = 'm', path = '~/Music', desc = 'Music' },
            { key = 'd', path = '~/Desktop', desc = 'Desktop' },
            { key = 'D', path = '~/Documents', desc = 'Documents' },
            { key = 'c', path = '~/.config', desc = 'Config files' },
            { key = { 'l', 's' }, path = '~/.local/share', desc = 'Local share' },
            { key = { 'l', 'b' }, path = '~/.local/bin', desc = 'Local bin' },
            { key = { 'l', 't' }, path = '~/.local/state', desc = 'Local state' },
            -- key and path attributes are required, desc is optional
        },
        desc_strategy = 'path', -- If desc isn't present, use "path" or "filename", default is "path"
        ephemeral = true, -- Enable ephemeral hops, default is true
        tabs = true, -- Enable tab hops, default is true
        notify = false, -- Notify after hopping, default is false
        fuzzy_cmd = 'fzf', -- Fuzzy searching command, default is "fzf"
    })
end

-- show symlink
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return ' -> ' .. tostring(h.link_to)
    else
        return ''
    end
end, 3300, Status.LEFT)
