
"autoinstalL
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !mkdir -p ~/.vim/autoload
	    silent !curl -fLo ~/.vim/autoload/plug.vim
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe.git'
Plug 'vim-flake8'
Plug 'mhinz/vim-startify'
" Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
Plug 'CCTree'

Plug 'Solarized'

Plug 'scrooloose/nerdcommenter'

call plug#end()
