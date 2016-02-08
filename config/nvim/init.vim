" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" to debug vimscript, use :mess to display error messages
" source ~/.vim/vimrc

"$NVIM_PYTHON_LOG_FILE


let s:plugdir = $XDG_CONFIG_HOME.'/nvim/plugged'

let s:plugscript = $XDG_CONFIG_HOME.'/nvim/autoload/plug.vim'


if empty(glob(s:plugscript))
	  silent !mkdir -p $XDG_CONFIG_HOME.'/nvim/autoload'
	    silent !curl -fLo s:plugscript
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		  autocmd VimEnter * PlugInstall
endif



" 
let mapleader = " "


" to configure vim for haskell, refer to
" http://yannesposito.com/Scratch/en/blog/Vim-as-IDE/

call plug#begin(s:plugdir)

" {{{ Autocompletion and linting 
Plug 'Valloric/YouCompleteMe' , { 'do': './install.py --system-libclang --clang-completer' }
Plug 'majutsushi/tagbar'
" }}}
Plug 'tomtom/quickfixsigns_vim'
Plug 'kana/vim-operator-user' " dependancy for operator-flashy
Plug 'haya14busa/vim-operator-flashy' " Flash selection on copy

" better handling of buffer closue (type :sayonara)
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" filetypes {{{
Plug 'cespare/vim-toml'
" }}}
" Python {{{1

Plug 'hynek/vim-python-pep8-indent', {'for': 'py'} " does not work
Plug 'mjbrownie/GetFilePlus', {'for': 'py'} " improves gf on imports
Plug 'tmhedberg/SimpylFold', { 'for': 'py' } " provides python folding
" }}}


Plug '907th/vim-auto-save' " don't rembmer: check
" {{{ To ease movements
"Plug 'rhysd/clever-f.vim'
"Plug 'unblevable/quick-scope'  " highlight characeters to help in f/F moves
Plug 'Lokaltog/vim-easymotion'
Plug 'vim-scripts/QuickFixCurrentNumber'
"Plug 'wellle/visual-split.vim'
Plug 'justinmk/vim-ipmotion'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-rsi'  " maps readline bindings
" }}}
"Plug 'vim-flake8' " for python syntax
"Plug 'fisadev/vim-ctrlp-cmdpalette' " sublime text like palette
"Plug 'osyo-manga/vim-anzu' " to improve internal search
Plug 'mhinz/vim-startify' " very popular, vim's homepage

" Startify config {{{
nnoremap <leader>st :Startify<cr>

let g:startify_list_order = [
      \ ['   MRU'],           'files' ,
      \ ['   MRU '.getcwd()], 'dir',
      \ ['   Sessions'],      'sessions',
      \ ['   Bookmarks'],     'bookmarks',
      \ ]
let g:startify_session_dir = $XDG_DATA_HOME.'/nvim/session'
let g:startify_bookmarks = [ '~/.vimrc' ]
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 0
let g:startify_session_savevars = []
" }}}

Plug 'dietsche/vim-lastplace' " restore last cursor postion
" Powerline does not work in neovim hence use vim-airline instead
"if has('nvim')
	Plug 'bling/vim-airline'
"else
	"Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
"endif
Plug 'wannesm/wmgraphviz.vim' " graphviz syntax highlighting
"Plug 'CCTree'
"Plug 'showmarks2'
Plug 'teto/nvim-wm'  " to use WM bindings instead of vim's to move between splits
Plug '~/vim-listchars'
Plug 'vim-voom/VOoM' " can show tex/restDown Table of Content (ToC)
Plug 'blueyed/vim-diminactive' " disable syntax coloring on inactive splits
Plug 'tpope/vim-sleuth' " Dunno what it is
Plug 'tpope/vim-vinegar' " Improves netrw
Plug 'justinmk/vim-gtfo' " ?
Plug 'tpope/vim-fugitive' " to use with Git
Plug 'tpope/vim-surround' " don't realy know how to use yet
"Plug 'junegunn/vim-github-dashboard' " needs ruby support, thus won't work in neovim
Plug 'scrooloose/nerdcommenter'
"Plug 'junegunn/vim-peekaboo' " gives a preview of buffers when pasting
Plug 'mhinz/vim-randomtag', { 'on': 'Random' } " Adds a :Random function that launches help at random
Plug 'majutsushi/tagbar'

" vim-sayonara {{{1
nnoremap <silent><leader>q  :Sayonara<cr>
nnoremap <silent><leader>Q  :Sayonara!<cr>

let g:sayonara_confirm_quit = 0
" }}}


" {{{ fuzzers
Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': './install --all --64' }


" Many options available :
" https://github.com/junegunn/fzf.vim
" Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new tab, a new split, or in a new vertical split
Plug 'junegunn/fzf.vim' " defines :Files / :Commits for FZF

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

" Advanced customization using autoload functions
"autocmd VimEnter * command! Colors
  "\ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})
" Advanced customization using autoload functions
" }}}

"Plug 'ctrlpvim/ctrlp.vim' " todo remove in favor of FZF
"Plug 'mattn/ctrlp-mark'
"Plug 'mattn/ctrlp-register'
" }}}
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') } " Needs rust, cargo, plenty of things
"Plug 'greyblake/vim-preview' " depends on ruby 'redcarpet', thus doesn't work in neovim ?

"Plug 'junegunn/vim-easy-align'   " to align '=' on multiple lines for instance
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'surround.vim'
"Plug 'tpope/vim-markdown', { 'for': 'md' }
"Plug 'elzr/vim-json', { 'for': 'json' }
"Plug 'numkil/ag.vim'
Plug 'gundo' " visual removal
Plug 'dhruvasagar/vim-table-mode'
Plug 'airblade/vim-gitgutter' " will show which lines changed compared to last clean state
Plug 'mhinz/vim-rfc', { 'on': 'RFC' }
" can show a list of unicode characeters, with their name  :UnicodeTable etc... 
Plug 'chrisbra/unicode.vim', { 'on': ['<plug>(UnicodeComplete)', '<plug>(UnicodeGA)', 'UnicodeTable'] } 
"Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for 
Plug 'vim-scripts/Modeliner' " <leader>ml to setup buffer modeline
"Plug 'sfiera/vim-emacsmodeline' " Reads emacs modelines
" This one has bindings mapped to <leader>l
"Plug 'vimwiki/vimwiki'   " to write notes
Plug 'kshenoy/vim-signature' " display marks in gutter, love it
"Plug 'vim-scripts/DynamicSigns'
Plug 'vasconcelloslf/vim-interestingwords' " highlight the words you choose <leader>k
Plug 'mhinz/vim-grepper' " async grep neovim only
Plug 'benekastah/neomake' " async build for neovim

" Neomake config {{{
let g:neomake_verbose = 1
let g:neomake_python_enabled_makers = ['pyflakes']
let g:neomake_c_gcc_args = ['-fsyntax-only', '-Wall']

let g:neomake_airline = 0
let g:neomake_error_sign = { 'text': '✘', 'texthl': 'ErrorSign' }
let g:neomake_warning_sign = { 'text': ':(', 'texthl': 'WarningSign' }
"let g:neomake_ruby_enabled_makers = ['mri']

" C and CPP are handled by YCM and java usually by elim
"let s:neomake_exclude_ft = [ 'c', 'cpp', 'java' ]
"let g:neomake_python_pep8_maker
" }}}

" colorschemes {{{
Plug 'whatyouhide/vim-gotham'
Plug 'sickill/vim-monokai'
Plug 'justinmk/molokai'
Plug 'mhinz/vim-janah'
Plug 'Solarized'
Plug 'morhetz/gruvbox'
Plug 'romainl/flattened'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
" }}}

" Had to disable this one, needs a vim with lua compiled
" and it's not possible in neovim yet
" color_coded requires vim to be compiled with -lua
"Plug 'jeaye/color_coded'
"
" Plug 'bbchung/clighter'
" YCM generator is not really a plugin is it ?
" Plug 'rdnetto/YCM-Generator'
" Plug 'erezsh/erezvim' "zenburn scheme. This plugin resets some keymaps,
" annoying
Plug 'chrisbra/csv.vim' "
" Plug 'luochen1990/rainbow' " does it work ?
"Plug 'eapache/rainbow_parentheses.vim'  " Display successive delimiters such as [,(... with different colors 

" {{{ Latex attempts
" this one could not compile my program
" "Plug 'vim-latex/vim-latex', {'for': 'tex'}
" " ATP author gh mirror seems to be git@github.com:coot/atp_vim.git
" "Plug 'coot/atp_vim', {'for': 'tex'}
Plug 'lervag/vimtex', {'for': 'tex'}
" }}}

call plug#end()




set autoread " automatically reload file when it has been changed (hope they fix this damn feature one day)
set linebreak " better display (makes sense only with wrap)
set wrap
set breakat=80
set breakindent " preserve indentation on wrap
set showbreak=">>>"
filetype on                   " required!
set backspace=indent,eol,start


" start scrolling before reaching end of screen in order to keep more context
set scrolloff=3

"  compilation option

set noshowmode " Show the current mode on command line
set cursorline " highlight cursor line




" Indentation {{{
set tabstop=4 " a tab takes 4 characters (local to buffer)
set shiftwidth=4 " Number of spaces to use per step of (auto)indent.
set smarttab "use shiftwidth
set smartindent 
set shiftround " round indent to multiple of 'shiftwidth' (for << and >>)
"set softtabstop=4 " remove <Tab> symbols as it was spaces
"set expandtab " replace <Tab with spaces
" }}}

" Netrw configuration {{{
" decide with which program to open files when typing 'gx'
let g:netrw_browsex_viewer="xdg-open"
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'
let g:netrw_liststyle=1 " long listing with timestamp
" }}}
" /quickfix
"
"let c_no_bracket_error=1
"let c_no_curly_error=1
"let c_comment_strings=1
"let c_gnu=1

set title " vim will change terminal title
"set titlestring
" look at :h titlestring (follows statusbar convention



nnoremap <Leader>/ :set hlsearch! hls?<CR> " toggle search highlighting




" transforms some characters into their digraphs equivalent 
" if your font supports it 
" concealcursor
"let g:tex_conceal="agdms"
"set conceallevel=2

set showmatch

" set autochdir
" 
" " When on, Vim will change the current working directory
" " whenever you open a file, switch buffers, delete a buffer
" " or open/close a window.
" " It will change to the directory containing the file which
" " was opened or selected.
" " Note: When this option is on some plugins may not work.


" display a menu when need t ocomplete a command 
set wildmenu
set wildmode=list:longest
"Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif


" Use visual bell instead of beeping when doing something wrong
set visualbell

" if boths are set at the same time, vim uses an hybrid mode
" Display line numbers on the left
set number
"Prefer relative line numbering?
set relativenumber
" TODO do a macro that cycles throught show/hide absolute/relative line numbers
map <C-N><C-N> :set invnumber<CR>


" Display unprintable characters with '^' and
" set nolist to disable or set list!


set timeoutlen=400 " Quick timeouts on key combinations.



" in order to scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Regenerate database
" map 
"map <esc>[27;5;9~ <C-Tab>
"map <esc>[1;5A <C-Up>
"map <esc>[1;5B <C-Down>
"map <esc>[1;5C <C-Right>
"map <esc>[1;5D <C-Left>
"map <esc>[1;2D <S-Left>
"map <esc>[1;2C <S-Right>
"" tabn 4. Createon
"map <esc>[27;5;38~ <C-&>
"map <esc>[27;5;130~ <C-é>
"map <esc>[27;5;39~ <C-'>
"map <esc>[27;5;34~ <C-">
"map <esc>[27;5;40~ <C-(>
"

syntax on

" set undodir=~/.vim/tmp/undo//     " undo files
" set backupdir=~/.vim/tmp/backup// " backups
" set directory=~/.vim/tmp/swap//   " swap files

" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}

" to load plugins in ftplugin matching ftdetect
filetype plugin on

" Modeliner shortcuts  {{{
set modeline
set modelines=4
nmap <leader>ml :Modeliner<Enter>
let g:Modeliner_format = 'et ff= fenc= sts= sw= ts= fdm=marker'
" }}}

" X clipboard gets aliased to +
set clipboard=unnamedplus
" copy to external clipboard
noremap gp "+p 
noremap gy "+y 

" Easy window navigation
" noremap <F3> :Tlist<Enter>




" todo enable rainbow parentheses
"nnoremap <leader>R :CtrlP<CR>
" est deja mappe :/




" External sourced files section {{{

" let use sudo once the file is loaded
"source ~/.vim/plug.vim
" source ~/.vim/colors.vim
" this should be made a plugin as well
" TODO this does not work with neovim
source ~/.vim/vim_file_chooser.vim
" }}}

" Window / splits {{{
"cmap w!! w !sudo tee % >/dev/null
" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 : 
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>


nmap <silent> <M-Up> :wincmd k<CR>
nmap <silent> <M-Down> :wincmd j<CR>
nmap <silent> <M-Left> :wincmd h<CR>
nmap <silent> <M-Right> :wincmd l<CR>


" For comparison
"nnoremap p :echom "p"<cr>
"nnoremap <S-p> :echom "S-p"<cr>
"nnoremap <C-p> :echom "C-p"<cr>
"nnoremap <C-S-p> :echom "C-S-p"<cr>
"nnoremap <M-p> :echom "M-p"<cr>
"nnoremap <M-S-p> :echom "M-S-p"<cr>
"nnoremap <C-M-p> :echom "C-M-p"<cr>
"nnoremap <C-M-S-p> :echom "C-M-S-p"<cr>


" nmap = *normal mode* mapping
nmap <silent> ^[OC :wincmd l<CR>
nmap <silent> ^[OC :wincmd h<CR>
nmap <silent> OC :wincmd l<CR>
nmap <silent> OD :wincmd h<CR>

" window nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>

nnoremap <silent> + :exe "resize +3"
nnoremap <silent> - :exe "resize -3"

set splitbelow	" on horizontal splits
set splitright   " on vertical split

" }}}


" {{{ Markdown composer
let g:markdown_composer_open_browser        = "qutebrowser"
let g:markdown_composer_autostart           = 1
" }}}
"set winheight=30
"set winminheight=5

" hope this can be removed if wincmd_result
" TODO bufnr is not good enough
function! WinCmdWithRes(toto)
	let l:res = winnr()
	"echo l:res
	exec "wincmd ".a:toto
	"echo bufnr('%') == res
	let g:wincmd_result= winnr() != l:res
endfunction


" Appearance {{{
set background=dark

let g:solarized_termtrans = 0
" let g:solarized_style     =   "dark"  
" g:solarized_contrast  =   "normal"|   "high" or "low"

" to alternate between dark and light bg
" to alternate between dark and light bg
"function! ToggleBackground()
 "if (w:solarized_style=="dark")
 "let w:solarized_style="light"
 "colorscheme solarized
"else
 "let w:solarized_style="dark"
 "colorscheme solarized
"endif
"endfunction
"command! Togbg call ToggleBackground()
"nnoremap <f4> :call ToggleBackground()<cr>

" colorscheme solarized
colorscheme monokai
"}}}

" Gruvbox config {{{
" contrast can be soft/medium/hard
" there are other many options
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"
" }}}

" Diminactive config {{{
let g:diminactive_buftype_blacklist = []
let g:diminactive_debug = 0
let g:diminactive_use_colorcolumn = 1
let g:diminactive_use_syntax = 0
let g:diminactive_enable_focus = 0
"}}}
" to remove timeout when changing modes
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" vimtex {{{
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_latexmk_progname = 'nvr'
let g:latex_view_general_viewer = 'zathura'
"let g:tex_stylish = 1
"let g:tex_flavor = 'latex'
"let g:tex_isk='48-57,a-z,A-Z,192-255,:'

if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*,?)*',
    \ 're!\\includegraphics([^]]*])?{[^}]*',
    \ 're!\\(include|input){[^}]*'
    \ ]
" }}}

nnoremap <leader>r :!%:p<return>


set shiftround    " round indent to multiple of 'shiftwidth'

" auto reload vim config on save
" Watch for changes to vimrc

    augroup myvimrc
      au!
      au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
    augroup END

" open vimrc
nnoremap <Leader>ev :e $MYVIMRC<CR> 
"nnoremap <Leader>ep :vs ~/.vim/plug.vim<CR> 
nnoremap <Leader>sv :source $MYVIMRC<CR> " reload vimrc

nnoremap <Leader>e :Vex<CR> " open netrw
nnoremap <Leader>w :w<CR>

" mostly fzf mappings, use TAB to mark several files at the same time
nnoremap <Leader>o :FzfFiles<CR>
nnoremap <Leader>g :FzfGitFiles<CR>
nnoremap <Leader>c :FzfCommits<CR>
nnoremap <Leader>C :FzfColors<CR>
"nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>b :FzfBuffers<CR>
nnoremap <leader>m :FzfMarks<CR>
nnoremap <leader>u :Gundo<CR>
nnoremap <leader>r :<C-U>RangerChooser<CR>

nnoremap <F8> :vertical wincmd f<CR> " open file under cursor in a split
nnoremap <leader>gfs :vertical wincmd f<CR> " open file under cursor in a split
" Powerline config {{{

let g:Powerline_symbols = "fancy" " to use unicode symbols
" }}}


" Ctrpl config {{{
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'mattn/ctrlp-mark'
"Plug 'mattn/ctrlp-register'
"let g:ctrlp_cmd = 'CtrlPMixed'
"let g:ctrlp_match_window = 'results:100' " overcome limit imposed by max height
"let g:ctrlp_extensions= ['dir','mark']
" }}}

" Csv config {{{
" you can use :CsvVertFold to hide commands
" There is the analyze command as well
    let g:csv_autocmd_arrange = 1
    let g:csv_autocmd_arrange_size = 1024*1024
" }}}



" Search parameters {{{
set hlsearch " highlight search terms
set incsearch " show search matches as you type
set ignorecase " ignore case when searching
set smartcase " take case into account if search entry has capitals in it
set wrapscan " prevent from going back to the beginning of the file
" }}}

" YouCompleteMe config {{{
let g:ycm_global_ycm_extra_conf = $XDG_CONFIG_HOME."/nvim/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
let g:ycm_auto_trigger = 1
let g:ycm_error_symbol = ">>" " used to signal errors in gutter
let g:ycm_warning_symbol = '!' " warn in gutter TODO use unicode chars
let g:ycm_show_diagnostics_ui = 1 " show info in gutter
" g:ycm_show_diagnostics_ui=1
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_detailed_diagnostics = '<leader>d'
let g:ycm_goto_buffer_command = 'same-buffer' " horizontal-split, new-tab, new-or-existing tab
let g:ycm_server_log_level = 'debug'

" Add triggers to ycm for LaTeX-Box autocompletion
let g:ycm_semantic_triggers = {
      \  'tex'  : ['{'],
      \ 'mail' : ['@'],
      \ }

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <F6> :YcmDebugInfo<CR>

"You may also want to map the subcommands to something less verbose; for instance, nnoremap <leader>jd :YcmCompleter GoTo<CR> maps the <leader>jd sequence to the longer subcommand invocation.

"The various GoTo* subcommands add entries to Vim's jumplist so you can use CTRL-O to jump back to where you where before invoking the command (and CTRL-I to jump forward; see :h jumplist for details).

nnoremap <leader>jd :YcmCompleter GoTo<CR>
" }}}

" Jedi (python) completion {{{
let g:jedi#auto_vim_configuration = 0 " to prevent python's help popup
" }}}

" Airline {{{
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section = '|'
" display buffers as tabs if no split
" see :h airline-tabline
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_buffers = 1  
let g:airline#extensions#tabline#buffer_min_count =2
let g:airline#extensions#tabline#buffer_idx_mode = 1

let g:airline#extensions#tabline#show_tabs = 1

let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_extensions = ['branch', 'tabline']

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long' ]



nmap <leader>& <Plug>AirlineSelectTab1
nmap <leader>é <Plug>AirlineSelectTab2
nmap <leader>" <Plug>AirlineSelectTab3
nmap <leader>' <Plug>AirlineSelectTab4
nmap <leader>( <Plug>AirlineSelectTab5
nmap <leader>- <Plug>AirlineSelectTab6
nmap <leader>è <Plug>AirlineSelectTab7


"}}}

autocmd CompleteDone * pclose " close the popup on python completion

" {{{ Clever f
"
" }}}

" {{{ Quickscope config
"let g:qs_first_occurrence_highlight_color = 155
"let g:qs_second_occurrence_highlight_color = 81
"let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
"nmap <leader>q <plug>(QuickScopeToggle)
" }}}

" Rainbow parentheses {{{
let g:rbpt_colorpairs = [
    \ ['red',         'RoyalBlue3'],
    \ ['brown',       'SeaGreen3'],
    \ ['blue',        'DarkOrchid3'],
    \ ['gray',        'firebrick3'],
    \ ['green',       'RoyalBlue3'],
    \ ['magenta',     'SeaGreen3'],
    \ ['cyan',        'DarkOrchid3'],
    \ ['darkred',     'firebrick3'],
    \ ['brown',       'RoyalBlue3'],
    \ ['darkblue',    'DarkOrchid3'],
    \ ['gray',        'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkmagenta', 'SeaGreen3'],
    \ ['darkcyan',    'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 4
let g:rbpt_loadcmd_toggle = 0
let g:bold_parentheses = 1      " Default on

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
" }}}

" Gitgutter config {{{

let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 200
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
"let g:gitgutter_diff_args = '--ignore-space-at-eol'
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>
nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
nnoremap cog :GitGutterToggle<CR>
" }}}

" Restor cursor position {{{
function! ResCur()
  " $ => last line of buffer
  " '" => cursor position on exit
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
" }}}

" Generic Tex configuration {{{
" See :help ft-tex-plugin
let g:tex_flavor = "latex"
"}}}

" Vimtex configuration {{{
  "let g:vimtex_view_method = 'zathura'
  "augroup latex
    "autocmd!
    "autocmd FileType tex nnoremap <buffer><F4> :VimtexView<CR>
    "autocmd FileType tex nnoremap <buffer><F5> :VimtexCompile<CR>
    "autocmd FileType tex map <silent> <buffer><F8> :call vimtex#latexmk#errors_open(0)<CR>
  "augroup END
"" }}}

" Fold configuration {{{
"set foldtext=
set foldcolumn=1
" }}}

" vim-listchars config {{{
let g:listchar_formats=[ 
   \"trail:·",
    \"trail:·,tab:→\ ,eol:↲,precedes:<,extends:>"   
   \]
" while waiting to finish my vim-listchars plugin
"set listchars=tab:»·,eol:↲,nbsp:␣,extends:…
set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
set fillchars=vert:│,fold:─
" }}}

" Grepper {{{
nnoremap <leader>git :Grepper  -tool git -open -nojump
nnoremap <leader>ag  :Grepper -tool ag  -open -switch
" }}}

" Peekaboo config {{{
" Default peekaboo window
let g:peekaboo_window = 'vertical botright 30new'

" Delay opening of peekaboo window (in ms. default: 0)
let g:peekaboo_delay = 750

" Compact display; do not display the names of the register groups
let g:peekaboo_compact = 1
" }}}

" vimplug bindings {{{
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pU :PlugUpgrade<CR>
nnoremap <leader>pu :PlugUpdate<CR>
" }}}

" autosave {{{
  let g:auto_save_in_insert_mode = 0
  let g:auto_save_events = ['CursorHold', 'FocusLost']
" }}}

" Customized commands depending on buffer type {{{

nnoremap <LocalLeader>sv :source $MYVIMRC<CR> " reload vimrc
" }}}

" {{{ vim-scripts/QuickFixCurrentNumber
" }}}

" draw a line on 80th column
set colorcolumn=80

set diffopt=filler,vertical " default behavior for diff

" Y behave like D or C
nnoremap Y y$

" Put this in vimrc, add custom commands in the function.
function! AutoSaveOnLostFocus()
  exe ":au FocusLost" expand("%") ":wa"
endfunction

nnoremap coa :AutoSaveToggle<CR>

" search items in location list (per window)
nnoremap <F1> :lprev<CR>
nnoremap <F2> :lnext<CR>
" search for  item in quickfix list (global/unique)
nnoremap <F3> :cprev<CR>
nmap <F4> :cnext<CR>
nnoremap <F5> :Neomake<CR>
"nnoremap <F6> :call AutoSaveOnLostFocus()
" search for  item in quickfix list
" goto previous buffer
nnoremap <F7> :bp<CR> 
nnoremap <F8> :bn<CR>
" est mappe a autre chose pour l'instant
"noremap <F4> exec ":emenu <tab>"
" should become useless with neovim
noremap <F10> :set paste!<CR>
nmap <F11> <Plug>(ToggleListchars)

" vim:foldmethod=marker:foldlevel=0
" Get off my lawn
"noremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

nnoremap <silent> <Leader>B :TagbarToggle<CR>

if has('nvim')
	"runtime! python_setup.vim
 " when launching term
	tnoremap <Esc> <C-\><C-n>
endif

autocmd! BufWritePost * Neomake

"'.'
"set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada

" nvim specific configuration {{{
if has("nvim")
  "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
  let g:netrw_home=$XDG_DATA_HOME.'/nvim'
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif
" }}}
