
syn match   messagesIP          '\d\+\.\d\+\.\d\+\.\d\+'

syn keyword   lvlLogic       LOGIC
syn keyword   lvlError       ERROR FAIL WARN
syn match   lvlErrorLine       '.*WARN.*'



hi def link messagesIP          Constant
hi def link lvlLogic           Type
hi def link lvlError           Error
hi def link lvlErrorLine           Error
