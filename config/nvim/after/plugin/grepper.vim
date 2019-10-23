" runtime plugin/grepper.vim    
if !exists('g:loaded_grepper')
  finish
endif
let g:grepper.tools += ["gitall"]
let g:grepper.gitall = copy(g:grepper.git)
let g:grepper.gitall.grepprg = 'git grep "$*" $(git rev-list --all)'


" let g:grepper.rgall.grepprg .= ' --no-ignore'
" let g:grepper.highlight = 1
" let g:grepper.open = 0
" let g:grepper.switch = 1

