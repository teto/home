
" C syntax parsing {{{
" hoefully obsolete with clang semantic analysis (see rtags etc..)
"let c_no_bracket_error=1
"let c_no_curly_error=1
"let c_comment_strings=1
"let c_gnu=1
" }}}

" otherwise vim defaults to ccomplete#Complete
setlocal omnifunc=v:lua.vim.lsp.omnifunc
" LanguageClientStop
