" set commentstring=-
"
" setlocal formatprg=hindent
" setlocal keywordprg=hoogle\ --count=10

" setlocal foldmethod=marker
setlocal tabstop=4 softtabstop=4 sw=2
setlocal expandtab                   " expand tabs to spaces

setlocal nocindent
setlocal nosmartindent
" > triggers shiftwidth

let g:gutentags_ctags_executable_haskell = 'hasktags'

" setlocal omnifunc=v:lua.vim.lsp.omnifunc
