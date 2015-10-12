" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 : 
"autoinstalL
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !mkdir -p ~/.vim/autoload
	    silent !curl -fLo ~/.vim/autoload/plug.vim
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe' , { 'do': './install.sh --system-libclang --clang-completer' }
Plug 'vim-flake8'
Plug 'hynek/vim-python-pep8-indent' " does not work
Plug 'mhinz/vim-startify'
Plug 'dietsche/vim-lastplace' " restore last cursor postion
"if has('nvim')
	Plug 'bling/vim-airline'
"else
	"Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
"endif

"Plug 'CCTree'
"Plug 'showmarks2'
Plug 'teto/nvim-wm'
"Plug 'teto/vim-listchars'
Plug '~/vim-listchars'
Plug 'vim-voom/VOoM'
Plug 'vim-voom/VOoM'
Plug 'blueyed/vim-diminactive'
Plug 'tpope/vim-sleuth' " Dunno what it is
Plug 'tpope/vim-vinegar' " Improves netrw
Plug 'tpope/vim-fugitive'
"Plug 'junegunn/vim-github-dashboard'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-mark'
Plug 'mattn/ctrlp-register'
Plug 'unblevable/quick-scope'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'scrooloose/nerdcommenter'
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'surround.vim'
"Plug 'tpope/vim-markdown', { 'for': 'md' }
"Plug 'elzr/vim-json', { 'for': 'json' }
"Plug 'numkil/ag.vim'
Plug 'gundo'
Plug 'Lokaltog/vim-easymotion'
Plug 'dhruvasagar/vim-table-mode'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-rfc'
Plug 'chrisbra/unicode.vim'
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for 
Plug 'vim-scripts/Modeliner' " <leader>ml to setup buffer modeline
" this one could not compile my program
"Plug 'vim-latex/vim-latex', {'for': 'tex'}
" ATP author gh mirror seems to be git@github.com:coot/atp_vim.git
Plug 'coot/atp_vim', {'for': 'tex'}
"Plug 'vim-scripts/AutomaticLaTexPlugin', {'for': 'tex'}
Plug 'tmhedberg/SimpylFold', { 'for': 'py' } " provides python folding
Plug 'vimwiki/vimwiki'
Plug 'kshenoy/vim-signature' " display marks in gutter, love it
"Plug 'vim-scripts/DynamicSigns'
Plug 'vasconcelloslf/vim-interestingwords' " highlight the words you choose
Plug 'mhinz/vim-grepper' " async grep neovim only
Plug 'benekastah/neomake' " async build for neovim
" color schemes {{{
Plug 'whatyouhide/vim-gotham'
Plug 'sickill/vim-monokai'
Plug 'mhinz/vim-janah'
Plug 'Solarized'
" }}}

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
" Plug 'luochen1990/rainbow' " does it work ?
Plug 'eapache/rainbow_parentheses.vim'

call plug#end()
