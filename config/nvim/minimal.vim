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
Plug 'mhinz/vim-signify'

call plug#end()

" signify (display added/removed lines from vcs) {{{
let g:signify_vcs_list = [ 'git']
" let g:signify_mapping_next_hunk = '<leader>hn' " hunk next
" let g:signify_mapping_prev_hunk = '<leader>gk' 
let g:signify_mapping_toggle_highlight = '<leader>gh' 
let g:signify_line_highlight = 0 " display added/removed lines in different colors
"let g:signify_line_color_add    = 'DiffAdd'
"let g:signify_line_color_delete = 'DiffDelete'
"let g:signify_line_color_change = 'DiffChange' 
" let g:signify_mapping_toggle = '<leader>gt'
" let g:signify_sign_add =  '+'
let g:signify_sign_show_text = 0
" let g:signify_sign_add =  "\u00a0" " unbreakable space
" let g:signify_sign_delete            = "\u00a0"
" " let g:signify_sign_delete_first_line = '‾'
" let g:signify_sign_change            = "\u00a0" 
" let g:signify_sign_changedelete      = g:signify_sign_change
" let g:signify_sign_show_count|
let g:signify_vcs_cmds = {
      \'git': 'git diff --no-color --no-ext-diff -U0 master -- %f'
  \}

let g:signify_cursorhold_insert     = 0
let g:signify_cursorhold_normal     = 0
let g:signify_update_on_bufenter    = 1
let g:signify_update_on_focusgained = 1
" hunk jumping
nmap <leader>zj <plug>(signify-next-hunk)
" nnoremap <leader>sj :echomsg 'next-hunk'<CR>
nmap <leader>sk <plug>(signify-prev-hunk)

" }}}



" let g:vimtex_quickfix_open_on_warning = 0
" let g:vimtex_index_split_pos = 'below'
" let g:vimtex_view_method = 'zathura'
" "let g:vimtex_snippets_leader = ','
" let g:vimtex_latexmk_progname = 'nvr'
" let g:latex_view_general_viewer = 'zathura'
" "let g:tex_stylish = 1
" "let g:tex_flavor = 'latex'
" "let g:tex_isk='48-57,a-z,A-Z,192-255,:'

" if !exists('g:ycm_semantic_triggers')
"     let g:ycm_semantic_triggers = {}
" endif

" let g:ycm_semantic_triggers.tex = [
"     \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*,?)*',
"     \ 're!\\includegraphics([^]]*])?{[^}]*',
"     \ 're!\\(include|input){[^}]*'
"     \ ]
" "<plug>(vimtex-toc-toggle)
" "<plug>(vimtex-labels-toggle)
" autocmd FileType tex nnoremap <leader>lt <plug>(vimtex-toc-toggle)
