" Always display the status line, even if only one window is displayed
set laststatus=2

" highlight cursor line
set cursorline

" Display unprintable characters with '^' and
" set nolist to disable or set list!
set list     

" show tab and trailing spaces
" Ctrl+v, u, unicode hex code
" "
" " tab chars
" " 21E2 ⇢
" " 21E5 ⇥
" " 21E8 ⇨
" " 2192 → (rightwards arrow, &rarr;)
" " 21D2 ⇒ (rightwards double arrow, &rArr;)
" " 25B8 ▸ (TextMate style)
" "→ 
" " trail chars
" " 25CF ●
" " 2639 ☹ (frowning face)
" " 267A ♺ (recycling symbol)
" " 261F ☟ (hand pointing down)
" " F8FF  (apple logo)
" "
" " eol chars
" " 21B2 ↲
" " 21B5 ↵ (carriage return, &crarr;)
" " 21A9 ↩
" " 23CE ⏎ (return symbol)
" " 00AC ¬ (TextMate style)
"
"
"
" " Working with <Tab>s?
" " tabstop == softtabstop
" "
" " Working with spaces?
" " softtabstop == shiftwidth

set listchars=trail:·,tab:→\ ,eol:↲,precedes:<,extends:>

