" set commentstring=-
"
" setlocal formatprg=hindent
setlocal keywordprg=hoogle\ --count=10
" nnoremap <Leader>?

" setlocal foldmethod=marker
set tabstop=4 softtabstop=4 sw=2
set expandtab                   " expand tabs to spaces

let g:gutentags_ctags_executable_haskell = 'hasktags'

" map gh :!hoogle <cword><CR>

" Equivalent to the above.
let b:ale_linters = {'haskell': ['hie']}
