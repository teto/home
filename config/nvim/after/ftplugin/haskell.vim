" set commentstring=-
"
" setlocal formatprg=hindent
setlocal keywordprg=hoogle\ --count=10
" nnoremap <Leader>?

" setlocal foldmethod=marker
set tabstop=2 softtabstop=2 sw=2
set expandtab                   " expand tabs to spaces

map gh :!hoogle <cword><CR>

" Equivalent to the above.
let b:ale_linters = {'haskell': ['hie']}
