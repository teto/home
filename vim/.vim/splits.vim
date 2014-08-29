" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 : 
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

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


set winheight=30
set winminheight=5

