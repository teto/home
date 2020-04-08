" Deoplete {{{
" or call |deoplete#enable()|
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
" let g:deoplete#disable_auto_complete = 0
let g:deoplete#enable_debug = 1
let g:deoplete#auto_complete_delay=0

call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')

" call deoplete#custom#option({
" \ 'auto_complete': v:true,
" \ 'auto_complete_delay': 0,
" \ 'smart_case': v:true,
" \ 'refresh_always': v:true,
" \ 'dup': v:false
" \ })

" " source
" call deoplete#custom#var('around', {
" \   'range_above': 15,
" \   'range_below': 15,
" \   'mark_above': '[↑]',
" \   'mark_below': '[↓]',
" \   'mark_changes': '[*]',
" \})

" " deoplete#toggle()
" call deoplete#custom#source('perso', { 'matt' : 'mattator@gmail.com' })
" call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])
" call deoplete#custom#source('_', 'sorters', [])

" let g:deoplete#keyword_patterns = {}
" let g:deoplete#keyword_patterns.gitcommit = '.+'

" call deoplete#custom#option('profile', v:true)
" call deoplete#custom#source('jedi', 'is_debug_enabled', 1)

" call deoplete#custom#set('jedi', 'debug_enabled', 1)

" fails
" call deoplete#util#set_pattern(
"   \ g:deoplete#omni#input_patterns,
"   \ 'gitcommit', [g:deoplete#keyword_patterns.gitcommit])
" deoplete clang {{{2

let g:deoplete#sources#clang#std#cpp = 'c++11'
let g:deoplete#sources#clang#sort_algo = 'priority'
" let g:deoplete#sources#clang#clang_complete_database = '/home/user/code/build'`


" Let <Tab> also do completion
" inoremap <silent><expr> <Tab>
" \ pumvisible() ? "<C-n>" :
" \ deoplete#mappings#manual_complete()
" nnoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" }}}
" deoplete jedi {{{2
let deoplete#sources#jedi#enable_cache=1
let deoplete#sources#jedi#show_docstring=0
" slow down completion
let g:deoplete#sources#jedi#enable_typeinfo=1
" show docstring in completion window
let g:deoplete#sources#jedi#show_docstring=1
" }}}
" deoplete github (disabled for now won't work) {{{
" let g:deoplete#sources = {}
" let g:deoplete#sources.gitcommit=['github']
" " let g:deoplete#keyword_patterns = {}
" let g:deoplete#keyword_patterns.gitcommit = '.+'

" call deoplete#util#set_pattern(
"   \ g:deoplete#omni#input_patterns,
"   \ 'gitcommit', [g:deoplete#keyword_patterns.gitcommit])

"}}}
" deoplete notmuch
" notmuch address command to fetch completions
" NOTE: --format=sexp is required
" use dict instead generated 
" let g:deoplete#sources#notmuch#command = ['notmuch', 'address', '--format=sexp', '--output=recipients', '--deduplicate=address', 'tag:inbox']
" }}}

