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


let g:neomake_tex_enabled_makers = []
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
" let g:neomake_error_highlight = 'NeomakePerso'

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
silent NeomakeDisable

autocmd FileType nix call neomake#configure#automake_for_buffer('w')

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

" command! BuildPhase Neomake! buildPhase
" command! BuildPhaseTest Neomake! nix

" todo pass a flag to call configure ?
" nnoremap <F4> :BuildPhase<CR>
" nnoremap <F5> :Neomake! make<CR>
"

" TODO replace with getroot of directory ?
" let g:neomake_build_folder_maker = {
"     \ 'exe': 'make',
"     \ 'args': [],
"     \ 'cwd': getcwd().'/build',
"     \ 'errorformat': '%f:%l:%c: %m',
"     \ 'remove_invalid_entries': 0,
"     \ 'buffer_output': 0
"     \ }


" called like this let returned_maker = call(maker.fn, [options], maker)
function! Check_build_folder(opts, ) abort dict

  " todo check for nix-shell
  if isdirectory("build")
    let self.cwd = getcwd().'/build'
  endif

  if !exists("$IN_NIX_SHELL")
    echom "You are not in a nix-shell"
  endif

  return self
endfunction

" will run nix-shell
" source $stdenv/setup
" \ 'cwd': getcwd().'/build',
" fn is not well documented
let g:neomake_buildPhase_maker = {
    \ 'exe': '/home/teto/dotfiles/bin/nix-shell-maker.sh',
    \ 'args': [],
    \ 'errorformat': '%f:%l:%c: %m',
    \ 'remove_invalid_entries': 0,
    \ 'buffer_output': 0,
    \ 'InitForJob': function('Check_build_folder')
    \ }
