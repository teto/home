" set commentstring=-
"
" setlocal formatprg=hindent
setlocal keywordprg=hoogle\ --count=10
" setlocal foldmethod=marker
set tabstop=2 softtabstop=2 sw=2
set expandtab                   " expand tabs to spaces

" Equivalent to the above.
let b:ale_linters = {'haskell': ['hie']}
