
"autoinstalL
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !mkdir -p ~/.vim/autoload
	    silent !curl -fLo ~/.vim/autoload/plug.vim
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.vim/plugged')

Plug 'https://github.com/Valloric/YouCompleteMe' , { 'do': './install.sh --clang-interpreter' }
" Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-interpreter' }
Plug 'vim-flake8'
Plug 'mhinz/vim-startify'
" Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
Plug 'CCTree'
Plug 'showmarks2'

Plug 'kien/ctrlp.vim'
Plug 'Solarized'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sickill/vim-monokai'
Plug 'surround.vim'
Plug 'elzr/vim-json', { 'for': 'json' }

call plug#end()
