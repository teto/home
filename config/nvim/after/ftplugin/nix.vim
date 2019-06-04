
let b:nrrw_aucmd_create = 'set ft=sh'
" let b:nrrw_aucmd_close  = "%UnArrangeColumn"

let b:auto_save = 1

" NeomakeEnableBuffer
autocmd BufWritePost *.nix :silent NeomakeEnableBuffer
