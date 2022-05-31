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

set splitbelow	" on horizontal splits
set splitright   " on vertical split

" }}}
" gutentags + gutenhasktags {{{
" to keep logs GutentagsToggleTrace
" some commands/functions are not available by default !!
" https://github.com/ludovicchabant/vim-gutentags/issues/152
let g:gutentags_define_advanced_commands=1
" let g:gutentags_project_root
" to ease with debug
let g:gutentags_trace=0
let g:gutentags_enabled = 1 " dynamic loading
let g:gutentags_dont_load=0 " kill once and for all
let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
                               \ {'type': 'ruby', 'file': 'Gemfile'},
                               \ {'type': 'haskell', 'glob': '*.cabal'} ]
" produce tags for haskell http://hackage.haskell.org/package/hasktags
" it will fail without a wrapper https://github.com/rob-b/gutenhasktags
" looks brittle, hie might be better
" or haskdogs
" let g:gutentags_ctags_executable_haskell = 'gutenhasktags'
let g:gutentags_ctags_executable_haskell = 'hasktags'
" let g:gutentags_ctags_extra_args
let g:gutentags_file_list_command = 'rg --files'
" gutenhasktags/ haskdogs/ hasktags/hothasktags

let g:gutentags_ctags_exclude = ['.vim-src', 'build', '.mypy_cache']
" }}}
" haskell-vim config {{{
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_disable=1
"}}}
" vim-translate-me / vim-translator / vtm {{{
" Which language that the text will be translated
let g:vtm_default_to_lang='en'
let g:vtm_default_api='bing'
"}}}
" pdf-scribe {{{
" PdfScribeInit
let g:pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
let g:pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
"}}}
" FZF config {{{
let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'down': '~40%' }

" For Commits and BCommits to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" mostly fzf mappings, use TAB to mark several files at the same time
" https://github.com/neovim/neovim/issues/4487
" nnoremap <Leader>c <Cmd>FzfCommits<CR>
" nnoremap <leader>b <Cmd>FzfBuffers<CR>
" nnoremap <leader>m <Cmd>FzfMarks<CR>
" nnoremap <leader>l <Cmd>Telescope live_grep<CR>
" nnoremap <leader>g <Cmd>FzfRg<CR>


" FzfBranches
function! SignifyUpdateBranch(branch)
  " echom 'chosen branch='.a:branch
  let g:signify_vcs_cmds = {
	\'git': 'git diff --no-color --no-ext-diff -U0 '.a:branch.' -- %f'
    \}
endfunc

function! ChooseSignifyGitCommit()

  let dict = copy(s:opts)
  let dict.sink = funcref('SignifyUpdateBranch')
  call fzf#run(dict)
  SignifyRefresh
endfunction
command! FzfSignifyChooseBranch call ChooseSignifyGitCommit()


let g:fzf_history_dir = stdpath('cache').'/fzf-history'
" Advanced customization using autoload functions
"autocmd VimEnter * command! Colors
  "\ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})
" Advanced customization using autoload functions

  " [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" Empty value to disable preview window altogether
" let g:fzf_preview_window = ''
let g:fzf_preview_window = 'right:30%'

" inspired by https://github.com/junegunn/fzf.vim/issues/664#issuecomment-476438294
" let $FZF_DEFAULT_OPTS='--layout=reverse'
" let g:fzf_layout.window =  'call FloatingFZF()'

" " Function to create the custom floating window
" function! FloatingFZF()
"   " creates a scratch, unlisted, new, empty, unnamed buffer
"   " to be used in the floating window
"   let buf = nvim_create_buf(v:false, v:true)

"   " 90% of the height
"   let height = float2nr(&lines * 0.6)
"   " 60% of the height
"   let width = float2nr(&columns * 0.8)
"   " horizontal position (centralized)
"   let horizontal = float2nr((&columns - width) / 2)
"   " vertical position (one line down of the top)
"   let vertical = 6

"   let opts = {
"         \ 'relative': 'editor',
"         \ 'row': vertical,
"         \ 'col': horizontal,
"         \ 'width': width,
"         \ 'height': height
"         \ }

"   call nvim_open_win(buf, v:true, opts)
" endfunction

" }}}
" luadev (a repl for nvim) {{{
" map 5 <Plug>(Luadev-RunLine)
" vmap 5 <Plug>(Luadev-Run)
map <Leader>lr <Plug>(Luadev-RunLine)
map <Leader>ll <Plug>(Luadev-RunLine)
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

nnoremap <kPageUp> :lprev
nnoremap <kPageDown> :lnext
nnoremap <kPageRight> :lnext
nnoremap <kPageRight> :lnext
nnoremap <k2> :echom "hello world"
" overwrite vimtex status mapping
" let @g="dawi\\gls{p}"
" nnoremap <Leader>lg @g

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

