" ALE {{{
" let deoplete handle completion
let g:ale_completion_enabled = 0
" let g:ale_completion_delay=
" g:ale_completion_max_suggestions
" g:ale_completion_excluded_words or b:ale_completion_excluded_words
" g:ale_set_balloons gcc
" ALEGoToDefinition
"" Set this. Airline will handle the rest.
" Only run linters named in ale_linters settings.
" let g:ale_linters_explicit = 1

let g:ale_set_loclist=1
let g:ale_echo_cursor = 1
let g:ale_history_enabled = 1


" let g:ale_lint_on_enter=
let g:ale_lint_on_text_changed = 'never'
let g:ale_virtualtext_cursor = 1
" let g:ale_virtualtext_delay = 10

let g:ale_sign_error='✖'
let g:ale_sign_warn='⚠'
let g:ale_sign_info='ℹ'
let g:ale_sign_style_error='E'
let g:ale_sign_style_warning='W'
  " |ALEVirtualTextError|        - Items with `'type': 'E'`
  " |ALEVirtualTextWarning|      - Items with `'type': 'W'`
  " |ALEVirtualTextInfo|         - Items with `'type': 'I'`
  " |ALEVirtualTextStyleError|   - Items with `'type': 'E'` and `'sub_type': 'style'`
  " |ALEVirtualTextStyleWarning| - Items with `'type': 'W'` and `'sub_type': 'style'`

" let g:ale_linters = {'haskell': ['eslint']}

hi ALEVirtualTextError guisp=undercurl


" nnoremap <silent> gh :ALEGoToDefinition<CR>
" nnoremap <silent> gd :ALEGoToDefinition<CR>
" nnoremap <silent> gr :ALEFindReferences<CR>
" nnoremap <silent> gs :ALESymbolSearch<CR>

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)
" ale#linter#Define(filetype, linter)
"}}}

