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
" Hide/display invisible characters
let g:current_listchar = 0

	let g:listchar_formats=[ 
				\"trail:·,tab:→\ ,eol:↲,precedes:<,extends:>", 
				\"trail:·"
				\]
"				\"trail:." 


" lists are 0 indexed
function! ToggleInvisibleChar()
	" l => local to the function

	let l:len = len(g:listchar_formats)
	
	"echo l:listchar_formats[g:current_listchar]
			let g:current_listchar = g:current_listchar + 1
	
	if g:current_listchar == l:len 
	   set nolist
	   return
   elseif g:current_listchar > l:len
	   let g:current_listchar = 0
	   "elseif g:current_listchar > l:len
	endif
	"echo g:current_listchar
	"echo g:listchar_formats[g:current_listchar]
	let &listchars=g:listchar_formats[g:current_listchar]
	"set listchars="trail:·"
	set list   

"what does s mean
endfunction


command! ToggleListchars call ToggleInvisibleChar()
noremap <F11> :ToggleListchars <CR>

