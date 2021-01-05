set nocompatible

" Load Vimtex

let s:nvimdir = (exists("$XDG_CONFIG_HOME") ? $XDG_CONFIG_HOME : $HOME.'/.config').'/nvim'
let s:plugscript = s:nvimdir.'/autoload/plug.vim'

"silent echom s:plugscript
"silent echom s:nvimdir

"if empty(glob(s:plugscript))
  "execute "!mkdir -p " s:nvimdir.'/autoload' s:nvimdir.'/plugged'
  "execute "!curl -fLo" s:plugscript
		"\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		  "autocmd VimEnter * PlugInstall | source $MYVIMRC
"endif

let mapleader = " "

filetype plugin indent on
syntax enable


call plug#begin(s:nvimdir.'/plugged')

"Plug 'lervag/vimtex', {'for': 'tex'}
" Plug 'mhinz/vim-signify'
let g:nvim_tree_auto_open = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_tab_open = 1
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

nnoremap <C-n> :NvimTreeToggle<CR>
