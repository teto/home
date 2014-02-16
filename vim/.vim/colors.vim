

" highlight CursorLine  cterm=NONE ctermbg=white ctermfg=white guibg=darkred guifg=white
" highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>


"  TAbbar colorization
"
hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
hi TabLine ctermfg=Blue ctermbg=Yellow
hi TabLineSel ctermfg=Red ctermbg=Yellow



" cterm => terminal color, gui => with gvim ?
highlight Pmenu ctermfg=Cyan ctermbg=Blue cterm=None guifg=Cyan guibg=DarkBlue

" selected element
highlight PmenuSel   ctermfg=White ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold

" scrollbar
highlight PmenuSbar ctermbg=Cyan guibg=Cyan
highlight PmenuThumb ctermfg=White guifg=White 
