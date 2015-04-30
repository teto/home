
"autoinstalL
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !mkdir -p ~/.vim/autoload
	    silent !curl -fLo ~/.vim/autoload/plug.vim
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.vim/plugged')

Plug 'https://github.com/Valloric/YouCompleteMe' , { 'do': './install.sh --system-libclang --clang-completer' }
Plug 'vim-flake8'
Plug 'mhinz/vim-startify'
if !has('nvim')
	Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
endif

Plug 'CCTree'
Plug 'showmarks2'
Plug 'junegunn/vim-github-dashboard'
Plug 'kien/ctrlp.vim'
Plug 'Solarized'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sickill/vim-monokai'
Plug 'surround.vim'
Plug 'tpope/vim-markdown'
"Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'numkil/ag.vim'
Plug 'gundo'
Plug 'dhruvasagar/vim-table-mode/'
Plug 'airblade/vim-gutter'
" Had to disable this one, needs a vim with lua compiled
" and it's not possible in neovim yet
" color_coded requires vim to be compiled with -lua
"Plug 'jeaye/color_coded'
"
Plug 'bbchung/clighter'
" YCM generator is not really a plugin is it ?
" Plug 'rdnetto/YCM-Generator'

call plug#end()
