" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" ❌
" git diff http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/ {{{
" the left window contains the version from the target branch
" the middle window contains the working copy of the file, complete with conflict markers
" the right window contains the version from the merge branch
" }}}


let mapleader = " "
let maplocalleader = ","


" vim-plug autoinstallation {{{
" TODO use stdpath now
let s:nvimdir = stdpath('data')
let s:plugscript = s:nvimdir.'/autoload/plug.vim'
let s:plugdir = s:nvimdir.'/site'

" to allow line-continuation in vim otherwise plug autoinstall fails
set nocompatible
if empty(glob(s:plugscript))
  execute "!mkdir -p " s:nvimdir.'/autoload' s:plugdir
  execute "!curl -fLo" s:plugscript '--create-dirs'
		\ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"}}}

" VIM-PLUG PLUGIN DECLARATIONS {{{1
" vim-plug config {{{
let g:plug_shallow=1
" let g:plug_threads
"}}}
call plug#begin(s:plugdir)
Plug 'rhysd/vim-gfm-syntax' " markdown syntax compatible with Github's
" Plug 'symphorien/vim-nixhash' " use :NixHash
" Plug 'vim-denops/denops.vim'
" Plug 'ryoppippi/bad-apple.vim' " needs denops

" recommanded branch faster

" Plug 'eugen0329/vim-esearch' " search & replace
Plug '~/neovim/neovim-ui'
" Plug 'kshenoy/vim-signature' " display marks in gutter, love it

" Plug '~/pdf-scribe.nvim'  " to annotate pdf files from nvim :PdfScribeInit

" annotations plugins {{{
Plug 'MattesGroeger/vim-bookmarks' " ruby  / :BookmarkAnnotate
" 'wdicarlo/vim-notebook' " last update in 2016
" 'plutonly/vim-annotate" "  last update in 2015
"}}}

" Plug 'norcalli/nvim-terminal.lua' " to display ANSI colors
Plug '~/neovim/nvim-terminal.lua' " to display ANSI colors
Plug 'bogado/file-line' " to open a file at a specific line
" Plug 'glacambre/firenvim' " to use nvim in firefox
" call :NR on a region than :w . coupled with b:nrrw_aucmd_create,
" Plug 'chrisbra/NrrwRgn' " to help with multi-ft files
Plug 'chrisbra/vim-diff-enhanced' "

Plug 'rhysd/git-messenger.vim' " to show git message :GitMessenger

" Plug 'tweekmonster/nvim-api-viewer', {'on': 'NvimAPI'} " see nvim api
" provider
" needs ruby support, works in recent neovim
" Plug 'junegunn/vim-github-dashboard', { 'do': ':UpdateRemotePlugins' }
" while waiting for my neovim notification provider...

" Plug 'dbakker/vim-projectroot' " projectroot#guess()

" REPL (Read Execute Present Loop) {{{
" Plug 'metakirby5/codi.vim', {'on': 'Codi'} " repl
" careful it maps cl by default
" Plug 'jalvesaq/vimcmdline' " no help files, mappings clunky
" github mirror of Plug 'http://gitlab.com/HiPhish/repl.nvim'
" Plug 'http://gitlab.com/HiPhish/repl.nvim' " no commit for the past 2 years
" vimcmdline mappings{{{
let cmdline_map_start          = "<LocalLeader>s"
let cmdline_map_send           = "<Space>"
let cmdline_map_source_fun     = "<LocalLeader>f"
let cmdline_map_send_paragraph = "<LocalLeader>p"
let cmdline_map_send_block     = "<LocalLeader>b"
let cmdline_map_quit           = "<LocalLeader>q"

" vimcmdline options
let cmdline_vsplit             = 1      " Split the window vertically
let cmdline_esc_term           = 1      " Remap <Esc> to :stopinsert in Neovim terminal
let cmdline_in_buffer          = 1      " Start the interpreter in a Neovim buffer
let cmdline_term_height        = 15     " Initial height of interpreter window or pane
let cmdline_term_width         = 80     " Initial width of interpreter window or pane
let cmdline_tmp_dir            = '/tmp' " Temporary directory to save files
let cmdline_outhl              = 1      " Syntax highlight the output

" configure interpreters
let cmdline_app           = {}
let cmdline_app["python"] = "ptipython3" " prompt toolkit + ipython
let cmdline_app["ruby"]   = "pry"
let cmdline_app["sh"]     = "bash"

let cmdline_follow_colorscheme = 1
let cmdline_external_term_cmd = "termite -e '%s' &"
"}}}
"}}}
" " Snippets are separated from the engine. Add this if you want them:

" Plug 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
" Plug 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting
Plug 'tpope/vim-rhubarb' " github support in fugitive, use |i_CTRL-X_CTRL-O|


call plug#end()
" }}}


" to load plugins in ftplugin matching ftdetect
filetype plugin on
" syntax on
" Dirvish {{{
let g:loaded_netrwPlugin = 1 " ???
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
" }}}
" Dealing with pdf {{{
" Read-only pdf through pdftotext / arf kinda fails silently on CJK documents
" autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

" convert all kinds of files (but pdf) to plain text
autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
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
" Wildmenu completion {{{

" display a menu when need to complete a command
set wildchar=<Tab>
" list:longest, " list breaks the pum
set wildmode=longest,list " 'longest,list' => fills out longest then show list
" set wildoptions+=pum

" }}}
" Modeliner shortcuts  {{{
nmap <leader>ml <Cmd>Modeliner<Enter>
let g:Modeliner_format = 'et ff= fenc= sts= sw= ts= fdm='
" }}}
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

" nmap <silent> <M-Up> :wincmd k<CR>
" nmap <silent> <M-Down> :wincmd j<CR>
" nmap <silent> <M-Left> :wincmd h<CR>
" nmap <silent> <M-Right> :wincmd l<CR>


" For comparison
"nnoremap p :echom "p"<cr>
"nnoremap <S-p> :echom "S-p"<cr>
"nnoremap <C-p> :echom "C-p"<cr>
"nnoremap <C-S-p> :echom "C-S-p"<cr>
"nnoremap <M-p> :echom "M-p"<cr>
"nnoremap <M-S-p> :echom "M-S-p"<cr>
"nnoremap <C-M-p> :echom "C-M-p"<cr>
"nnoremap <C-M-S-p> :echom "C-M-S-p"<cr>


"wnmap = *normal mode* mapping
"nmap <silent> ^[OC :wincmd l<CR>
"nmap <silent> ^[OC :wincmd h<CR>
"nmap <silent> OC :wincmd l<CR>
"nmap <silent> OD :wincmd h<CR>

" window nmap <leader>sw<left>  :topleft  vnew<CR>
" nmap <leader>sw<right> :botright vnew<CR>
" nmap <leader>sw<up>    :topleft  new<CR>
" nmap <leader>sw<down>  :botright new<CR>

" nnoremap <silent> + :exe "resize +3"
" nnoremap <silent> - :exe "resize -3"

set splitbelow	" on horizontal splits
set splitright   " on vertical split

" }}}
" vim-lastplace to restore cursor position {{{
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
" }}}
" Gruvbox config {{{
" contrast can be soft/medium/hard
" there are other many options
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"
" }}}
" dirvish {{{
let g:dirvish_mode=2
"}}}
" firenvim {{{
let g:firenvim_config = {
    \ 'localSettings': {
        \ '.*': {
            \ 'selector': 'textarea',
            \ 'priority': 0,
        \ }
    \ }
\ }
"}}}
" vim-pad {{{
let g:pad#dir=$XDG_DATA_HOME"/notes"
let g:pad#set_mappings=0
let g:pad#silent_on_mappings_fail=1
let g:pad#default_format = "markdown"
nmap <leader>pl <Plug>(pad-list)
nmap <leader>ps <Plug>(pad-search)
nmap <leader>pn <Plug>(pad-new)

" let g:pad#rename_files = 0
"}}}
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
" Startify config {{{
" nnoremap <Leader>st :Startify<cr>

let g:startify_list_order = [
      \ ['   MRU '.getcwd()], 'dir',
      \ ['   MRU'],           'files' ,
      \ ['   Bookmarks'],     'bookmarks',
      \ ['   Sessions'],      'sessions',
      \ ]
let g:startify_use_env = 0
let g:startify_disable_at_vimenter = 0
let g:startify_session_dir = stdpath('data').'/nvim/sessions'
let g:startify_bookmarks = [
      \ {'i': $XDG_CONFIG_HOME.'/i3/config.main'},
      \ {'h': $XDG_CONFIG_HOME.'/nixpkgs/home.nix'},
      \ {'c': 'dotfiles/nixpkgs/configuration.nix'},
      \ {'z': $XDG_CONFIG_HOME.'/zsh/'},
      \ {'m': $XDG_CONFIG_HOME.'/mptcpanalyzer/config'},
      \ {'n': $XDG_CONFIG_HOME.'/nvim/config'},
      \ {'N': $XDG_CONFIG_HOME.'/ncmpcpp/config'},
      \ ]
      " \ {'q': $XDG_CONFIG_HOME.'/qutebrowser/qutebrowser.conf'},
let g:startify_files_number = 10
let g:startify_session_autoload = 1
let g:startify_session_persistence = 0
let g:startify_change_to_vcs_root = 0
let g:startify_session_savevars = []
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 0

let g:startify_relative_path = 0
" let g:startify_skiplist=[]
" }}}
" goyo {{{
let g:goyo_linenr=1
let g:goyo_height= '90%'
let g:goyo_width = 120
" }}}
" Vimtex configuration {{{
" Pour le rappel
" <localleader>ll pour la compilation continue du pdf
" <localleader>lv pour la preview du pdf
" see https://github.com/lervag/vimtex/issues/1058
" let g:vimtex_log_ignore 
" taken from https://castel.dev/post/lecture-notes-1/
let g:tex_conceal='abdmg'
let g:vimtex_log_verbose=1
let g:vimtex_quickfix_open_on_warning = 1
let g:vimtex_view_automatic=1
let g:vimtex_view_enabled=1
" was only necessary with vimtex lazy loaded
" let g:vimtex_toc_config={}
" let g:vimtex_complete_img_use_tail=1
" autoindent can slow down vim quite a bit
" to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
let g:vimtex_indent_enabled=0
let g:vimtex_indent_bib_enabled=1
let g:vimtex_compiler_enabled=1 " enable new style vimtex
let g:vimtex_compiler_progname='nvr'
" let g:vimtex_compiler_method=
" possibility between pplatex/pulp/latexlog
" Note: `pplatex` and `pulp` require that `-file-line-error` is NOT passed to the LaTeX
  " compiler. |g:vimtex_compiler_latexmk| will be updated automatically if one
" let g:vimtex_quickfix_method="latexlog"
let g:vimtex_quickfix_method="latexlog"
" todo update default instead with extend ?
" let g:vimtex_quickfix_latexlog = {
"       \ 'underfull': 0,
"       \ 'overfull': 0,
"       \ 'specifier changed to': 0,
"       \ }
" let g:vimtex_quickfix_blgparser=
" g:vimtex_quickfix_autojump

let g:vimtex_quickfix_mode = 2 " 1=> opened automatically and becomes active (2=> inactive)
let g:vimtex_indent_enabled=0
let g:vimtex_indent_bib_enabled=1
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_format_enabled = 0
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_complete_close_braces = 0
let g:vimtex_fold_enabled = 0
let g:vimtex_view_use_temp_files=1 " to prevent zathura from flickering
let g:vimtex_syntax_minted = [
      \ {
      \   'lang' : 'json',
      \ }]
" with being on anotherline
      " \ 'Biber reported the following issues',
      " \ "Invalid format of field 'month'"

" shell-escape is mandatory for minted
" check that '-file-line-error' is properly removed with pplatex
" executable The name/path to the latexmk executable. 
let g:vimtex_compiler_latexmk = {
        \ 'backend' : 'nvim',
        \ 'background' : 1,
        \ 'build_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'options' : [
        \   '-pdf',
        \   '-file-line-error',
        \   '-bibtex',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \   '-shell-escape',
        \ ],
        \}
        " \   '-verbose',

" if !exists('g:deoplete#omni#input_patterns')
"     let g:deoplete#omni#input_patterns = {}
" endif

" let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
"<plug>(vimtex-toc-toggle)
" au BufEnter *.tex exec ":setlocal spell spelllang=en_us"
"" }}}
" vim-listchars config {{{
    "\"trail:·,tab:→\ ,eol:↲,precedes:<,extends:>"
"let g:listchar_formats=[
   "\"trail:·",
    "\"trail:>"
   "\]
    "\"extends:>"
" while waiting to finish my vim-listchars plugin
"set listchars=tab:»·,eol:↲,nbsp:␣,extends:…
"|

" ⋅
set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
" set listchars+=conceal:X
" conceal is used by deefault if cchar does not exit
set listchars+=conceal:❯
" }}}
" vim-signature {{{
" :SignatureListMarkers         : List all markers
let g:SignatureMarkTextHLDynamic=0
let g:SignatureEnabledAtStartup=1
let g:SignatureWrapJumps=1
let g:SignatureDeleteConfirmation=1
let g:SignaturePeriodicRefresh=1
" }}}
" riv restdown config {{{
let g:riv_disable_folding=1
let g:riv_disable_indent=0
" }}}
" nvimdev {{{
" call nvimdev#init("path/to/neovim")
let g:nvimdev_auto_init=1
let g:nvimdev_auto_cd=1
" let g:nvimdev_auto_ctags=1
let g:nvimdev_auto_lint=1
let g:nvimdev_build_readonly=1

function! VarToggle(key)
  " hopefully neomake should enable/disable that on a per buffer basis
  let l:val = eval(a:key)
  if l:val
    exec "let ".a:key."=0"
  else

    exec "let ".a:key."=1"
    " let g:nvimdev_auto_lint=1
  endif
endfunc

" does not work as neomake won"'t take into account
" command! NvimLintToggle :call VarToggle("g:nvimdev_auto_lint")
        " \ 'remove_invalid_entries': get(g:, 'neomake_remove_invalid_entries', 0),
"}}}
" dasht{{{

" When in Python, also search NumPy, SciPy, and Pandas:
let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']

" search related docsets
nnoremap <Leader>k :Dasht<Space>

" search ALL the docsets
nnoremap <Leader><Leader>k :Dasht!<Space>

" search related docsets
nnoremap ,k <Cmd>call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>

" search ALL the docsets
nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>
"}}}}}}
" vim-translate-me / vim-translator / vtm {{{
" Which language that the text will be translated
let g:vtm_default_to_lang='en'
let g:vtm_default_api='bing'
" Type <Leader>t to translate the text under the cursor, print in the cmdline
" nmap <silent> <Leader>t <Plug>Translate
" vmap <silent> <Leader>t <Plug>TranslateV
" Type <Leader>w to translate the text under the cursor, display in the popup window
" nmap <silent> ,te <Plug>TranslateW
" vmap <silent> ,te <Plug>TranslateWV
" Type <Leader>r to translate the text under the cursor and replace the text with the translation
" nmap <silent> <Leader>r <Plug>TranslateR
" vmap <silent> <Leader>r <Plug>TranslateRV
"}}}
" repl.nvim (from hiphish) {{{
" let g:repl['lua'] = {
"     \ 'bin': 'lua',
"     \ 'args': [],
"     \ 'syntax': '',
"     \ 'title': 'Lua REPL'
" \ }
" Send the text of a motion to the REPL
nmap <leader>rs  <Plug>(ReplSend)
" Send the current line to the REPL
nmap <leader>rss <Plug>(ReplSendLine)
nmap <leader>rs_ <Plug>(ReplSendLine)
" Send the selected text to the REPL
vmap <leader>rs  <Plug>(ReplSend)
" }}}
" iron.nvim {{{
" cp = repeat the previous command
" ctr send a chunk of text with motion
" nmap <localleader>t <Plug>(iron-send-motion)
let g:iron_repl_open_cmd="vsplit"
let g:iron_map_defaults=0
let g:iron_map_extended=0
"}}}
" alok/notational-fzf-vim {{{
" use c-x to create the note
" let g:nv_search_paths = []
let g:nv_search_paths = ['~/Nextcloud/Notes']
let g:nv_default_extension = '.md'
let g:nv_show_preview = 1
let g:nv_create_note_key = 'ctrl-x'

" String. Default is first directory found in `g:nv_search_paths`. Error thrown
"if no directory found and g:nv_main_directory is not specified
"let g:nv_main_directory = g:nv_main_directory or (first directory in g:nv_search_paths)
"}}}
" quickhl (highlight certains words {{{
nmap <Space>w <Plug>(quickhl-manual-this)
xmap <Space>w <Plug>(quickhl-manual-this)
nmap <Space>W <Plug>(quickhl-manual-reset)
xmap <Space>W <Plug>(quickhl-manual-reset)

"}}}
" pdf-scribe {{{
" PdfScribeInit
let g:pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
let g:pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
"}}}
" vsnip {{{
let g:vsnip_snippet_dir = stdpath('config').'/vsnip'
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
" nnoremap <Leader>o <Cmd>FzfFiles<CR>
" nnoremap <Leader>g <Cmd>FzfGitFiles<CR>
" nnoremap <Leader>F <Cmd>FzfFiletypes<CR>
" nnoremap <Leader>h <Cmd>FzfHistory<CR>
nnoremap <Leader>c <Cmd>FzfCommits<CR>
" nnoremap <Leader>C <Cmd>FzfColors<CR>
nnoremap <leader>b <Cmd>FzfBuffers<CR>
nnoremap <leader>m <Cmd>FzfMarks<CR>
" nnoremap <leader>l <Cmd>FzfLines<CR>
nnoremap <leader>l <Cmd>Telescope live_grep<CR>
" nnoremap <leader>t <Cmd>FzfTags<CR>
" nnoremap <leader>T <Cmd>FzfBTags<CR>
nnoremap <leader>g <Cmd>FzfRg<CR>


function! SeeLineHistory()

  let file=expand('%')
  let line=line('.')
  let cmd= 'git log --format=format:%H '.file.' | xargs -L 1 git blame '.file.' -L '.line.','.line
  call termopen(cmd)
endfunc

let s:opts = {
  \ 'source': "git branch -a",
  \ 'options': ' --prompt "Misc>"',
  \ 'down': '50%',
  \ }
  " \ 'sink': function('s:processResult'),


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


" Customize fzf colors to match your color scheme
" let g:fzf_colors = \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment']
" }

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

imap <c-x><c-f> <plug>(fzf-complete-path)
" inspired by https://github.com/junegunn/fzf.vim/issues/664#issuecomment-476438294
" let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout.window =  'call FloatingFZF()'

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 90% of the height
  let height = float2nr(&lines * 0.6)
  " 60% of the height
  let width = float2nr(&columns * 0.8)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = 6

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" }}}
" luadev (a repl for nvim) {{{
" map 5 <Plug>(Luadev-RunLine)
" vmap 5 <Plug>(Luadev-Run)
map <Leader>lr <Plug>(Luadev-RunLine)
map <Leader>ll <Plug>(Luadev-RunLine)
" }}}
" himalaya {{{
let g:himalaya_telescope_preview_enabled = 0
let g:himalaya_mailbox_picker = 'fzf'
"}}}


" vimplug bindings {{{
nnoremap <leader>pi <Cmd>PlugInstall<CR>
nnoremap <leader>pU <Cmd>PlugUpgrade<CR>
nnoremap <leader>pu <Cmd>PlugUpdate<CR>
" }}}


" Autosave toggle
nnoremap <F6> <Cmd>ASToggle<CR>
"nnoremap <F6> :AutoSaveOnLostFocus<CR>
" goto previous buffer
nnoremap <F7> :bp<CR>
nnoremap <F8> :bn<CR>
" est mappe a autre chose pour l'instant
"noremap <F13> exec ":emenu <tab>"
" should become useless with neovim
" noremap <F10> :set paste!<CR>
map <F11> <Plug>(ToggleListchars)

" Command to toggle line wrapping.
" nnoremap <Leader>wr :set wrap! \| :set wrap?<CR>

" set vim's cwd to current file's
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

if has('nvim')
    " runtime! python_setup.vim
 " when launching term
  tnoremap <Esc> <C-\><C-n>
endif

" Bye bye ex mode
noremap Q <NOP>

"http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious

map <Leader><space> :b#<CR>

" Interactive menus {{{1
" use emenu ("execute menu") to launch the command
" disable all menus
unmenu *
" menu Spell.EN_US :setlocal spell spelllang=en_us \| call histadd('cmd', 'setlocal spell spelllang=en_us')<CR>
menu Spell.&FR :setlocal spell spelllang=fr_fr<CR>
" menu Spell.EN_US :setlocal spell spelllang=en_us<CR>
menu <script> Spell.&EN_US :setlocal spell spelllang=en_us<CR>
menu ]Spell.hidden should be hidden

menu Trans.FR :te trans :fr <cword><CR>
" defines a tip
tmenu Trans.FR Traduire vers le francais

" upstream those to grepper
" menu Search.CurrentBuffer :exe Grepper -grepprg rg --vimgrep $* $.
" menu Search.AllBuffers :exe Grepper -grepprg rg --vimgrep $* $+

menu LSP.Stop\ All\ Clients :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>

command! OpenDiagnostics lua vim.lsp.diagnostic.set_loclist({ open = false})
" pb c'est qu'il l'autofocus
autocmd User LspDiagnosticsChanged lua vim.lsp.diagnostic.set_loclist( { open = false,  open_loclist = false})

command! LspStopAllClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())


" tabulation-related menu {{{2
menu Tabs.S2 :set  tabstop=2 softtabstop=2 sw=2<CR>
menu Tabs.S4 :set ts=4 sts=4 sw=4<CR>
menu Tabs.S6 :set ts=6 sts=6 sw=6<CR>
menu Tabs.S8 :set ts=8 sts=8 sw=8<CR>
menu Tabs.SwitchExpandTabs :set expandtab!
"}}}
" }}}
" nvim specific configuration {{{
"set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
let g:netrw_home=$XDG_DATA_HOME.'/nvim'
" }}}

" set guicursor=i:ver3,n:block-blinkon10-Cursor,r:hor50
" try reverse ?
" highl lCursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
" #232526

nnoremap <kPageUp> :lprev
nnoremap <kPageDown> :lnext
nnoremap <kPageRight> :lnext
nnoremap <kPageRight> :lnext
nnoremap <k2> :echom "hello world"
nnoremap gO i<CR>
" overwrite vimtex status mapping
" let @g="dawi\\gls{p}"
" nnoremap <Leader>lg @g


function! FzfFlipBool()
  " let l:dict = {}
  " 'source':
  let l:dict = {
    \ 'sink': 'echo'
    \ }
  call fzf#run(l:dict)
endfunc
command! FlipBool call FzfFlipBool()

" to open tag in a split
map <A-]> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>


let g:python_host_tcp=1

function! Genmpack(file)
    let t = readfile(a:file)
    let j = json_decode(t)
    " echo 'Decoded json'.string(j)
    let m = msgpackdump(j)
    call writefile(m, 'fname.mpack', 'b')
endfunc


" function which starts a nvim-hs instance with the supplied name
function! s:RequireHaskellHost(name)
    " It is important that the current working directory (cwd) is where
    " your configuration files are.
    " return jobstart(['stack', 'exec', 'nvim-hs', a:name.name], {'rpc': v:true, 'cwd': expand('$HOME') . '/.config/nvim'})
    " we don't want to run stack !
    if executable('nvim-hs') 
      return jobstart(['nvim-hs', a:name.name], {'rpc': v:true, 'cwd': stdpath('config')})
    endif
endfunction

" Register a plugin host that is started when a haskell file is opened
" call remote#host#Register('haskell', "*.l\?hs", function('s:RequireHaskellHost'))
" But if you need it for other files as well, you may just start it
" forcefully by requiring it
" let hc=remote#host#Require('haskell')
" printer configuration
" set printexpr


" auto reload vim config on save
" Watch for changes to vimrc
" augroup myvimrc
"   au!
"   au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
" augroup END

" augroup onnewsocket
"   au!
"   autocmd! OnNewSocket * echom 'New client from init'
" augroup END

" open vimrc
nnoremap <Leader>ev <Cmd>e $MYVIMRC<CR>
nnoremap <Leader>el <Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>
nnoremap <Leader>em <Cmd>e ~/.config/nvim/init.manual.vim<CR>
" reload vimrc
nnoremap <Leader>sv  <Cmd>source $MYVIMRC<CR>

" open netrw/dirvish split
" nnoremap <Leader>e :Vex<CR>
" nnoremap <Leader>w :w<CR>

"nnoremap <F8> :vertical wincmd f<CR> " open file under cursor in a split
nnoremap <leader>gfs :vertical wincmd f<CR> " open file under cursor in a split


" from justinmk
func! ReadExCommandOutput(newbuf, cmd) abort
  redir => l:message
  silent! execute a:cmd
  redir END
  if a:newbuf | wincmd n | endif
  silent put=l:message
endf
command! -nargs=+ -bang -complete=command R call ReadExCommandOutput(<bang>0, <q-args>)


" was supposed to be called from
" function! UpdatePythonHost(prog)
"   let g:python3_host_prog = a:prog
"   " Update mypy as well
"   let g:neomake_python_mypy_exe = fnamemodify( g:python3_host_prog, ':p:h').'/mypy'
" endfunc

" nnoremap <S-CR> i<CR><Esc>


" taken from justinmk's config
command! Tags !ctags -R --exclude='build*' --exclude='.vim-src/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *


" extmark helper {{{
function! CreateVisualExtmark()

  let opts = {
    \ 'end_line': line("'>"),
    \ 'end_col': col("'>")
    \ }
  let ns_id = nvim_create_namespace("folds")
  let curbuf = 0
  let line = line("'<")
  let col = col("'<")
  call nvim_buf_set_extmark(curbuf, ns_id, 0, line, col, opts)
endfunction

map ,fa <Cmd>call CreateVisualExtmark()<CR>
" }}}

" lsp config {{{
" command! LspAction lua vim.lsp.buf.code_action()

sign define DiagnosticSignError text=✘ texthl=LspDiagnosticsSignError linehl= numhl=
sign define DiagnosticSignWarning text=！ texthl=LspDiagnosticsSignWarning linehl= numhl=CustomLineWarn
sign define DiagnosticSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=CustomLineWarn
sign define DiagnosticSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=

" guifg=#232526 
hi CustomLineWarn guifg=#FD971F
" only concerns the text of the message, not the floatwindow
" hi LspDiagnosticsFloatingError guifg=red
" hi LspDiagnosticsFloatingWarning guifg=orange
" }}}

function! RandNum() abort
  return str2nr(matchstr(reltimestr(reltime()), '\.\zs\d*'))
endfunction

function! RandChar() abort
  return nr2char((RandNum() % 93) + 33)
endfunction

function! Password() abort
  return join(map(range(8), 'RandChar()'), '')
endfunction

" set working directory to the current buffer's directory
" nnoremap cd :lcd %:p:h<bar>pwd<cr>
" nnoremap cu :lcd ..<bar>pwd<cr>

"linewise partial staging in visual-mode.
xnoremap <c-p> <Cmd>diffput<cr>
xnoremap <c-o> <Cmd>diffget<cr>
" nnoremap <expr> dp &diff ? 'dp' : ':Printf<cr>'

command! JsonPretty %!jq '.'

" vim.api.nvim_command('au User LspMessageUpdate redrawstatus!')
nnoremap <2-LeftMouse> <cmd>lua vim.lsp.buf.definition()<cr>

" command! ProfileVim     exe 'Start '.v:progpath.' --startuptime "'.expand("~/vimprofile.txt").'" -c "e ~/vimprofile.txt"'
" command! NvimTestScreenshot put =\"local Screen = require('test.functional.ui.screen')\nlocal screen = Screen.new()\nscreen:attach()\nscreen:snapshot_util({},true)\"


command Hasktags !hasktags .
command Htags !hasktags .


function! TestFoldTextWithColumns()
  let line = getline(v:foldstart)
  let res = ""
  " v:foldstart / v:foldend
  if exists("v:foldstartcol")
    let res = "foldstartcol exists :". v:foldstartcol
  endif
  return res . " toto" . repeat(" ", 4)
endfunc

" set foldtext=TestFoldTextWithColumns()

" map <C-D> <C-]>
" map <C-D> :tag<CR>
map <D-b> :echom "hello papy"


" nvim will load any .nvimrc in the cwd; useful for per-project settings
set exrc
" from FAQ https://github.com/neovim/neovim/wiki/FAQ
" vnoremap <LeftRelease> "*ygv

" global color
highlight BiscuitColor ctermfg=cyan
" highlight BiscuitColorRust ctermfg=red

" language specific color
let $NVIM_MKDP_LOG_LEVEL = 'debug'
let $VIM_MKDP_RPC_LOG_FILE = expand('~/mkdp-rpc-log.log')
let g:mkdp_browser = 'firefox'
