" coc.nvim {{{
" Note: yarn is not required if you want to manage extensions using a vim
" plugin manager such as vim-plug.
" set by nix
" let g:coc_node_path=
" coc-yank / coc-vimtex / coc-lua
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" don't give |ins-completion-menu| messages.
set shortmess+=c
" coc.nvim uses its custom json that accepts comments like //
autocmd FileType json syntax match Comment +\/\/.\+$+

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> [[ <Plug>(coc-diagnostic-prev)
nmap <silent> ]] <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

" keep it to go to last insertion
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    if (CocAction('doHover')) == v:false && &ft == "haskell"
	" 	let result=coc#util#echo_line()
	" 	echom result
	" 	if result == tpl
	" 		echom "haskell fallback"
	" 	endif
		execute '!hoogle '.expand('<cword>')
	endif
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" " Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

call coc#config('diagnostic', {
			\ "diagnostic.enable": v:true,
  			\ "diagnostic.errorSign": ">>",
			\ })
" diagnostic.warningSign": "⚠",
" diagnostic.infoSign": ">>",
" diagnostic.hintSign": ">>",


let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
"}}}
" coc-snippets {{{
" CocList snippets 
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" }}}
" navigate chunks of current buffer{{{
" nmap [g <Plug>(coc-git-prevchunk)
" nmap ]g <Plug>(coc-git-nextchunk)
" " show chunk diff at current position
" nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
" nmap gc <Plug>(coc-git-commit) " nope ! used by commentary
"}}}
" coc-translator {{{
" popup
nmap <Leader>te <Plug>(coc-translator-p)
" echo 
" nmap <Leader>te <Plug>(coc-translator-e)
" " replace
" nmap <Leader>ter <Plug>(coc-translator-r)
"}}}



" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
