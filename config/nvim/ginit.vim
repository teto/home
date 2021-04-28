" graphical init like set guifont

" see https://github.com/equalsraf/neovim-qt/wiki/GUI#how-to-change-the-font
" Guifont DejaVu Sans Mono:h13
GuiTabline 1

GuiPopupmenu 1

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv

" to check if neovim-qt is running, use `exists('g:GuiLoaded')`,
" see https://github.com/equalsraf/neovim-qt/issues/219
if exists('g:GuiLoaded')
    " call GuiWindowMaximized(1)
    GuiPopupmenu 0
    GuiTabline 0
    GuiLinespace 3
    GuiFont! Hack:h10:l
    " GuiFont! Microsoft\ YaHei\ Mono:h10:l

    " use shift+insert for paste in neovim-qt
    " see https://github.com/equalsraf/neovim-qt/issues/327#issuecomment-325660764
    imap <silent>  <S-Insert>  <C-R>+
    cmap <silent> <S-Insert> <C-R>+

    " For Windows, Ctrl-6 does not work. So we use this mapping instead.
    nmap <C-6> <C-^>
endif
