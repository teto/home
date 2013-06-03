set nocompatible               " be iMproved
filetype off                   " required!
set t_Co=256			" colors
"let g:Powerline_symbols = "fancy" " to use unicode symbols

" Use visual bell instead of beeping when doing something wrong
set visualbell

" Display line numbers on the left
" set number

" Always display the status line, even if only one window is displayed
set laststatus=2

" highlight cursor line
set cursorline

" show/hide line numbers
map <C-N><C-N> :set invnumber<CR>

" cterm => terminal color, gui => with gvim ?
highlight Pmenu ctermfg=Cyan ctermbg=Blue cterm=None guifg=Cyan guibg=DarkBlue

" selected element
highlight PmenuSel   ctermfg=White ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold

" scrollbar
highlight PmenuSbar ctermbg=Cyan guibg=Cyan
highlight PmenuThumb ctermfg=White guifg=White 


highlight CursorLine  cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
syntax on

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
"  " required! 
Bundle 'gmarik/vundle'
Bundle 'sickill/vim-monokai'    
Bundle 'scrooloose/nerdtree'
" Bundle 'Lokaltog/powerline'
Bundle 'Lokaltog/vim-powerline'
Bundle 'mhinz/vim-startify'
Bundle 'scrooloose/nerdcommenter'
" set statusline=%t       "tail of the filename
