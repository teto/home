" to debug vimscript, use :mess to display error messages
source ~/.vim/vimrc


let s:plugdir = $XDG_CONFIG_HOME.'/nvim/autoload/plug.vim'
if empty(glob(s:plugdir))
	  silent !mkdir -p $XDG_CONFIG_HOME.'/nvim/autoload'
	    silent !curl -fLo s:plugdir
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif


if has('nvim')
	"runtime! python_setup.vim
 " when launching term
	tnoremap <Esc> <C-\><C-n>
endif

"'.'
"set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada
set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
let g:diminactive_use_syntax = 1
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'
" Cursor configuration {{{
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" }}}
