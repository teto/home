" Compiler:	python
" Last Change:	2013-02-16

if exists("current_compiler")
  finish
endif
let current_compiler = "python"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Options:
"   -t     : issue warnings about inconsistent tab usage (-tt: issue errors)
"
" Consider:
"   -3     : warn about Python 3.x incompatibilities that 2to3 cannot
"   trivially fix
"
CompilerSet makeprg=python\ -t\ %

" Use each file and line of Tracebacks (to see and step through the code executing).
" Include failed toplevel doctest example.
" Ignore big star lines from doctests.
" Ignore most of doctest summary. x2
CompilerSet errorformat=
      \%A%\\s%#File\ \"%f\"\\,\ line\ %l\\,\ in%.%#,
      \%+CFailed\ example:%.%#,
      \%Z%*\\s\ \ \ %m,
      \%-G*%\\{70%\\},
      \%-G%*\\d\ items\ had\ failures:,
      \%-G%*\\s%*\\d\ of%*\\s%*\\d\ in%.%#

" I don't use \%-G%.%# to remove extra output because most of it is useful as
" context for the actual error message. I also don't include %+G because
" they're unnecessary if I'm not squelching most output.
" If I was using %+G, I'd probably want something like these. There are so
" many, that I don't bother.
"      \%+GTraceback%.%#,
"      \%+G%*\\wError%.%#,
"      \%+G***Test\ Failed***%.%#
"      \%+GExpected%.%#,
"      \%+GGot:%.%#,

" Found this in .vim/after/plugin/asynccommand_python.vim. It has extra stuff
" for SyntaxErrors (%p is for the pointer to the error column). I can't get it
" to work.
" " Source: http://www.vim.org/scripts/script.php?script_id=477
" setlocal errorformat=
"     \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
"     \%C\ \ \ \ %.%#,
"     \%+Z%.%#Error\:\ %.%#,
"     \%A\ \ File\ \"%f\"\\\,\ line\ %l,
"     \%+C\ \ %.%#,
"     \%-C%p^,
"     \%Z%m

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:

