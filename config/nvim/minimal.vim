set nocompatible

" Load Vimtex

let s:nvimdir = (exists("$XDG_CONFIG_HOME") ? $XDG_CONFIG_HOME : $HOME.'/.config').'/nvim'
let s:plugscript = s:nvimdir.'/autoload/plug.vim'

"silent echom s:plugscript
"silent echom s:nvimdir

if empty(glob(s:plugscript))
  execute "!mkdir -p " s:nvimdir.'/autoload' s:nvimdir.'/plugged'
  execute "!curl -fLo" s:plugscript
		\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

let mapleader = " "

filetype plugin indent on
syntax enable


call plug#begin(s:nvimdir.'/plugged')

Plug 'lervag/vimtex', {'for': 'tex'}

call plug#end()



let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_latexmk_progname = 'nvr'
let g:latex_view_general_viewer = 'zathura'
"let g:tex_stylish = 1
"let g:tex_flavor = 'latex'
"let g:tex_isk='48-57,a-z,A-Z,192-255,:'

if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif

let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*,?)*',
    \ 're!\\includegraphics([^]]*])?{[^}]*',
    \ 're!\\(include|input){[^}]*'
    \ ]
"<plug>(vimtex-toc-toggle)
"<plug>(vimtex-labels-toggle)
autocmd FileType tex nnoremap <leader>lt <plug>(vimtex-toc-toggle)
