-- requires subliminal, version 1.0 or newer
-- default keybinding: b
local utils = require('mp.utils')

--sleep function, so that subs aren't downloaded the instant a file is loaded
--taken from:http://lua-users.org/wiki/SleepFunction
function sleep(s)
    local ntime = os.time() + s
    repeat
    until os.time() > ntime
end

--original function, pressing b will trigger this and download the subtitle manually
function load_sub_fn()
    subl = '/usr/local/bin/subliminal' -- use 'which subliminal' to find the path
    mp.msg.info('Searching subtitle')
    mp.osd_message('Searching subtitle')
    t = {}

    t.args = { subl, 'download', '-s', '-f', '-l', 'en', mp.get_property('path') }
    res = utils.subprocess(t)
    if res.status == 0 then
        mp.commandv('rescan_external_files', 'reselect')
        mp.msg.info('Subtitle download succeeded')
        mp.osd_message('Subtitle download succeeded')
    else
        mp.msg.warn('Subtitle download failed')
        mp.osd_message('Subtitle download failed')
    end
end

--added function, auto search for subs and download if not present, the way god intended :P
function autosubs()
    sleep(10)
    subl = '/usr/local/bin/subliminal' -- use 'which subliminal' to find the path
    mp.msg.info('Searching subtitle')
    mp.osd_message('Searching subtitle')
    t = {}
    t.args = { subl, 'download', '-s', '-l', 'en', mp.get_property('path') }
    res = utils.subprocess(t)
    if res.status == 0 then
        mp.commandv('rescan_external_files', 'reselect')
        mp.msg.info('Subtitle download succeeded')
        mp.osd_message('Subtitle download succeeded')
    else
        mp.msg.warn('Subtitle download failed')
        mp.osd_message('Subtitle download failed')
    end
end

mp.add_key_binding('b', 'auto_load_subs', load_sub_fn)
mp.register_event('file-loaded', autosubs)
