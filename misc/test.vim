" autocmd WinNew
let g:buf = nvim_create_buf(0, 1)

let winopts = {
    \ 'width': 1,
    \ 'height': 1,
    \ 'relative': 'editor',
    \ 'anchor': 'NE',
    \ 'focusable': 0,
    \ 'row': 1,
    \ 'col': 1 }

tabnew

call nvim_open_win(g:buf, 0, winopts)
" close 
" test with conceal 

" syntax keyword pyNiceOperator sum conceal cchar=∑

" nvim_buf_set_extmark({buffer}, {ns_id}, {id}, {line}, {col}, {opts})
" setlocal conceallevel=2
" " syntax keyword vimCommand all conceal cchar=∀
" syn match HateWord /hate/ conceal cchar=∀
" toto hate adasda

" copen

" snd hl group is for language mappings
" set guicursor=n-v-c:block-blinkon250-Cursor/lCursor
" " ve = visual exclusive
" set guicursor+=ve:ver35-Cursor,
" " operator-pending mode
" set guicursor+=o:hor50-Cursor
" " ci => command insert mode
" set guicursor+=i-ci:ver25-blinkon250-CursorTransparent/lCursor
" set guicursor+=r-cr:hor20-Cursor/lCursor

" set termguicolors

" highl CursorTransparent ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00 gui=strikethrough blend=100
" highl Cursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00

