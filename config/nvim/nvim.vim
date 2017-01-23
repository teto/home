let s:path = expand('<sfile>:p:h')
let s:target = 'all'
let s:error_path = s:path.'/tmp/errors.json'
let s:errors_url = 'https://raw.githubusercontent.com/neovim/doc/gh-pages/reports/clint/errors.json'

function! s:dl_handler(job, data, event) abort
  if a:event == 'stdout'
    for line in a:data
      if line =~? '^Content-Length:'
        let self.remote_size = str2nr(matchstr(line, '\d\+'))
      endif
    endfor
  elseif a:event == 'exit'
    if self.size != self.remote_size
      echomsg 'Updating errors.json'
      call jobstart('curl -sSL "'.s:errors_url.'" > "'.s:error_path.'"')
    else
      echomsg 'errors.json is up to date'
    endif
  endif
endfunction

function! s:download_errors_json() abort
  let opts = {'size': 0, 'remote_size': 0,
        \ 'on_stdout': 's:dl_handler', 'on_exit': 's:dl_handler'}
  if filereadable(s:error_path)
    let opts.size = getfsize(s:error_path)
  endif
  call jobstart(['curl', '-sI', s:errors_url], opts)
endfunction

function! s:setup_c() abort
  setlocal expandtab shiftwidth=2 softtabstop=2 textwidth=80
  setlocal modelines=0 cinoptions=0(
  setlocal comments=:///,://
endfunction

function! s:neomake_project_finished(mode) abort
  if !a:mode && len(filter(getqflist(), 'v:val.valid'))
    let buf = getqflist()[0].bufnr
    if buf != winbufnr(0)
      if exists('s:last_win') && winbufnr(s:last_win) == buf
        let win = s:last_win
      else
        let win = bufwinnr(buf)
      endif
      execute win 'wincmd w'
    endif
    belowright cwindow 5
    let w:quickfix_title = 'Neomake!'
    wincmd p
  endif
  unlet! s:last_win
endfunction

let g:neomake_make_maker = {
      \ 'exe': 'make',
      \ 'args': ['VERBOSE=1', 'dev'],
      \ 'errorformat': '../%f:%l:%c: %t%.%#: %m',
      \ }

let g:neomake_c_enabled_makers = ['nvimlint']
let g:neomake_c_nvimlint_maker = {
      \ 'exe': s:path.'/src/clint.py',
      \ 'append_file': 0,
      \ 'args': ['--suppress-errors='.s:path.'/tmp/errors.json', '%'],
      \ 'cwd': s:path,
      \ 'errorformat': '%f:%l: %m',
      \ }

let g:neomake_c_nvimtags_maker = {
      \ 'exe': 'ctags',
      \ 'append_file': 0,
      \ 'args': ['-R', 'src', 'build/src/nvim/auto'],
      \ 'cwd': s:path,
      \ }

let g:neomake_lua_testlint_maker = {
      \ 'exe': 'make testlint',
      \ }

augroup nvimrc
  autocmd!
  autocmd VimEnter * call s:download_errors_json()
  autocmd User NeomakeFinished call s:neomake_project_finished(g:neomake_hook_context.file_mode)
  autocmd BufWritePost *.c,*.h,*.vim if !exists('s:last_win') | let s:last_win = winnr() | cclose | Neomake! make | endif
  autocmd BufRead,BufNewFile *.h set filetype=c
  autocmd FileType c call s:setup_c()
  " autocmd BufWritePost * Neomake
  " autocmd VimLeave * let g:neomake_verbose = 0
augroup END
