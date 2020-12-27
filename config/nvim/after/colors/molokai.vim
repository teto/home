highlight Comment gui=italic
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227 guibg=#F08A1F


" guifg=#465457 guibg=#232526
" TODO should be less obvious
" hi LineNr guifg=#FD971F
hi CursorLineNr guibg=#FD971F guifg=#232526
" #FD971F
" todo overwrite 
" hi CursorLine               ctermbg=236   cterm=none


" otherwise a bit dark
" hi Pmenu guibg=#232526

" showbreak and EndOfFile
hi NonText         guibg=#E5943D

" use for "nbsp", "space", "tab" and "trail".
hi Whitespace         guibg=NONE

" in upstream molokai, EndOfBuffer n'est pas defini
hi EndOfBuffer         guibg=#465457
" guifg=None is important here
hi CursorLine                    guibg=#293739 guifg=None
" hi CursorLineNr    guibg=#E5943D               gui=none
hi CursorColumn                  guibg=#293739
hi DiffDelete guibg=red


" for coq.vim
" CheckedByCoq and SentToCoq
" highlight CheckedByCoq ctermbg=17 guibg=LightGreen
" hi SentToCoq ctermbg=60 guibg=LimeGreen
"
hi link CheckedByCoq EndOfBuffer
hi link SentToCoq Question


" we want the warning par defaut links to CocUnderline
hi CocUnderline gui=undercurl
"  guibg=yellow 
hi CocWarningHighlight gui=undercurl

" srcIp
