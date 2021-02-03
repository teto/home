" set commentstring=-
"
" setlocal formatprg=hindent
setlocal keywordprg=hoogle\ --count=10
" nnoremap <Leader>?

" setlocal foldmethod=marker
setlocal tabstop=4 softtabstop=4 sw=2
setlocal expandtab                   " expand tabs to spaces

setlocal nocindent
setlocal nosmartindent
setlocal indentexpr
" > triggers shiftwidth

let g:gutentags_ctags_executable_haskell = 'hasktags'

" disable per-buffer
" let b:airline_disable_statusline = 1

" set statusline=%!StatusLSP()

" map gh :!hoogle <cword><CR>
