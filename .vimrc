set nocompatible               " be iMproved
filetype off                   " required!
set t_Co=256			" colors
"let g:Powerline_symbols = "fancy" " to use unicode symbols
let mapleader = ","


set showmatch

set autochdir
" 
" " When on, Vim will change the current working directory
" " whenever you open a file, switch buffers, delete a buffer
" " or open/close a window.
" " It will change to the directory containing the file which
" " was opened or selected.
" " Note: When this option is on some plugins may not work.

scriptencoding utf-8
" allow to use fancy caracters
set encoding=utf-8

" display a menu when need t ocomplete a command 
set wildmenu
set wildmode=list:longest
"Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif


" Use visual bell instead of beeping when doing something wrong
set visualbell

" enable mouse to click on tabs etc... 
set mouse=a
set ttymouse=urxvt
" Display line numbers on the left
" set number

" Always display the status line, even if only one window is displayed
set laststatus=2

" highlight cursor line
set cursorline

" show/hide line numbers
map <C-N><C-N> :set invnumber<CR>


" Display unprintable characters with '^' and
" " put $ after the line.
set list     

" show tab and trailing spaces
" Ctrl+v, u, unicode hex code
" "
" " tab chars
" " 21E2 ⇢
" " 21E5 ⇥
" " 21E8 ⇨
" " 2192 → (rightwards arrow, &rarr;)
" " 21D2 ⇒ (rightwards double arrow, &rArr;)
" " 25B8 ▸ (TextMate style)
" "→ 
" " trail chars
" " 25CF ●
" " 2639 ☹ (frowning face)
" " 267A ♺ (recycling symbol)
" " 261F ☟ (hand pointing down)
" " F8FF  (apple logo)
" "
" " eol chars
" " 21B2 ↲
" " 21B5 ↵ (carriage return, &crarr;)
" " 21A9 ↩
" " 23CE ⏎ (return symbol)
" " 00AC ¬ (TextMate style)
"
"
"
" " Working with <Tab>s?
" " tabstop == softtabstop
" "
" " Working with spaces?
" " softtabstop == shiftwidth

set listchars=trail:·,tab:→\ ,eol:↲

" a tab takes 4 characters (local to buffer)
set tabstop=4

" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4

" start scrolling before reaching end of screen in order to keep more context
set scrolloff=3


" Quick timeouts on key combinations.
set timeoutlen=300

" - boolean (default off), local to buffer
"  compilation option
set smartindent 


" Hide the default mode text (e.g. -- INSERT -- below the statusline)
" set noshowmode


"""""""""""""""""""""""""""""""""""""
" cscope configuration
" """""""""""""""""""""""""""""""""""
"
"
set cscopeverbose 


" TODO 
"augroup Python
	"au!
"augroup END
" in order to scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Regenerate database
" map 


map <esc>[27;5;9~ <C-Tab>
map <esc>[1;5A <C-Up>
map <esc>[1;5B <C-Down>
map <esc>[1;5C <C-Right>
map <esc>[1;5D <C-Left>
map <esc>[1;2D <S-Left>
map <esc>[1;2C <S-Right>
map <esc>[27;5;38~ <C-&>
map <esc>[27;5;130~ <C-é>
map <esc>[27;5;39~ <C-'>
map <esc>[27;5;34~ <C-">
map <esc>[27;5;40~ <C-(>
"
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


" highlight CursorLine  cterm=NONE ctermbg=white ctermfg=white guibg=darkred guifg=white
" highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
syntax on


" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/vundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/vundle
        let iCanHazVundle=0
    endif


set rtp+=~/.vim/vundle/
call vundle#rc()

" let Vundle manage Vundle
"  " required! 
Bundle 'gmarik/vundle'
Bundle 'sickill/vim-monokai'    
Bundle 'scrooloose/nerdtree'
" Bundle 'Lokaltog/powerline'
" Bundle 'Lokaltog/vim-powerline'
Bundle 'mhinz/vim-startify'
Bundle 'scrooloose/nerdcommenter'
" Bundle 'minibufexpl.vim' To delete
" Bundle 'Command-T' Replaced by ctrlp
Bundle 'kien/ctrlp.vim'
Bundle 'CCTree'
Bundle 'Modeliner'
Bundle 'autoload_cscope.vim'
" Bundle 'gfxmonk/vim-background-make'
" Bundle 'tpope/vim-dispatch'
Bundle 'makebg'
Bundle 'SuperTab'
" Bundle 'taglist.vim'
Bundle 'vim-addon-background-cmd'
Bundle 'Lokaltog/powerline' 
" , {'rtp': 'powerline/bindings/vim'}
" Press F12 to toggle mouse between terminal & vim control
Bundle 'nvie/vim-togglemouse' 
" set statusline=%t       "tail of the filename

filetype plugin on

" Modeline shortcuts 
nmap <leader>ml :Modeliner<Enter>

" Tab shortcuts
let tableader = "t" 
execute "nmap <unique> ". g:tableader.g:tableader." :tabnew<Enter>"
nmap <leader>t :tabnew<Enter>
nmap <leader><S-t> :tabclose<Enter>

" nmap <C-Left> <C-&>

" nmap <C-Enter> :vs<Enter>
" map <C-Left> gT
nmap <tab> :tabn<Enter>
nmap <C-Right> :tabn<Enter>
nmap <C-Left> :tabN<Enter>

nmap <C-Tab> :tabN<Enter>
nmap <C-&> :tabn1<Enter>
nmap <C-é> :tabn2<Enter>
nmap <C-"> :tabn3<Enter>
nmap <C-'> :tabn4<Enter>
nmap <S-N> :NERDTreeToggle<Enter>


" Quickly edit/reload the vimrc file
 nmap <silent> <leader>ev :e $MYVIMRC<CR>
 nmap <silent> <leader>sv :so! $MYVIMRC<CR>
"
"
" Easy window navigation
 map <C-h> <C-w>h
 map <C-j> <C-w>j
 map <C-k> <C-w>k
 map <C-l> <C-w>l

" Nerdtree shortcuts
noremap <F2> :NERDTreeToggle<Enter>

" taglist
let Tlist_Use_Right_Window   = 1
noremap <F3> :Tlist<Enter>


noremap <F4> exec ":emenu <tab>"

"execute ":source '$HOME/.vim/test_tab.vim'"
"source $HOME/.vim/test_tab.vim

" A stands for Alt
nnoremap <C-h> :call MoveToTab(2)<CR>
nnoremap <C-l> :call MoveToTab(1)<CR>


" map <F2> :echo 'Current time is ' . strftime('%c')<CR>
" map! <F3> a<C-R>=strftime('%c')<CR><Esc>
