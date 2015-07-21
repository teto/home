
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
"if has('nvim')
	Plug 'bling/vim-airline'
"else
	"Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
"endif

Plug 'CCTree'
"Plug 'showmarks2'
Plug 'junegunn/vim-github-dashboard'
Plug 'kien/ctrlp.vim'
Plug 'mattn/ctrlp-mark'
"Plug 'mattn/ctrlp-register'
Plug 'Solarized'
Plug 'scrooloose/nerdcommenter'
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sickill/vim-monokai'
"Plug 'surround.vim'
Plug 'tpope/vim-markdown'
"Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'numkil/ag.vim'
Plug 'gundo'
Plug 'Lokaltog/vim-easymotion'
Plug 'dhruvasagar/vim-table-mode/'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-rfc'
Plug 'chrisbra/unicode.vim'
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for 
Plug 'vim-latex/vim-latex', {'for': 'tex'}
Plug 'vimwiki/vimwiki'
Plug 'kshenoy/vim-signature'

" Had to disable this one, needs a vim with lua compiled
" and it's not possible in neovim yet
" color_coded requires vim to be compiled with -lua
"Plug 'jeaye/color_coded'
"
" Plug 'bbchung/clighter'
" YCM generator is not really a plugin is it ?
" Plug 'rdnetto/YCM-Generator'
" Plug 'erezsh/erezvim' "zenburn scheme. This plugin resets some keymaps,
" annoying
Plug 'chrisbra/csv.vim'
Plug 'luochen1990/rainbow'

call plug#end()
