" Setting up Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/vundle
	let iCanHazVundle=0
endif



" set runtime path
set rtp+=~/.vim/bundle/vundle
" alternatively, pass a path where Vundle should install plugins begin(path)
call vundle#begin()

" let Vundle manage Vundle
"  " required! 
Plugin 'easymotion'
Plugin 'gmarik/vundle'
Plugin 'sickill/vim-monokai'    
Plugin 'scrooloose/nerdtree'
Plugin 'mhinz/vim-startify'
Plugin 'scrooloose/nerdcommenter'
Plugin 'showmarks2'
" Plugin 'minibufexpl.vim' To delete
" Plugin 'Command-T' Replaced by ctrlp
Plugin 'kien/ctrlp.vim'
Plugin 'CCTree'
Plugin 'Modeliner'
Plugin 'autoload_cscope.vim'
" Plugin 'gfxmonk/vim-background-make'
" Plugin 'tpope/vim-dispatch'
Plugin 'makebg'
" Plugin 'SuperTab'
" Plugin 'taglist.vim'
" Plugin 'vim-addon-background-cmd'
" Plugin 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
" Press F12 to toggle mouse between terminal & vim control
Plugin 'nvie/vim-togglemouse' 
Plugin 'Solarized'
Plugin 'fugitive.vim'
Plugin 'Valloric/YouCompleteMe.git'
"Plugin 'vim-flake8'
call vundle#end()

filetype plugin indent on    " required
