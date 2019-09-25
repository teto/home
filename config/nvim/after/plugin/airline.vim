" Moved here since I install it via nix and thus when nvim isn't wrapped it
" fails pathetically
" Airline {{{
" debug with :AirlineExtensions
" to speed up things

" 'neomake', 
" check with :AirlineExtensions
let g:airline_extensions = [
	'obsession',
	'quickfix',
	'tabline',
	'wordcount',
	'grepper',
	'gutentags',
	'vimtex',
	'coc',
	]
let g:airline#extensions#coc#enabled = 1

" let g:airline#extensions#default#layout = [
"     \ [ 'a', 'b', 'c' ],
"     \ [ 'x', 'y', 'z', 'error', 'warning' ]
"     \ ]
" let g:airline#extensions#wordcount#filetypes = ...

let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#neomake#enabled = 1
let g:airline#extensions#languageclient#enabled = 1

let g:airline_highlighting_cache = 1
let g:airline_exclude_preview = 0
" control which sections get truncated and at what width. >
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }


let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

let g:airline_highlighting_cache = 1 " to speed up things
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section = '|'
" display buffers as tabs if no split
" see :h airline-tabline
let g:airline_theme = 'molokai'
" let g:airline_section_b = '%#TermCursor#' . NeomakeJobs()

" first array is left-side, followed by right side
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z', 'error', 'warning' ]
      \ ]
" section y is fileencoding , useless in neovim
" define_raw
" call airline#parts#define_function('neomake_custom', 'NeomakeStatusLine')
" let g:airline_section_y = airline#section#create_right(['neomake_custom','ffenc'])

" let g:airline_section_y = airline#section#create_right(['neomake'])
" let g:airline_section_y = airline#section#create_right(['neomake','ffenc'])
call airline#parts#define_function('grepper', 'grepper#statusline')
" see :h airline-default-sections
let g:airline_section_x = airline#section#create_right(['grepper'])
" let g:airline_section_y = airline#section#create_right(['neomake_error_count', 'neomake_warning_count'])
" let g:airline_section_z = airline#section#create_right(['neomake_error_count', 'neomake_warning_count'])
" let g:airline_section_error = airline#section#create_right(['neomake_error_count', 'languageclient_error_count'])
" let g:airline_section_warning (ycm_warning_count, syntastic-warn,

" grepper#statusline()
 " airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
" let g:airline_section_z = airline#section#create_right(['linenumber'])
" airline extensions {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#vimtex#enabled=1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_min_count =2
let g:airline#extensions#tabline#tab_min_count = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_tabs = 0
let airline#extensions#tabline#current_first = 0
" to rely on badd only ?
" let airline#extensions#tabline#disable_refresh = 0

let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline_extensions = ['branch', 'tabline', 'obsession']

" rely on tagbar plugin
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'

" csv plugin
let g:airline#extensions#csv#enabled = 1
let g:airline_detect_spell=1

" ycm integration
let g:airline#extensions#ycm#enabled = 0
let g:airline#extensions#ycm#error_symbol = s:gutter_error_sign
let g:airline#extensions#ycm#warning_symbol = s:gutter_warn_sign

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2

let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = ''
"}}}

" let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long' ]
"|neomake#statusline#LoclistStatus should be shown in warning section
" let &statusline .= ' %{grepper#statusline()}'
" let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}'])
" airline mappings {{{
nmap <leader>& <Plug>AirlineSelectTab1
nmap <leader>é <Plug>AirlineSelectTab2
nmap <leader>" <Plug>AirlineSelectTab3
nmap <leader>' <Plug>AirlineSelectTab4
nmap <leader>( <Plug>AirlineSelectTab5
nmap <leader>- <Plug>AirlineSelectTab6
nmap <leader>è <Plug>AirlineSelectTab7
nmap <leader>è <Plug>AirlineSelectTab7
nmap <leader>_ <Plug>AirlineSelectTab8
nmap <leader>ç <Plug>AirlineSelectTab9

" qwerty version
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab

"}}}
" one could change the formatter with
  " let g:airline#extensions#tabline#formatter = 'default'
"}}}

