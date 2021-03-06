" runtime plugin/grepper.vim    
if !exists('g:loaded_grepper')
  finish
endif
let g:grepper.tools += ["gitall"]
let g:grepper.gitall = copy(g:grepper.git)
let g:grepper.gitall.grepprg = 'git grep "$*" $(git rev-list --all)'
let g:grepper.tools += ["rgfixed"]
let g:grepper.rgfixed = copy(g:grepper.rg)
" for a fixed string
let g:grepper.rgfixed.grepprg .= " -F "
" let g:grepper.gitall.grepprg = 'git grep "$*" $(git rev-list --all)'
let g:grepper.prompt_quote = 0


" let g:grepper.rgall.grepprg .= ' --no-ignore'
" let g:grepper.highlight = 1
" let g:grepper.open = 0
" let g:grepper.switch = 1

