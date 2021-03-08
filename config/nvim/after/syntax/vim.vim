" :syntax include @CPP syntax/cpp.vim
" if exists("b:current_syntax")
" 	unlet b:current_syntax
" endif
" syn include @VIM syntax/vim.vim

" *:syn-matchgroup*
syntax region luaHereDoc matchgroup=Snip start="@begin=cpp@" end="@end=cpp@" contains=@LUA contained
hi link Snip SpecialComment
