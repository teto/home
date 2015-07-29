" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 : 
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>


nmap <silent> <M-Up> :wincmd k<CR>
nmap <silent> <M-Down> :wincmd j<CR>
nmap <silent> <M-Left> :wincmd h<CR>
nmap <silent> <M-Right> :wincmd l<CR>


" For comparison
"nnoremap p :echom "p"<cr>
"nnoremap <S-p> :echom "S-p"<cr>
"nnoremap <C-p> :echom "C-p"<cr>
"nnoremap <C-S-p> :echom "C-S-p"<cr>
"nnoremap <M-p> :echom "M-p"<cr>
"nnoremap <M-S-p> :echom "M-S-p"<cr>
"nnoremap <C-M-p> :echom "C-M-p"<cr>
"nnoremap <C-M-S-p> :echom "C-M-S-p"<cr>


" nmap = *normal mode* mapping
nmap <silent> ^[OC :wincmd l<CR>
nmap <silent> ^[OC :wincmd h<CR>
nmap <silent> OC :wincmd l<CR>
nmap <silent> OD :wincmd h<CR>

" window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>

nnoremap <silent> + :exe "resize +3"
nnoremap <silent> - :exe "resize -3"

"Split windows below the current window.
"set splitbelow
" set splitright


"set winheight=30
"set winminheight=5

