#!/usr/bin/env lua
-- local os = require 'os'
-- select a random character
function pick_random_entry()
    return { kanji = '出来る', trans = 'dekiru -> sortir' }
end

local res = pick_random_entry()

os.execute('convert -background lightblue -fill black  -pointsize 80 label:' .. res.kanji .. ' out.png')

-- call convert se
os.execute('timg out.png')
print(res.trans)
