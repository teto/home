let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

let g:ycm_confirm_extra_conf = 0

let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" g:ycm_show_diagnostics_ui=1
"let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'debug'


nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <F6> :YcmDebugInfo<CR>

"You may also want to map the subcommands to something less verbose; for instance, nnoremap <leader>jd :YcmCompleter GoTo<CR> maps the <leader>jd sequence to the longer subcommand invocation.

"The various GoTo* subcommands add entries to Vim's jumplist so you can use CTRL-O to jump back to where you where before invoking the command (and CTRL-I to jump forward; see :h jumplist for details).

nnoremap <leader>jd :YcmCompleter GoTo<CR>

