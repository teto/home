function! TestFoldTextWithColumns()
  " build a line that 
  let l:line = getline(v:foldstart)
  let l:foldcount = v:foldend - v:foldstart + 1
  let l:res = "v:foldstartcol not supported " . l:foldcount
  if exists("v:foldstartcol")
	let l:inlinefold = v:foldstart == v:foldend
	"foldstartcol exists :". v:foldstartcol . "/". v:foldendcol
    let l:res = strpart(line, 0, v:foldstartcol)
	" if inline fold
	if l:inlinefold
		let l:res .= "{...}".strpart(line, v:foldendcol)
	else
		let l:res .= " +- ".l:foldcount." lines startcol=".v:foldstartcol." end=".v:foldendcol
	endif
  endif
  return l:res
endfunc

" set foldtext=TestFoldTextWithColumns()
set foldtext=
set fdc=2
set number

" to be able to fold
" set foldminlines=0

" set fdm=marker
set fdm=manual

" set listchars+=conceal:X
" conceal used by default if cchar does not exit
set listchars+=conceal:X

