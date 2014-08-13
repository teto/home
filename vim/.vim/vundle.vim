" Setting up Vundle - the vim plugin bundler
" it will download itself if not existing
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/vundle/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/vundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/vundle
	let iCanHazVundle=0
endif

" set runtime path
set rtp+=~/.vim/vundle/
call vundle#rc()

" let Vundle manage Vundle
"  " required! 
Bundle 'gmarik/vundle'
Bundle 'sickill/vim-monokai'    
Bundle 'scrooloose/nerdtree'
Bundle 'mhinz/vim-startify'
Bundle 'scrooloose/nerdcommenter'
Bundle 'showmarks2'
" Bundle 'minibufexpl.vim' To delete
" Bundle 'Command-T' Replaced by ctrlp
Bundle 'kien/ctrlp.vim'
Bundle 'CCTree'
Bundle 'Modeliner'
Bundle 'autoload_cscope.vim'
" Bundle 'gfxmonk/vim-background-make'
" Bundle 'tpope/vim-dispatch'
Bundle 'makebg'
" Bundle 'SuperTab'
" Bundle 'taglist.vim'
" Bundle 'vim-addon-background-cmd'
" Bundle 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
" Press F12 to toggle mouse between terminal & vim control
Bundle 'nvie/vim-togglemouse' 
Bundle 'Solarized'
Bundle 'fugitive.vim'
