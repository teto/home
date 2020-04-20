function! TestFoldTextWithColumns()
  let l:line = getline(v:foldstart)
  let l:res = "v:foldstartcol not supported " . count
  let l:foldcount = v:foldend - v:foldstart + 1
  " use strpart
  " v:foldstart / v:foldend
  if exists("v:foldstartcol")
	"foldstartcol exists :". v:foldstartcol . "/". v:foldendcol
	" let l:res = "toto"
    let l:res = strpart(line, 0, v:foldstartcol)
	let l:res .= " +-- " . l:foldcount . " lines with startcol=".v:foldstartcol
  endif
  return l:res
endfunc

set foldtext=TestFoldTextWithColumns()

set fdc=3

set fdm=marker

" set fillchars+=
" one  ▶
" set fillchars+=vert:│,fold:>,stl:\ ,stlnc:\ ,diff:-
" set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
" bin/nvim ../toto.txt -c "call feedkeys('zf5jggzf2j')" -u NONE
" zf2j
