highlight Comment gui=italic
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227 guibg=#F08A1F

" 
" todo overwrite 
hi CursorLine               ctermbg=236   cterm=none



" showbreak and EndOfFile
hi NonText         guibg=#E5943D
" in upstream molokai, EndOfBuffer n'est pas defini
hi EndOfBuffer         guibg=#465457
" 
hi CursorLine                    guibg=#293739
" hi CursorLineNr    guibg=#E5943D               gui=none
hi CursorColumn                  guibg=#293739


" for coq.vim
" CheckedByCoq and SentToCoq
highlight CheckedByCoq ctermbg=17 guibg=LightGreen
hi SentToCoq ctermbg=60 guibg=LimeGreen
