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
" set statusline=%t       "tail of the filename
