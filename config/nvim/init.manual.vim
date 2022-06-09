" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" ❌

" vim-plug installation {{{
" TODO use stdpath now
" let s:nvimdir = stdpath('data')
" let s:plugscript = s:nvimdir.'/autoload/plug.vim'
" let s:plugdir = s:nvimdir.'/site'

" " to allow line-continuation in vim otherwise plug autoinstall fails
" if empty(glob(s:plugscript))
"   execute "!mkdir -p " s:nvimdir.'/autoload' s:plugdir
"   execute "!curl -fLo" s:plugscript '--create-dirs'
" 		\ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" 		  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif


" let g:plug_shallow=1
" " let g:plug_threads
" call plug#begin(s:plugdir)
" call plug#end()
" }}}


" to load plugins in ftplugin matching ftdetect
filetype plugin on
" Window / splits {{{
"cmap w!! w !sudo tee % >/dev/null
" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
nmap <silent> <C-Up> <cmd>wincmd k<CR>
nmap <silent> <C-Down> <cmd>wincmd j<CR>
nmap <silent> <C-Left> <cmd>wincmd h<CR>
nmap <silent> <C-Right> <cmd>wincmd l<CR>

nmap  <D-Up> :wincmd k<CR>
nmap <silent> <D-Down> :wincmd j<CR>
nmap <silent> <D-Left> :wincmd h<CR>
nmap <silent> <D-Right> :wincmd l<CR>

" }}}

" Code to display highlight groups {{{
" https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
" Once you have the name of the highlight group, you can run:
" verbose high <Name>
" nmap <leader>sp :call <SID>SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}

" FzfBranches
function! SignifyUpdateBranch(branch)
  " echom 'chosen branch='.a:branch
  let g:signify_vcs_cmds = {
	\'git': 'git diff --no-color --no-ext-diff -U0 '.a:branch.' -- %f'
    \}
endfunc

nnoremap <kPageUp> :lprev
nnoremap <kPageDown> :lnext
nnoremap <kPageRight> :lnext
nnoremap <kPageRight> :lnext
nnoremap <k2> :echom "hello world"
" overwrite vimtex status mapping
" let @g="dawi\\gls{p}"
" nnoremap <Leader>lg @g
function! ChooseSignifyGitCommit()

  let dict = copy(s:opts)
  let dict.sink = funcref('SignifyUpdateBranch')
  call fzf#run(dict)
  SignifyRefresh
endfunction
command! FzfSignifyChooseBranch call ChooseSignifyGitCommit()

function! Genmpack(file)
    let t = readfile(a:file)
    let j = json_decode(t)
    " echo 'Decoded json'.string(j)
    let m = msgpackdump(j)
    call writefile(m, 'fname.mpack', 'b')
endfunc

" from justinmk
func! ReadExCommandOutput(newbuf, cmd) abort
  redir => l:message
  silent! execute a:cmd
  redir END
  if a:newbuf | wincmd n | endif
  silent put=l:message
endf
command! -nargs=+ -bang -complete=command R call ReadExCommandOutput(<bang>0, <q-args>)


"linewise partial staging in visual-mode.
xnoremap <c-p> <Cmd>diffput<cr>
xnoremap <c-o> <Cmd>diffget<cr>


" set foldtext=TestFoldTextWithColumns()
function! TestFoldTextWithColumns()
  let line = getline(v:foldstart)
  let res = ""
  " v:foldstart / v:foldend
  if exists("v:foldstartcol")
    let res = "foldstartcol exists :". v:foldstartcol
  endif
  return res . " toto" . repeat(" ", 4)
endfunc

