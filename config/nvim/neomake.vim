" @return {String}
"  toadd in statusline
" function! NeomakeJobs() abort
" " s:winnr != winnr()
"   return 1
"         \ || !exists('*neomake#GetJobs')
"         \ || empty(neomake#GetJobs())
"         \ ? ''
"         \ : 'make'
" endfunction

" let g:neomake_virtualtext_current_error=1
let g:neomake_virtualtext_prefix="     >> "
let g:neomake_verbose = 1

" call neomake#quickfix#enable()

" pyflakes can't be disabled on a per error basis
" also it considers everything as error => disable
" flake8  or pycodestyle when supported
" let g:neomake_list_height=5

" how to let 'mypy' ignore warning/errors as pycodestyle does ?
" 'pycodestyle'
let g:neomake_c_maker = []
let g:neomake_c_enabled_makers = []
" let g:neomake_cpp_gcc_args = ['aosdifjoasidjfoiasjdfs']
" let g:neomake_cpp_append_file = 0
let g:neomake_cpp_enabled_makers = []
let g:neomake_logfile = $HOME.'/neomake.log'
" let g:neomake_c_gcc_args = ['-fsyntax-only', '-Wall']
let g:neomake_open_list = 2 " 0 to disable/2 preserves cursor position

let g:neomake_airline = 1
let g:neomake_echo_current_error = 1
let g:neomake_place_signs=1

" let g:neomake_python_mypy_exe = g:python3_host_prog
" let g:neomake_python_mypy_exe = fnamemodify( g:python3_host_prog, ':p:h').'/mypy'
" let g:neomake_python_mypy_args = ['-m', 'mypy']
"
" let g:neomake_python_mypymatt_maker = neomake#makers#ft#python#mypy()
" + neomake#makers#ft#python#mypy().args

" let g:neomake_haskell_enabled_makers=[]


" filters out unrecognized
function! NeomakeStatusLine()

  let bufnr = winbufnr(winnr())
  let active=0
" let neomake_status_str = neomake#statusline#get(bufnr, {
" 	\ 'format_running': '… ({{running_job_names}})',
" 	\ 'format_ok': (active ? '%#NeomakeStatusGood#' : '%*').'✓',
" 	\ 'format_quickfix_ok': '',
" 	\ 'format_quickfix_issues': (active ? '%s' : ''),
" 	\ 'format_status': '%%(%s'
" 	\   .(active ? '%%#StatColorHi2#' : '%%*')
" 	\   .'%%)',
" 	\ })

    let neomake_status_str = neomake#statusline#get(bufnr, {
          \ 'format_running': '… ({{running_job_names}})',
          \ 'format_ok': '✓',
          \ 'format_quickfix_ok': '',
          \ 'format_quickfix_issues': '%s',
          \ })
  return neomake_status_str
endfunction


" C and CPP are handled by YCM and java usually by elim
 " 'c'
let s:neomake_exclude_ft = ['cpp', 'java' ]
" let g:neomake_tex_checkers = [ '' ]
" let g:neomake_tex_enabled_makers = []
let g:neomake_tex_enabled_makers = []
"'mypy'
" disabled 'mypy' since it was generating errors
let g:neomake_python_enabled_makers = ['mypy']

" let g:neomake_python_mypy_maker.exe = g:python3_host_prog
" let g:neomake_python_mypy_maker.args = '-mmypy'

" removed chktex because of silly errors
" let g:neomake_tex_enabled_makers = ['chktex']
" let g:neomake_error_sign = {'text': '✖ ', 'texthl': 'NeomakeErrorSign'}
let g:neomake_error_sign = {'text': 'X', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '⚠ ', 'texthl': 'NeomakeWarningSign'}
" let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
" let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

hi NeomakeError guibg=red gui=undercurl
hi NeomakeWarning guibg=blue  gui=undercurl

" don't display lines that don't match errorformat
let g:neomake_remove_invalid_entries=1
" let g:neomake_highlight_lines = 1

" let g:neomake_ft_test_maker_buffer_output = 0

" commande : highlights one can use :runtime syntax/hitest.vim for testing
" Underlined/NeomakePerso/Error
" let g:neomake_error_highlight = 'Error'
let g:neomake_error_highlight = 'NeomakePerso'

" this lists directory makers to use when no file or no maker for ft
" by default 'makeprg'
" let g:neomake_enabled_makers = ['make']
    " let g:neomake_warning_highlight = 'Warning'
    " let g:neomake_message_highlight = 'Message'
    " let g:neomake_informational_highlight = 'Informational'
" let g:neomake_error_sign = { 'text': s:gutter_error_sign, 'texthl': 'ErrorSign' }
" let g:neomake_warning_sign = { 'text': s:gutter_warn_sign , 'texthl': 'WarningSign' }
"

" todo only if neomake loaded
call neomake#configure#automake('w')
" NeomakeDisable

" func update_mypy_maker
  " Hook into NeomakeJobInit.
" function! s:NeomakeTestJobInit(context) abort
"   AssertEqual keys(a:context), ['jobinfo']

"   let jobinfo = a:context.jobinfo
"   AssertEqual jobinfo.maker.name, 'mypy-matt'

"   " argv can be a list or string.
"   if type(jobinfo.argv) == type([])
"     let jobinfo.argv = ['nice', '-n18'] + jobinfo.argv
"   else
"     let jobinfo.argv = 'nice -n 18 '.jobinfo.argv
"   endif
" endfunction
" augroup neomake_tests
"     au User NeomakeJobInit call s:NeomakeTestJobInit(g:neomake_hook_context)
"     " autocmd User NeomakeJobFinished call OnNeomakeFinished()
" augroup END

