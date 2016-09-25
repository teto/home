" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" to debug vimscript, use :mess to display error messages
" :scriptnames to list loaded scripts
" and prefix you command with 'verbose' is a very good way to get info
" like ':verbose map J' to know where it was loaded last
" map <C-D> <C-]>
" map <C-D> :tag<CR>
map <D-b> :echom "hello papy"

"$NVIM_PYTHON_LOG_FILE
" to test startup time
" nvim --startuptime startup.log
" nvim -u NONE --startuptime startup.log


" vim-plug autoinstallation {{{
" TODO move to XDG_DATA_HOME
" let s:nvimdir = (exists("$XDG_CONFIG_HOME") ? $XDG_CONFIG_HOME : $HOME.'/.config').'/nvim'
" appended site to be able to use packadd (since it is in packpath)
let s:nvimdir = (exists("$XDG_DATA_HOME") ? $XDG_DATA_HOME : $HOME.'/.local/share').'/nvim'
let s:plugscript = s:nvimdir.'/autoload/plug.vim'
let s:plugdir = s:nvimdir.'/site/pack'

"silent echom s:plugscript
"silent echom s:nvimdir

if empty(glob(s:plugscript))
  execute "!mkdir -p " s:nvimdir.'/autoload' s:plugdir
  execute "!curl -fLo" s:plugscript
		\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"}}}


" Dealing with pdf {{{
" Read-only pdf through pdftotext
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

" convert all kinds of files (but pdf) to plain text
autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
" }}}

" 
let mapleader = " "

" Appearance 1 {{{
let s:gutter_error_sign = "✘'"
let s:gutter_warn_sign = '！'
" }}}

" to configure vim for haskell, refer to
" http://yannesposito.com/Scratch/en/blog/Vim-as-IDE/
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

" filnxtToO
set shortmess+=I

" vim-plug plugin declarations {{{1
call plug#begin(s:plugdir)
Plug 'mtth/scratch.vim' " , {'on': 'Scratch'} mapped to ?
Plug 'git@github.com:junegunn/gv.vim.git' " git commit viewer :Gv
" Plug 'git@github.com:xolox/vim-easytags.git' " 
Plug 'git@github.com:ludovicchabant/vim-gutentags' " 
"Plug 'junegunn/limelight.vim' " to highlight ucrrent paragraph only
" Plug 'bronson/vim-trailing-whitespace' " :FixTrailingWhitespace
" Plug 'tkhoa2711/vim-togglenumber' " by default mapped to <leader>n
" Plug 'blindFS/vim-translator' " fails during launch :/
Plug 'git@github.com:metakirby5/codi.vim'
" Plug 'timeyyy/orchestra.nvim' " to play some music on 
" Plug 'timeyyy/clackclack.symphony' " data to play with orchestra.vim
Plug 'tpope/vim-scriptease' " Adds command such as :Messages
Plug 'metakirby5/codi.vim' " repl
" Plug 'Yggdroot/indentLine',{ 'for': 'python' }  " draw verticals indents but seems greedy
"  Autocompletion and linting {{{2
"'frozen': 1,
Plug 'Valloric/YouCompleteMe' , { 'do': ':new \| call termopen(''./install.py --system-libclang --clang-completer'')' }
" Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
" Plug 'zchee/deoplete-clang', { 'for': 'cpp' }
" Plug 'zchee/deoplete-jedi', { 'for': 'python'}
" }}}
Plug 'beloglazov/vim-online-thesaurus' " thesaurus => dico dde synonymes
Plug 'mattboehm/vim-unstack'  " to see a
Plug 'KabbAmine/vCoolor.vim', { 'on': 'VCooler' } " RGBA color picker
Plug 'arakashic/chromatica.nvim', { 'for': 'cpp' } " semantic color syntax

"Plug 'mattn/vim-rtags' a l'air léger
" Plug 'shaneharper/vim-rtags' " <leader>r ou bien :RtagsFind  mais ne marche pas
Plug 'lyuts/vim-rtags'  " a l'air d'etre le plus complet
Plug 'tpope/vim-unimpaired' " [<space> [e [n ]n pour gerer les conflits etc...
Plug 'kana/vim-operator-user' " dependancy for operator-flashy
Plug 'haya14busa/vim-operator-flashy' " Flash selection on copy

" better handling of buffer closure (type :sayonara)
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" Using a non-master branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'critiqjo/lldb.nvim',{ 'for': 'c' } " To debug (use clang to get correct line numbers

" filetypes {{{2
Plug 'cespare/vim-toml', { 'for': 'toml'}
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'dzeban/vim-log-syntax'
" }}}

" Python {{{2
" Plug 'klen/python-mode', { 'for': 'python'} " 
" Plug 'hynek/vim-python-pep8-indent', {'for': 'python'} " does not work
" Plug 'mjbrownie/GetFilePlus', {'for': 'python'} " improves gf on imports
" fails on relad
" Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " provides python folding
"Plug 'vim-flake8' " for python syntax
" Plug 'bfredl/nvim-ipy'  " adds the :IPython command
" Plug 'danielroseman/pygd-vim', {'for': 'python'} " provokes an error
" }}}

Plug 'Valloric/ListToggle' " toggle location/quickfix list toggling seems to fail
" Plug 'git@github.com:milkypostman/vim-togglelist' " same
Plug 'tpope/vim-obsession' ", {'on': 'Obsession', 'ObsessionStatus'}  very cool, register edited files in a Session.vim, call with :Obsession
" Plug 'mbbill/undotree'
Plug '907th/vim-auto-save' " :h auto-save
" Plug '~/vim-auto-save' " autosave :h auto-save
" Plug '~/neovim-auto-autoread' " to check for filechanges
", { 'for': 'python' } " 
Plug 'bfredl/nvim-miniyank' " killring alike plugin, cycling paste

" Text objects {{{
Plug 'michaeljsmith/vim-indent-object'
Plug 'tommcdo/vim-lion' " Use with gl/L<text object><character to align to>
Plug 'tommcdo/vim-exchange' " Use with cx<text object> to cut, cxx to exchange
Plug 'tommcdo/vim-kangaroo' "  zp to push/zP to pop the position
Plug 'tommcdo/vim-ninja-feet' " 
" }}}
"
" {{{ To ease movements
"Plug 'rhysd/clever-f.vim'
"Plug 'unblevable/quick-scope'  " highlight characeters to help in f/F moves
Plug 'Lokaltog/vim-easymotion' " careful overrides <leader><leader> mappings
"Plug 'wellle/visual-split.vim'
Plug 'wellle/targets.vim' " Adds new motion targets ci{
" Plug 'justinmk/vim-ipmotion' " ?
Plug 'justinmk/vim-sneak' " remaps 's'
Plug 'tpope/vim-rsi'  " maps readline bindings
" }}}

"Plug 'fisadev/vim-ctrlp-cmdpalette' " sublime text like palette
"Plug 'osyo-manga/vim-anzu' " to improve internal search
Plug 'mhinz/vim-startify' " very popular, vim's homepage


Plug 'dietsche/vim-lastplace' " restore last cursor postion
" Powerline does not work in neovim hence use vim-airline instead
"if has('nvim')
	Plug 'bling/vim-airline'
"else
	"Plug 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
"endif
"
" Text objects {{{
" Plug 'kana/vim-textobj-fold' " ability to do yaz
" }}}

"
Plug 'justinmk/vim-dirvish' " replaces netrw 
" Plug 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
Plug 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting
 Plug 'tpope/vim-commentary' "gcc to comment/gcgc does not work that well
Plug 'teto/vim-listchars' " to cycle between different list/listchars configurations
"Plug 'vim-voom/VOoM' " can show tex/restDown Table of Content (ToC)
Plug 'blueyed/vim-diminactive' " disable syntax coloring on inactive splits
"Plug 'tpope/vim-sleuth' " Dunno what it is
"Plug 'justinmk/vim-gtfo' " ?
Plug 'tpope/vim-fugitive' " to use with Git, VERY powerful
"Plug 'jaxbot/github-issues.vim' " works only with vim
"Plug 'tpope/vim-surround' " don't realy know how to use yet
Plug 'junegunn/vim-github-dashboard' " needs ruby support, works in recent neovim
"Plug 'junegunn/vim-peekaboo' " gives a preview of buffers when pasting
Plug 'mhinz/vim-randomtag', { 'on': 'Random' } " Adds a :Random function that launches help at random
Plug 'majutsushi/tagbar' " , {'on': 'TagbarToggle'} disabled lazyloading else it would not work with statusline

" vim-sayonara {{{2
nnoremap <silent><leader>q  :Sayonara<cr>
nnoremap <silent><leader>Q  :Sayonara!<cr>

let g:sayonara_confirm_quit = 0
" }}}


"  fuzzers {{{2
" Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': './install --completion --key-bindings --64' }
Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': ':term ./install --no-update-rc --bin --64'}

" Many options available :
" https://github.com/junegunn/fzf.vim
" Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new tab, a new split, or in a new vertical split
Plug 'junegunn/fzf.vim' " defines :Files / :Commits for FZF

"}}}



Plug 'euclio/vim-markdown-composer' " , { 'for': 'markdown', 'do': function('BuildComposer') } " Needs rust, cargo, plenty of things :help markdown-composer
Plug 'Rykka/riv.vim' " , {'for': 'rst'}
Plug 'Rykka/InstantRst', {'for': 'rst'} " rst live preview with :InstantRst, 
"Plug 'junegunn/vim-easy-align'   " to align '=' on multiple lines for instance
Plug 'dhruvasagar/vim-table-mode', {'for': 'txt'}
Plug 'kshenoy/vim-signature' " display marks in gutter, love it

Plug 'vim-scripts/QuickFixCurrentNumber' " instead of :Cnr :Cgo
Plug 'git@github.com:vim-scripts/ingo-library.git' " DEPENDANCY of QuickFixCurrentNumber
"Plug 'tomtom/quickfixsigns_vim'

Plug 'mhinz/vim-rfc', { 'on': 'RFC' }
" can show a list of unicode characeters, with their name  :UnicodeTable etc... 
Plug 'chrisbra/unicode.vim' " , { 'on': ['<plug>(UnicodeComplete)', '<plug>(UnicodeGA)', 'UnicodeTable'] } 
"Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for 
Plug 'vim-scripts/Modeliner' " <leader>ml to setup buffer modeline
"Plug 'sfiera/vim-emacsmodeline' " Reads emacs modelines
" This one has bindings mapped to <leader>l
"Plug 'vimwiki/vimwiki'   " to write notes
"Plug 'vim-scripts/DynamicSigns'
" async grep neovim only
Plug 'mhinz/vim-grepper', { 'on': 'Grepper'}
Plug 'ddrscott/vim-side-search'  " tOdo
"Plug 'teto/neovim-auto-autoread' " works only in neovim, runs external checker
Plug 'benekastah/neomake' " async build for neovim
" Plug '~/neomake' " , {'branch': 'graphviz'}  async build for neovim
Plug 'mhinz/vim-signify' " Indicate changed lines within a file using a VCS.
" Plug 'teddywing/auditory.vim' " play sounds as you type

" does not work seems to be better ones
" Plug 'vasconcelloslf/vim-interestingwords' " highlight the words you choose <leader>k (does not work in neovim)
Plug 't9md/vim-quickhl' " hl manually selected words :h QuickhlManualEnable

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
Plug 'chrisbra/csv.vim', {'for': 'csv'}
" Plug 'luochen1990/rainbow' " does it work ?
"Plug 'eapache/rainbow_parentheses.vim'  " Display successive delimiters such as [,(... with different colors 
Plug 'junegunn/rainbow_parentheses.vim'
" {{{ Latex attempts
" this one could not compile my program
" "Plug 'vim-latex/vim-latex', {'for': 'tex'}
" " ATP author gh mirror seems to be git@github.com:coot/atp_vim.git
" "Plug 'coot/atp_vim', {'for': 'tex'}
Plug 'lervag/vimtex', {'for': 'tex'} " so far the best one
" }}}

" Plug 'vim-scripts/YankRing.vim' " breaks in neovim, overrides yy as well

call plug#end()
" }}}



" K works in vim files
autocmd FileType vim setlocal keywordprg=:help





" start scrolling before reaching end of screen in order to keep more context
set scrolloff=3


" vim-lastplace to restore cursor position {{{
let g:lastplace_ignore = "gitcommit,svn"
" }}}

" Indentation {{{
set tabstop=4 " a tab takes 4 characters (local to buffer)
set shiftwidth=4 " Number of spaces to use per step of (auto)indent.
set smarttab "use shiftwidth
set smartindent " might need to disable ?

set cindent
set cinkeys-=0# " list of keys that cause reindenting in insert mode
set indentkeys-=0#

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



set title " vim will change terminal title
" look at :h statusline to see the available 'items'
" to count the number of buffer
" echo len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
let &titlestring=" %t %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) } - NVIM"


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

syntax on


" backup files etc... {{{
set noswapfile
" set undodir=~/.vim/tmp/undo//     " undo files
" set backupdir=~/.vim/tmp/backup// " backups
" set directory=~/.vim/tmp/swap//   " swap files
" }}}

" Wildmenu completion {{{

" display a menu when need to complete a command 
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest,full " zsh way ?!
"Ignore these files when completing names and in Explorer
" set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif


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
set modelines=4 "number of lines checked
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

"
imap <silent> <C-k> <Up>
imap <silent> <C-j> <Down>


" Window / splits {{{
"cmap w!! w !sudo tee % >/dev/null
" vim: set noet fenc=utf-8 ff=unix sts=0 sw=4 ts=4 : 
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

nmap  <D-Up> :wincmd k<CR>
nmap <silent> <D-Down> :wincmd j<CR>
nmap <silent> <D-Left> :wincmd h<CR>
nmap <silent> <D-Right> :wincmd l<CR>

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


"wnmap = *normal mode* mapping
"nmap <silent> ^[OC :wincmd l<CR>
"nmap <silent> ^[OC :wincmd h<CR>
"nmap <silent> OC :wincmd l<CR>
"nmap <silent> OD :wincmd h<CR>

" window nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>

" nnoremap <silent> + :exe "resize +3"
" nnoremap <silent> - :exe "resize -3"

set splitbelow	" on horizontal splits
set splitright   " on vertical split

" }}}


" {{{ Markdown composer
" Run with :ComposerStart
let g:markdown_composer_open_browser        = "qutebrowser"
let g:markdown_composer_autostart           = 1
" }}}
"set winheight=30
"set winminheight=5

" instant restructured text {{{
let g:instant_rst_browser = "qutebrowser"
let g:instant_rst_additional_dirs=[ "/home/teto/mptcpweb" ]
" }}}

" Appearance {{{
set background=dark " remember: does not change the background color !
set fillchars=vert:│,fold:>,stl:\ ,stlnc:\ ,diff:-
" one  ▶

set noshowmode " Show the current mode on command line
set cursorline " highlight cursor line

" set diffopt=filler

set autoread " automatically reload file when it has been changed (hope they fix this damn feature one day)
" set noautoread " to prevent from interfering with our plugin
set wrap
" set breakat=80 " characters at which wrap can break line
set linebreak " better display (makes sense only with wrap)
set breakindent " preserve or add indentation on wrap
let &showbreak = '↳ '  	" displayed in front of wrapped lines

filetype on                   " required! (still required in vim ?)
set backspace=indent,eol,start
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

" i3 autocommands {{{
" todo when opening i3 files, set makeprg to build_config
" augroup i3
" autcmd! 

"   autocmd BufWinEnter  call ResCur()
" augroup END

" }}}

" interesting words {{{
"nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
"nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
" let g:terminal_color_0 = "#202020"
" let g:interestingWordsTermColors = ['#202020', '121', '211', '137', '214', '222']
" let g:interestingWordsTermColors = ['#aeee00', '#ff0000', '#0000ff', '#b88823', '#ffa724', '#ff2c4b']

" }}}

" to remove timeout when changing modes
" if ! has('gui_running')
"     set ttimeoutlen=10
"     augroup FastEscape
"         autocmd!
"         au InsertEnter * set timeoutlen=0
"         au InsertLeave * set timeoutlen=1000
"     augroup END
" endif


"nnoremap <leader>r :!%:p<return>


set shiftround    " round indent to multiple of 'shiftwidth'

" auto reload vim config on save
" Watch for changes to vimrc

augroup myvimrc
  au!
  au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END


" open vimrc
nnoremap <Leader>ev :e $MYVIMRC<CR> 
"nnoremap <Leader>ep :vs ~/.vim/plug.vim<CR> 
" reload vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR> 

" open netrw/dirvish split
nnoremap <Leader>e :Vex<CR> 
nnoremap <Leader>w :w<CR>

" mostly fzf mappings, use TAB to mark several files at the same time
" https://github.com/neovim/neovim/issues/4487
nnoremap <Leader>o :FzfFiles<CR>
nnoremap <Leader>g :FzfGitFiles<CR>
nnoremap <Leader>F :FzfFiletypes<CR>
nnoremap <Leader>h :FzfHistory<CR>
nnoremap <Leader>c :FzfCommits<CR>
nnoremap <Leader>C :FzfColors<CR>
nnoremap <leader>b :FzfBuffers<CR>
nnoremap <leader>m :FzfMarks<CR>
nnoremap <leader>u :UndoTreeToggle<CR>
" nnoremap <leader>t :UndoTreeToggle<CR>

" fails with neovim use :te instead ?
"nnoremap <leader>r :<C-U>RangerChooser<CR> 

"nnoremap <F8> :vertical wincmd f<CR> " open file under cursor in a split
nnoremap <leader>gfs :vertical wincmd f<CR> " open file under cursor in a split

" Chromatica (needs libclang > 3.9) {{{
" can compile_commands.json or a .clang file
" let g:chomatica#respnsive_mode=1
" let g:chromatica#libclang_path='/usr/local/opt/llvm/lib'
let g:chromatica#libclang_path="/usr/lib/llvm-3.8/lib/"


let g:chromatica#enable_at_startup=1
let g:chromatica#enable_debug=1
let g:chromatica#global_args= [] " prepended for each file compile args
let g:chromatica#responsive_mode = 0 
let g:chromatica#delay_ms = 80
let g:chromatica#use_pch = 1
let g:chromatica#highlight_feature_level=0
" }}}

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

" Advanced customization using autoload functions
"autocmd VimEnter * command! Colors
  "\ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})
" Advanced customization using autoload functions
" }}}

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
let g:ycm_complete_in_comments = 1
let g:ycm_error_symbol = s:gutter_error_sign " used to signal errors in gutter
let g:ycm_warning_symbol = s:gutter_warn_sign " warn in gutter 
let g:ycm_show_diagnostics_ui = 1 " show info in gutter
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_detailed_diagnostics = '<leader>d'
" several solutions available: horizontal-split, new-tab, new-or-existing tab
let g:ycm_goto_buffer_command = 'same-buffer' 
let g:ycm_server_log_level = 'debug'

" Add triggers to ycm for LaTeX-Box autocompletion
let g:ycm_semantic_triggers = {
      \  'tex'  : ['{'],
      \ 'mail' : ['@'],
      \ }


let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_completion = 1

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <F6> :YcmDebugInfo<CR>

"You may also want to map the subcommands to something less verbose; for instance, nnoremap <leader>jd :YcmCompleter GoTo<CR> maps the <leader>jd sequence to the longer subcommand invocation.

"The various GoTo* subcommands add entries to Vim's jumplist so you can use CTRL-O to jump back to where you where before invoking the command (and CTRL-I to jump forward; see :h jumplist for details).

nnoremap <leader>jd :YcmCompleter GoTo<CR>
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#disable_auto_complete = 1
let g:deoplete#enable_debug = 1

" deoplete clang {{{2
let g:deoplete#sources#clang#libclang_path="/usr/lib/llvm-3.8/lib/libclang.so"

" Let <Tab> also do completion
" inoremap <silent><expr> <Tab>
" \ pumvisible() ? "<C-n>" :
" \ deoplete#mappings#manual_complete()
" deoplete tab-complete
" nnoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" }}}

" deoplete jedi {{{2
let deoplete#sources#jedi#enable_cache=1
let deoplete#sources#jedi#show_docstring=0
" }}}
" }}}

" Jedi (python) completion {{{
let g:jedi#auto_vim_configuration = 1 " to prevent python's help popup
let g:jedi#completions_enabled = 0 " disable when deoplete in use
"autocmd BufWinEnter '__doc__' setlocal bufhidden=delete
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
" let g:airline_section_b = ""
" section y is fileencoding , useless in neovim
let g:airline_section_y = ""  
 " airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
" let g:airline_section_z = airline#section#create_right(['linenumber'])
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_buffers = 1  
let g:airline#extensions#tabline#buffer_min_count =2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_tabs = 0



let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline_extensions = ['branch', 'tabline', 'obsession']

" rely on tagbar plugin
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'

" csv plugin
let g:airline#extensions#csv#enabled = 1
let g:airline_detect_spell=1

" ycm integration
let g:airline#extensions#ycm#enabled = 1
let g:airline#extensions#ycm#error_symbol = s:gutter_error_sign
let g:airline#extensions#ycm#warning_symbol = s:gutter_warn_sign

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2

let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '$'
" let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long' ]
"|neomake#statusline#LoclistStatus should be shown in warning section
" let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}'])
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

"}}}

" close the preview window on python completion
" autocmd CompleteDone * pclose 

" set completeopt=menu:

" Neomake config {{{
let g:neomake_verbose = 1
let g:neomake_python_enabled_makers = ['pyflakes']
let g:neomake_logfile = $HOME.'/neomake.log'
let g:neomake_c_gcc_args = ['-fsyntax-only', '-Wall']
let g:neomake_open_list = 0

let g:neomake_airline = 1
let g:neomake_echo_current_error = 1
let g:neomake_place_signs=1


let g:neomake_error_sign = { 'text': s:gutter_error_sign, 'texthl': 'ErrorSign' }
let g:neomake_warning_sign = { 'text': s:gutter_warn_sign , 'texthl': 'WarningSign' }

" C and CPP are handled by YCM and java usually by elim
let s:neomake_exclude_ft = [ 'c', 'cpp', 'java' ]
"let g:neomake_python_pep8_maker
" let g:neomake_tex_checkers = [ '' ]
" let g:neomake_tex_enabled_makers = []
let g:neomake_tex_enabled_makers = []
" let g:neomake_tex_enabled_makers = ['chktex']
" }}}

" Startify config {{{
nnoremap <Leader>st :Startify<cr>

let g:startify_list_order = [
      \ ['   MRU '.getcwd()], 'dir',
      \ ['   MRU'],           'files' ,
      \ ['   Bookmarks'],     'bookmarks',
      \ ['   Sessions'],      'sessions',
      \ ]
let g:startify_use_env = 0
let g:startify_disable_at_vimenter = 0
let g:startify_session_dir = $XDG_DATA_HOME.'/nvim/sessions'
let g:startify_bookmarks = [
      \ {'i': $XDG_CONFIG_HOME.'/i3/config.main'},
      \ {'z': $XDG_CONFIG_HOME.'/zsh/'},
      \ {'m': $XDG_CONFIG_HOME.'/mptcpanalyzer/config'},
      \ {'n': $XDG_CONFIG_HOME.'/ncmpcpp/config'},
      \ ]
      " \ {'q': $XDG_CONFIG_HOME.'/qutebrowser/qutebrowser.conf'},
let g:startify_files_number = 10
let g:startify_session_autoload = 1
let g:startify_session_persistence = 0
let g:startify_change_to_vcs_root = 0
let g:startify_session_savevars = []
let g:startify_session_delete_buffers = 1
" }}}

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
" Pour le rappel 
" <localleader>ll pour la compilation continue du pdf
" <localleader>lv pour la preview du pdf
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_latexmk_progname = 'nvr'
" let g:latex_view_general_viewer = 'zathura'
let g:vimtex_fold_enabled = 0
let g:vimtex_format_enabled = 0
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_complete_close_braces = 0
let g:vimtex_fold_comments=1
let g:vimtex_quickfix_autojump = 0
let g:vimtex_quickfix_ignore_all_warnings =0
let g:vimtex_view_use_temp_files=0 " to prevent zathura from flickering
" let g:vimtex_latexmk_options
let g:vimtex_syntax_minted = [
      \ {
      \   'lang' : 'json',
      \ }]

let g:vimtex_quickfix_mode = 2 " 1=> opened automatically and becomes active
let g:vimtex_quickfix_ignored_warnings = [
      \ 'Underfull',
      \ 'Overfull',
      \ 'specifier changed to',
      \ ]
"let g:tex_stylish = 1
"let g:tex_flavor = 'latex'
"let g:tex_isk='48-57,a-z,A-Z,192-255,:'
let g:vimtex_latexmk_callback= 0
" if !exists('g:ycm_semantic_triggers')
"     let g:ycm_semantic_triggers = {}
" endif

let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*,?)*',
    \ 're!\\includegraphics([^]]*])?{[^}]*',
    \ 're!\\(include|input){[^}]*'
    \ ]
"<plug>(vimtex-toc-toggle)
"<plug>(vimtex-labels-toggle)
    " autocmd FileType tex nnoremap <leader>lt <plug>(vimtex-toc-toggle)
  "augroup latex
    "autocmd!
    "autocmd FileType tex nnoremap <buffer><F4> :VimtexView<CR>
    "autocmd FileType tex nnoremap <buffer><F5> :VimtexCompile<CR>
    "autocmd FileType tex map <silent> <buffer><F8> :call vimtex#latexmk#errors_open(0)<CR>
  "augroup END
"" }}}

" Pymode {{{
let g:pymode_python = 'python3'
let g:pymode_warnings = 1
let g:pymode_paths = []
let g:pymode_indent = 1
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 0
let g:pymode_folding = 0
let g:pymode_doc = 0
" C means class, M method for instance
" ]M                Jump to next class or method (normal, visual, operator modes)
let g:pymode_motion = 1 
let g:pymode_rope_goto_definition_bind = 'gd'
let g:pymode_lint = 0 " done by Neomake
" ROpe is interesting, enables
let g:pymode_rope = 0 " rope is for semantic analysis jedi vim looks better
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_rope_show_doc_bind = '<C-c>d'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_rope_goto_definition_cmd = 'new'

let g:pymode_breakpoint = 0 " consumes <Leader>b otherwise
" let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_virtualenv = 1
" " hl self keyword
" let g:pymode_syntax_highlight_self = g:pymode_syntax_all 
" }}}

" vim-listchars config {{{
    "\"trail:·,tab:→\ ,eol:↲,precedes:<,extends:>"
"let g:listchar_formats=[ 
   "\"trail:·",
    "\"trail:>"
   "\]
    "\"extends:>"
" while waiting to finish my vim-listchars plugin
"set listchars=tab:»·,eol:↲,nbsp:␣,extends:…
"set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
" }}}

" Grepper {{{
" add -cword to automatically fill with the underlying word
" example given by mhinz to search into current buffer
" let g:grepper = { 'git': { 'grepprg': 'git grep -nI $* -- $.' }}
nnoremap <leader>git :Grepper  -tool git -open -nojump
nnoremap <leader>ag  :Grepper -tool ag  -open -switch
" -noswitch
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
" }}}

" sidesearch {{{
" SideSearch current word and return to original window
nnoremap <Leader>ss :SideSearch <C-r><C-w><CR> | wincmd p

" Create an shorter `SS` command
command! -complete=file -nargs=+ SS execute 'SideSearch <args>'

" or command abbreviation
cabbrev SS SideSearch" 
" }}}

" folding config {{{
" block,hor,mark,percent,quickfix,search,tag,undo
" set foldopen+=all
" set foldclose=all
"set foldtext=
set foldcolumn=3
" }}}

" will load a .exrc or .nvimrc file if finds it current directory
set exrc

" vim-sneak {{{
let g:sneak#s_next = 1 " can press 's' again to go to next result, like ';'
let g:sneak#prompt = 'Sneak>'

let g:sneak#streak = 0
    " nmap f <Plug>Sneak_s
    " nmap F <Plug>Sneak_S
    " xmap f <Plug>Sneak_s
    " xmap F <Plug>Sneak_S
    " omap f <Plug>Sneak_s
    " omap F <Plug>Sneak_S
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

" signify (display added/removed lines from vcs) {{{
let g:signify_vcs_list = [ 'git']
" let g:signify_mapping_next_hunk = '<leader>hn' " hunk next
" let g:signify_mapping_prev_hunk = '<leader>gk' 
let g:signify_mapping_toggle_highlight = '<leader>gh' 
let g:signify_line_highlight = 0 " display added/removed lines in different colors
"let g:signify_line_color_add    = 'DiffAdd'
"let g:signify_line_color_delete = 'DiffDelete'
"let g:signify_line_color_change = 'DiffChange' 
" let g:signify_mapping_toggle = '<leader>gt'
" let g:signify_sign_add =  '+'
let g:signify_sign_add =  "\u00a0" " unbreakable space
let g:signify_sign_delete            = "\u00a0"
" let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = "\u00a0" 
" let g:signify_sign_changedelete      = g:signify_sign_change
" let g:signify_sign_show_count|

let g:signify_cursorhold_insert     = 0
let g:signify_cursorhold_normal     = 0
let g:signify_update_on_bufenter    = 0
let g:signify_update_on_focusgained = 1
" hunk jumping
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" }}}

" autosave plugin (:h auto-save) {{{
let g:auto_save_in_insert_mode = 1
let g:auto_save_events = ['FocusLost']
"let g:auto_save_events = ['CursorHold', 'FocusLost']
let g:auto_save_write_all_buffers = 0 " Setting this option to 1 will write all
" Put this in vimrc, add custom commands in the function.
function! AutoSaveOnLostFocus()
  " to solve pb with Airline https://github.com/vim-airline/vim-airline/issues/1030#issuecomment-183958050
  exe ":au FocusLost ".expand("%")." :wa | :AirlineRefresh | :echom 'Focus lost'"
endfunction
" }}}

" Customized commands depending on buffer type {{{

nnoremap <LocalLeader>sv :source $MYVIMRC<CR> " reload vimrc
" }}}

" {{{ vim-scripts/QuickFixCurrentNumber
"*:QuickhlManualEnable*		Enable.
" }}}

" Tips from vim-galore {{{

" to alternate between header and source file
autocmd BufLeave *.{c,cpp} mark C
autocmd BufLeave *.h       mark H

" Don't lose selection when shifting sidewards
"xnoremap <  <gv
"xnoremap >  >gv

" todo do the same for .Xresources ?
autocmd BufWritePost ~/.Xdefaults call system('xrdb ~/.Xdefaults')
" }}}

" Dirvish {{{
let g:loaded_netrwPlugin = 1 " ???
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
" }}}

" riv restdown config {{{
let g:riv_disable_folding=1
let g:riv_disable_indent=0
" }}}

" easymotion {{{
let g:EasyMotion_do_shade = 1
let g:EasyMotion_do_mapping = 1
let g:EasyMotion_use_upper = 1 " display upper case letters but let u type lower case
let g:EasyMotion_inc_highlight = 0
let g:EasyMotion_disable_two_key_combo = 0

map , <Plug>(easymotion-prefix)
" }}}

" quickhl (similar to interesting words) {{{
" nmap <Space>m <Plug>(quickhl-manual-this)
" xmap <Space>m <Plug>(quickhl-manual-this)
" nmap <Space>M <Plug>(quickhl-manual-reset)
" xmap <Space>M <Plug>(quickhl-manual-reset)
" }}}

set hidden " you can open a new buffer even if current is unsaved (error E37)

autocmd syntax text setlocal textwidth=80 

" draw a line on 80th column
set colorcolumn=80

set diffopt=filler,vertical " default behavior for diff

" Y behave like D or C
nnoremap Y y$


" search items in location list (per window)
nnoremap <F1> :lprev<CR>
nnoremap <F2> :lnext<CR>
" search for  item in quickfix list (global/unique)
nnoremap <F3> :cprev<CR>
nnoremap <F4> :cnext<CR>

nnoremap <F5> :Neomake<CR>
nnoremap <F6> :AutoSaveToggle<CR>
"nnoremap <F6> :AutoSaveOnLostFocus<CR>
" goto previous buffer
nnoremap <F7> :bp<CR> 
nnoremap <F8> :bn<CR>
" est mappe a autre chose pour l'instant
"noremap <F4> exec ":emenu <tab>"
" should become useless with neovim
noremap <F10> :set paste!<CR>
map <F11> <Plug>(ToggleListchars)

" Command to toggle line wrapping.
nnoremap <Leader>wr :set wrap! \| :set wrap?<CR>

" vim:foldmethod=marker:foldlevel=0
" Get off my lawn
"noremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

" flashy config {{{
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
let g:operator#flashy#flash_time=300 " in milliseconds
" }}}

" tagbar {{{
let g:tagbar_left = 0

let g:tagbar_indent = 1

let g:tagbar_show_linenumbers= 1
" }}}
nnoremap <silent> <Leader>B :TagbarToggle<CR>
" set vim's cwd to current file's
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

if has('nvim')
	"runtime! python_setup.vim
 " when launching term
	tnoremap <Esc> <C-\><C-n>
endif


" Run linting when writing file
autocmd! BufWritePost * Neomake

" Bye bye ex mode
noremap Q <NOP>

" location list / quickfix config {{{
" location list can be associated with only one window.  
" The location list is independent of the quickfix list.
" ListToggle config {{{
nnoremap <kPageUp> :lprev
nnoremap <kPageDown> :lnext
nnoremap <kPageRight> :lnext
nnoremap <kPageRight> :lnext
nnoremap <k2> :echom "hello world"
let g:lt_location_list_toggle_map = '<F2>' " '<leader>l'
let g:lt_quickfix_list_toggle_map = '<F1>' " '<leader>qq'
" }}}

" buffers
map <Leader>n :bnext<CR>
map <Leader>N :bNext<CR>
map <Leader>p :bprevious<CR>
map <Leader>O :Obsession<CR>
" map <Leader>d :bdelete<CR>
" TODO trigger a menu in vim

"http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious

" todo better if it could be parsable
" map <Leader>t :!trans :fr -no-ansi <cword><CR>
map <Leader>t :te trans :fr <cword><CR>
map <Leader><space> :b#<CR>

" Unimpaired {{{
" advised by tpope for these remote countries that don't use qwerty
" https://github.com/tpope/vim-unimpaired
" nmap < [
" nmap > ]
" omap < [
" omap > ]
" xmap < [
" xmap > ]
" }}}

set showcmd " show pending command bottom right
set showfulltag "test 

" indents
"nmap <S-Tab> <<
"nmap <Tab> >>
"vmap <S-Tab> <gv
"vmap <Tab> >gv
" call orchestra#prelude()
" call orchestra#set_tune('clackclack')

" azerty customizations : utilise <C-V> pour entrer le caractère utilisé {{{
"https://www.reddit.com/r/vim/comments/2tvupe/azerty_keymapping/
" parce que # est l'opposé de * et ù est a coté de *
map ù %  
noremap             <C-j>           }
noremap             <C-k>           {

" }}}
"'.'
"set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada

" added 'n' to defaults to allow wrapping lines to overlap with numbers
set cpoptions="aABceFsn" " vi ComPatibility options
set matchpairs+=<:>  " Characters for which % should work

" TODO to use j/k over 
" set whichwrap+=<,>,h,l

" Interactive menus {{{1
" use emenu ("execute menu") to launch the command
" disable all menus
unmenu * 
map <Leader>s :setlocal spell spelllang=en_us<CR>
menu Spell.EN_US :setlocal spell spelllang=en_us<CR>
menu Spell.FR :setlocal spell spelllang=fr_fr<CR>

menu Trans.FR :te trans :fr <cword><CR>

" tab menu {{{2
menu Tabs.S2 :set expandtab ts=2 sts=2 sw=2<CR>
menu Tabs.S4 :set expandtab ts=4 sts=4 sw=4<CR>
menu Tabs.S6 :set expandtab ts=6 sts=6 sw=6<CR>
menu Tabs.S8 :set expandtab ts=8 sts=8 sw=8<CR>
"}}}
" }}}

" nvim specific configuration {{{

if has("nvim")
  " should work with vim also but need a very new vim
  set termguicolors
  "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
  let g:netrw_home=$XDG_DATA_HOME.'/nvim'
  "now ignored 
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif
" }}}

" colorscheme stuff {{{
" as we set termguicolors, 
" highlight Comment gui="NONE,italic"; e
" echom "colorscheme changed" |
" to underline search results instead of highlighting them
" set to NONE not to change them
" :help hl-IncSearch
" MatchParen(theses)
autocmd ColorScheme *
      \ highlight Comment gui=italic
      \ | highlight Search gui=undercurl
      \ | highlight MatchParen guibg=NONE guifg=NONE gui=underline
      " \ | highlight IncSearch guibg=NONE guifg=NONE gui=underline
" highlight Comment gui=italic

" put it after teh autocmd ColorScheme
colorscheme molokai

" }}}


highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227 guibg=#F08A1F
