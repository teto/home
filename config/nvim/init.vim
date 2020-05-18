" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" to debug vimscript, use :mess to display error messages
" :scriptnames to list loaded scripts
" and prefix you command with 'verbose' is a very good way to get info
" like ':verbose map J' to know where it was loaded last
" ❌

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
"
"

" map <C-D> <C-]>
" map <C-D> :tag<CR>
map <D-b> :echom "hello papy"

"$NVIM_PYTHON_LOG_FILE
" to test startup time
" nvim --startuptime startup.log
" nvim -u NONE --startuptime startup.log
" to see the difference highlights,
" runtime syntax/hitest.vim

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
" Dealing with pdf {{{
" Read-only pdf through pdftotext / arf kinda fails silently on CJK documents
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

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

nnoremap <C-RightMouse> :call SynStack()<CR>
" }}}
set cpoptions="aABceFsn" " vi ComPatibility options
" should not be a default ?
set cpoptions-=_

" mouse {{{
set mouse=a
set mousemodel=popup
" }}}
let mapleader = " "
let maplocalleader = ","

" Appearance 1 {{{
let s:gutter_error_sign = "✘'"
let s:gutter_warn_sign = '！'
" }}}

" GIT DIFF http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/ {{{
" the left window contains the version from the target branch
" the middle window contains the working copy of the file, complete with conflict markers
" the right window contains the version from the merge branch
" }}}

" from FAQ https://github.com/neovim/neovim/wiki/FAQ
vnoremap <LeftRelease> "*ygv

" inverts the meaning of g in substitution, ie with gdefault, change all
" occurences
set gdefault
" lustyjuggler plugin
" https://github.com/sjbach/lusty

" nvim will load any .nvimrc in the cwd; useful for per-project settings
set exrc
set completeopt=menu " use pum to show completions


" vim-plug plugin declarations {{{1
call plug#begin(s:plugdir)
" annotations plugins {{{
Plug 'MattesGroeger/vim-bookmarks' " ruby  / :BookmarkAnnotate
" 'wdicarlo/vim-notebook' " last update in 2016
" 'plutonly/vim-annotate" "  last update in 2015
"}}}
" branch v2-integration
" Plug 'andymass/vim-matchup' " to replace matchit
" Plug 'AGhost-7/critiq.vim' " :h critiq
" Plug 'thaerkh/vim-workspace'  " :ToggleWorkspace
Plug 'skywind3000/vim-quickui' " 
Plug 'liuchengxu/vista.vim' " replaces tagbar to list workplace symbols
Plug 'neovim/nvim-lsp' " while fuzzing details out
" Plug '~/nvim-lsp' " while fuzzing details out
" Plug 'puremourning/vimspector' " to debug programs
Plug 'bfredl/nvim-luadev'  " lua repl :Luadev
Plug 'hotwatermorning/auto-git-diff' " to help rebasing
" Plug 'christoomey/vim-conflicted' " toto
Plug 'norcalli/nvim-terminal.lua' " to display ANSI colors
Plug 'bogado/file-line' " to open a file at a specific line
" Plug 'yuki-ycino/fzf-preview.vim' " toto
Plug 'glacambre/firenvim' " to use nvim in firefox
" Plug 'liuchengxu/vim-clap' " fuzzer
" Plug 'alok/notational-fzf-vim' " to take notes, :NV
" Plug 'iamcco/markdown-preview.nvim' " :MarkdownPreview
Plug 'suy/vim-context-commentstring' " commen for current programming language
" Plug 'voldikss/vim-translate-me' " floating windows for neovim
Plug 'neovimhaskell/nvim-hs.vim' " to help with nvim-hs
Plug 'elbeardmorez/vim-loclist-follow' " to have quicklist synced with cursor
" call :NR on a region than :w . coupled with b:nrrw_aucmd_create,
Plug 'chrisbra/NrrwRgn' " to help with multi-ft files
Plug 'chrisbra/vim-diff-enhanced' "
" Plug 'mhinz/vim-signify' " Indicate changed lines within a file using a VCS.
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'shime/vim-livedown'  " :LivedownPreview
Plug 'conornewton/vim-pandoc-markdown-preview' " :StartMdPreview / StopMd

" around vcs {{{
Plug 'idanarye/vim-merginal'  " fugitive extension :Merginal
Plug 'rhysd/git-messenger.vim' " to show git message :GitMessenger
" Plug 'junegunn/gv.vim' " git commit viewer :Gv

" }}}

" filetype related {{{
Plug 'neomutt/neomutt.vim' " syntax file for neomutt
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for RFC files
" Plug 'vim-scripts/coq-syntax', {'for': 'coq'}
"}}}
" Plug 'moznion/github-commit-comment.vim' " last update from 2014
" Plug 'dhruvasagar/vim-open-url' " gB/gW to open browser
" Plug 'Carpetsmoker/xdg_open.vim' " overrides gx
Plug 'mcchrish/info-window.nvim'  " to display buffer information in a popup
Plug 'tweekmonster/nvim-api-viewer', {'on': 'NvimAPI'} " see nvim api
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'} " see startup time per script
Plug 'vim-scripts/vis' " ?
Plug 'Konfekt/vim-CtrlXA' " use ctrl a/xto cycle between different words
Plug 'AndrewRadev/splitjoin.vim' " gS/gJ to
Plug '~/nvim-palette', { 'do': ':UpdateRemotePlugins' }
" Plug 'jamessan/vim-gnupg' " does not support neovim yet ?

" autocompletion 
" Plug 'ncm2/ncm2'  " completion manager

" deoplete {{{
" new deoplete relies on yarp :
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/deoplete-lsp'

" crashes without netrc
" Plug 'deoplete-plugins/deoplete-make' " empty !
" Plug 'deoplete-plugins/deoplete-zsh'
" Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'SevereOverfl0w/deoplete-github' " completion on commit issues (just

" Plug 'fszymanski/deoplete-abook' " replaced with the khard one
" Plug 'paretje/deoplete-notmuch', {'for': 'mail', 'do': ':UpdateRemotePlugins'}
" Plug 'nicoe/deoplete-khard', {'for': 'mail'}
"}}}

" Plug 'LnL7/vim-nix', {'for': 'nix'}
" Plug 'romainl/vim-qf' " can create pb with neomake
Plug 'editorconfig/editorconfig-vim' " not remote but involves python
Plug 'neomake/neomake' " just for nix and neovim dev with nvimdev ?
" provider
" Plug 'msrose/vim-perpetuloc' " Cursor-based location list jumping for vim (Lnext)
" Plug 'brooth/far.vim', { 'do': ':UpdateRemotePlugins' } " search and replace across files
" needs ruby support, works in recent neovim
Plug 'junegunn/vim-github-dashboard', { 'do': ':UpdateRemotePlugins' }
Plug 'fmoralesc/vim-pad', {'branch': 'devel'} " :Pad new, note taking
" to test https://github.com/neovim/neovim/issues/3688
" Plug 'haya14busa/incsearch.vim' " just to test
" while waiting for my neovim notification provider...
Plug 'tjdevries/descriptive_maps.vim', {'do': ':UpdateRemotePlugins' } " :call DescriptiveStart()
Plug 'gianarb/notify.vim' " call notify#emitNotification('Title', 'Body')
" Plug 'the-lambda-church/coquille', {'branch': 'matt', 'for': 'coq'}
" Plug 'inside/vim-search-pulse' " Search related
" Plug 'adborden/vim-notmuch-address' " does not work yet

" vim-search-pulse {{{
let g:vim_search_pulse_mode = 'cursor_line'
let g:vim_search_pulse_duration = 400
"}}}

" Plug 'ehamberg/vim-cute-python' " display unicode characters, kinda looks bad on vim grid
Plug 'dbakker/vim-projectroot' " projectroot#guess()
Plug 'sunaku/vim-dasht' " get documentation (zeavim is also a contender KabbAmine/zeavim.vim)
" Plug 'mtth/scratch.vim' " , {'on': 'Scratch'} mapped to ?
" Plug 'tjdevries/vim-inyoface.git' "InYoFace_toggle to display only comments
" todo depend de rust
" Plug 'mhinz/vim-halo' " to hight cursor line
" Plug 'ludovicchabant/vim-gutentags' " automatic tag generation, very good
Plug 'junegunn/goyo.vim', {'on': 'Goyo'} "distraction free writing focus
Plug 'junegunn/limelight.vim' " highlights
Plug 'calvinchengx/vim-aftercolors' " load after/colors
" Plug 'ntpeters/vim-better-whitespace' " StripWhitespace care it stole my
" leader
Plug 'bronson/vim-trailing-whitespace' " :FixWhitespace
" Plug 'tpope/vim-scriptease' " Adds command such as :Messages
" Plug 'tpope/vim-eunuch' " {provides SudoEdit, SudoWrite , Unlink, Rename etc...

" REPL (Read Execute Present Loop) {{{
" Plug 'metakirby5/codi.vim', {'on': 'Codi'} " repl
" careful it maps cl by default
" Plug 'vigemus/iron.nvim'    ", { 'branch': 'lua/replace' }
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
Plug 'SirVer/ultisnips' " handle snippets
" " Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'

" Plug 'sjl/gundo.vim' " :GundoShow/Toggle to redo changes
" Plug 'vim-scripts/DrawIt' " to draw diagrams
" Plug 'Yggdroot/indentLine',{ 'for': 'python' }  " draw verticals indents but seems greedy
" Plug 'beloglazov/vim-online-thesaurus' " thesaurus => dico dde synonymes


""" contact autocompletion

" to configure vim for haskell, refer to
" http://yannesposito.com/Scratch/en/blog/Vim-as-IDE/
"{{{
Plug 'neovimhaskell/haskell-vim', {'for':'haskell'} " haskell install
" Plug 'enomsg/vim-haskellConcealPlus', {'for':'haskell'}     " unicode for haskell operators
" Plug 'bitc/vim-hdevtools'
"
" Plug 'ncm2/float-preview.nvim'
"}}}

"Plug 'mattn/vim-rtags' a l'air léger
" Plug 'shaneharper/vim-rtags' " <leader>r ou bien :RtagsFind  mais ne marche pas
" Plug 'tpope/vim-unimpaired' " [<space> [e [n ]n pour gerer les conflits etc...
Plug 'mbbill/undotree' " replaces gundo

" Using a non-master branch

" filetypes {{{2
" Plug 'cespare/vim-toml', { 'for': 'toml'}
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'florentc/vim-tla'
" one competitor is https://github.com/hwayne/tla.vim/
" Plug 'dzeban/vim-log-syntax' " hl some keywords like ERROR/DEBUG/WARNING
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

" Plug 'Valloric/ListToggle' " toggle location/quickfix list toggling seems to fail
" Plug 'git@github.com:milkypostman/vim-togglelist' " same
" still problems with airline when installed via nix
Plug '907th/vim-auto-save' " :h auto-save
" Plug 'teto/vim-auto-save' " autosave :h auto-save
" Plug 'bfredl/nvim-miniyank' " killring alike plugin, cycling paste careful search for :Yank commands
" hangs with big strings

" Text objects {{{
Plug 'michaeljsmith/vim-indent-object'
Plug 'tommcdo/vim-lion' " Use with gl/L<text object><character to align to>
" Plug 'tommcdo/vim-exchange' " Use with cx<text object> to cut, cxx to exchange
" Plug 'tommcdo/vim-kangaroo' "  zp to push/zP to pop the position
" Plug 'tommcdo/vim-ninja-feet' " care overwrites z]
" }}}
" {{{ To ease movements
" Plug 'rhysd/clever-f.vim'
"Plug 'unblevable/quick-scope'  " highlight characeters to help in f/F moves
" Plug 'Lokaltog/vim-easymotion' " careful overrides <leader><leader> mappings
"Plug 'wellle/visual-split.vim'
Plug 'wellle/targets.vim' " Adds new motion targets ci{
" Plug 'justinmk/vim-ipmotion' " ?
" }}}

Plug 'dietsche/vim-lastplace' " restore last cursor postion (is it still needed ?)
" Powerline does not work in neovim hence use vim-airline instead
Plug 'vim-airline/vim-airline'
" Plug '~/vim-airline'
Plug 'vim-airline/vim-airline-themes' " creates problems if not here
" Plug 'hrsh7th/vim-vsnip' " vscode/lsp snippet format
" Plug 'hrsh7th/vim-vsnip-integ'

Plug 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
Plug 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting
Plug 'teto/vim-listchars' " to cycle between different list/listchars configurations
"Plug 'tpope/vim-sleuth' " Dunno what it is
"Plug 'justinmk/vim-gtfo' " ?
Plug 'tpope/vim-rhubarb' " github support in fugitive, use |i_CTRL-X_CTRL-O|
"Plug 'jaxbot/github-issues.vim' " works only with vim
" Plug 'machakann/vim-sandwich' " deal with sandwiched objects
"Plug 'tpope/vim-surround' " don't realy know how to use yet
" Plug 'junegunn/vim-peekaboo' " gives a preview of buffers when pasting, need ruby ?

" Plug 'vhakulinen/gnvim-lsp' " load it only for gnvim

" , { 'for': 'markdown', 'do': function('BuildComposer') } " Needs rust, cargo, plenty of things :help markdown-composer
" move to nix
" euclio
" Plug '~/vim-markdown-composer'
" Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'Rykka/riv.vim', {'for': 'rst'}
Plug 'Rykka/InstantRst', {'for': 'rst'} " rst live preview with :InstantRst,
Plug 'dhruvasagar/vim-table-mode', {'for': 'txt'}

" Plug 'kshenoy/vim-signature' " display marks in gutter, love it
"Plug 'tomtom/quickfixsigns_vim'
Plug 'nacitar/a.vim' " :A
" Plug 'mhinz/vim-tree' " test
Plug 'mhinz/vim-rfc', { 'on': 'RFC' } " requires nokigiri gem
" can show a list of unicode characeters, with their name  :UnicodeTable etc...
" careful maps F4 by default
Plug 'teto/Modeliner' " <leader>ml to setup buffer modeline
" This one has bindings mapped to <leader>l
" Plug '~/vimwiki'   " to write notes
" Plug 'vimwiki/vimwiki', { 'branch': 'dev'}   " to write notes
"Plug 'teto/neovim-auto-autoread' " works only in neovim, runs external checker
" Plug 'rhysd/github-complete.vim' " provides github user/repo autocompletion after @ and #

" Plug 'ripxorip/aerojump.nvim'

Plug 'haorenW1025/diagnostic-nvim'  " LSP improvements OpenDiagnostic/PrevDiagnostic
" https://github.com/haorenW1025/completion-nvim/wiki/chain-complete-support
Plug 'haorenW1025/completion-nvim' " lsp based completion framework
" treesitter may slow down nvim
" Plug 'nvim-treesitter/completion-treesitter' " extension of completion-nvim
" Plug 'nvim-treesitter/highlight.lua' " to test treesitter

" github-comment requires webapi (https://github.com/mattn/webapi-vim)
" Plug 'mmozuras/vim-github-comment' " :GHComment
Plug 'kthibodeaux/pull-review'     " :PullReviewList

" does not work seems to be better ones
"
" Plug 'vasconcelloslf/vim-interestingwords' " highlight the words you choose <leader>k (does not work in neovim)
" Plug 't9md/vim-quickhl' " hl manually selected words :h QuickhlManualEnable

" colorschemes {{{
Plug 'whatyouhide/vim-gotham'
Plug 'sickill/vim-monokai'
Plug 'justinmk/molokai'
Plug 'mhinz/vim-janah'
Plug 'vim-scripts/Solarized'
Plug 'gruvbox-community/gruvbox'
Plug 'romainl/flattened'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
" }}}

" do not run it automatically, can be boring
" Plug 'chrisbra/csv.vim'

" editorconfig {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_max_line_indicator = "line"
" let g:EditorConfig_verbose = 1
" }}}
" Plug 'junegunn/rainbow_parentheses.vim' " the recommanded one
" {{{ Latex attempts
" lazyload creates problems
" TODO move to nix once https://github.com/neovim/neovim/issues/9390 is fixed
Plug 'lervag/vimtex'
" }}}

" Plug 'gregsexton/gitv'
" Plug 'jeffwilliams/basejump' " to alt+click on file:line and go to it
Plug 'teto/nvimdev.nvim' " thanks tweekmonster !
" Plug 'jceb/vim-orgmode' " orgmode
call plug#end()
" }}}

let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)

" start scrolling before reaching end of screen in order to keep more context
" set it to a big value
" set scrolloff=3

" Indentation {{{
set tabstop=4 " a tab takes 4 characters (local to buffer) abrege en ts
set shiftwidth=4 " Number of spaces to use per step of (auto)indent.
" set smarttab " when inserting tab in front a line, use shiftwidth
set smartindent " might need to disable ?

set cindent
set cinkeys-=0# " list of keys that cause reindenting in insert mode
set indentkeys-=0#

set shiftround " round indent to multiple of 'shiftwidth' (for << and >>)
set softtabstop=0 " inserts a mix of <Tab> and spaces, 0 disablres it
"set expandtab " replace <Tab with spaces
" }}}
" Netrw configuration {{{
" decide with which program to open files when typing 'gx'
" let g:netrw_gx
let g:netrw_browsex_viewer="xdg-open"
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'
let g:netrw_liststyle=1 " long listing with timestamp
" nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
" nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
" }}}
" Dirvish {{{
let g:loaded_netrwPlugin = 1 " ???
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
" }}}

set title " vim will change terminal title
" look at :h statusline to see the available 'items'
" to count the number of buffer
" echo len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
" let &titlestring=" %t %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) } - NVIM"
set titlestring=%{getpid().':'.getcwd()}

" conceal configuration {{{
" transforms some characters into their digraphs equivalent
" if your font supports it
" concealcursor " show current line unconcealed
"let g:tex_conceal="agdms"
"set conceallevel=2
" }}}

set showmatch

" set autochdir
" Use visual bell instead of beeping when doing something wrong
set visualbell
set errorbells " easier to test visualbell with it

" if boths are set at the same time, vim uses an hybrid mode
" Display line numbers on the left
set number
"Prefer relative line numbering?
set relativenumber
" TODO do a macro that cycles throught show/hide absolute/relative line numbers
map <C-N><C-N> <Cmd>set invnumber<CR>

" Display unprintable characters with '^' and
" set nolist to disable or set list!

" set timeoutlen=400 " Quick timeouts on key combinations.

" in order to scroll faster
" nnoremap <C-e> 3<C-e>
" nnoremap <C-y> 3<C-y>

" to load plugins in ftplugin matching ftdetect
filetype plugin on
syntax on
let g:vimsyn_embed = 'lP'  " support embedded lua, python and ruby
" don't syntax-highlight long lines
set synmaxcol=200

"{{{ deoplete
" configured in after/deoplete.vim
"}}}
" vimspector {{{
let g:vimspector_enable_mappings = 'HUMAN'
     

"}}}
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
" list:longest, " list breaks the pum
set wildmode=full " zsh way ?!

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

set wildoptions+=pum

" }}}
" Modeliner shortcuts  {{{
set modeline
set modelines=4 "number of lines checked
nmap <leader>ml <Cmd>Modeliner<Enter>
let g:Modeliner_format = 'et ff= fenc= sts= sw= ts= fdm='
" }}}
"clipboard {{{
" X clipboard gets aliased to +
set clipboard=unnamedplus
" copy to external clipboard
noremap gp "+p
noremap gy "+y
"}}}
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
" vimwiki {{{
let wiki_1 = {}
let wiki_1.path = '~/Nextcloud2/perso/notes'
let wiki_1.index = 'main'
let wiki_1.ext = '.wiki'
let g:vimwiki_list = [
  \ wiki_1, {'path': '~/dotfiles/tips'} 
  \ ]
"}}}
" {{{ Markdown composer
" Run with :ComposerStart
" let g:markdown_composer_open_browser        = "qutebrowser"
" if set to false then run ComposerStart
let g:markdown_composer_autostart           = 0
" from my fork
let g:markdown_composer_binary = "/nix/store/vham27qv1d8gab5xh4vvpbyal3vgfs8d-vim-markdown-composer-vim/bin/markdown-composer"
" }}}
" markdown preview {{{
let g:vim_markdown_preview_github=1
let g:vim_markdown_preview_use_xdg_open=1
"}}}
" vim-lastplace to restore cursor position {{{
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
" }}}
" far config (Find And Replace) {{{
" let g:far#source='agnvim'
" let g:far#source='vimgrep'
" let g:far#source='ag'
" let g:far#limit
let g:far#source='rg'
let g:far#collapse_result=1
" }}}
" instant restructured text {{{
let g:instant_rst_browser = "qutebrowser"
let g:instant_rst_additional_dirs=[ "/home/teto/mptcpweb" ]
" }}}
" vim-workspace {{{
" used for autosave
" :CloseHiddenBuffers
" nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_disable_on_args = 1
let g:workspace_autosave_always = 1
let g:workspace_autosave_untrailspaces = 0
let g:workspace_autosave_ignore = ['gitcommit']
" }}}
" Appearance {{{
set background=dark " remember: does not change the background color !
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

" @:NonText
" set highlight
" ~:EndOfBuffer,z:TermCursor,

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
" ultisnips {{{
let g:UltiSnipsSnippetDirectories=[stdpath('config').'/snippets' ]
" }}}
" vim-plug config {{{
let g:plug_shallow=1
" let g:plug_threads
"}}}
" interesting words {{{
"nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
"nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
" let g:terminal_color_0 = "#202020"
" let g:interestingWordsTermColors = ['#202020', '121', '211', '137', '214', '222']
" let g:interestingWordsTermColors = ['#aeee00', '#ff0000', '#0000ff', '#b88823', '#ffa724', '#ff2c4b']

" }}}
" dirvish {{{
let g:dirvish_mode=2
"}}}
" echodoc {{{
" let g:echodoc#enable_at_startup=1
" g:echodoc#type " only for gonvim
"}}}
" nvim-colorizer{{{
lua require 'terminal'.setup()
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
" float-preview {{{
" let g:float_preview#docked = 0
" let g:float_preview#win
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
nnoremap <Leader>o <Cmd>FzfFiles<CR>
nnoremap <Leader>g <Cmd>FzfGitFiles<CR>
nnoremap <Leader>F <Cmd>FzfFiletypes<CR>
nnoremap <Leader>h <Cmd>FzfHistory<CR>
nnoremap <Leader>c <Cmd>FzfCommits<CR>
nnoremap <Leader>C <Cmd>FzfColors<CR>
nnoremap <leader>b <Cmd>FzfBuffers<CR>
nnoremap <leader>m <Cmd>FzfMarks<CR>
nnoremap <leader>l <Cmd>FzfLines<CR>
nnoremap <leader>t <Cmd>FzfTags<CR>
nnoremap <leader>T <Cmd>FzfBTags<CR>


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

" function! GetQfHistory()

"   " let s:res =
"   redir => cout
"   silent chistory
"   redir END
"   let qfs = split(cout, "\n")
"   " TODO set jump to do
"   let current_qf = -1
"   let i = 0
"   for item in qfs
"     if item[0] == ">"
"       current_qf = i
"     endif
"     i = i + 1
"   endfor
"   " map(list[1:], 's:format_mark(v:val)')),
"   return qfs
"   " return extend(list[0:0], map(list[1:], 's:format_mark(v:val)')),
" endfunction

" function! UpdateQfList(res)
"   " TODO compute newer/older count for going to
"   " TODO if
"   echo a:res
"   " get jump id
"   " if ljump < 0
"   "   colder -ljump
"   " else
"   "   cnewer ljump
" endfunction

" TODO be able to fzf lhistory/chistory
" function! FzfChooseQfList()

"   let d = copy(s:opts)
"   let d.source = GetQfHistory()
"   " let d.source = ["test 1", "test 2"]
"   let d.sink = function('UpdateQfList')
"   call fzf#run(d)
" endfunction

function! FzfNeomake()

  let d = copy(s:opts)

  let d.source = get(g:, 'neomake_'.&ft.'_enabled_makers', [])
  " let d.prompt = &ft." makers"
  let d.options = '--prompt "'.&ft.' Makers>"'
  " let d.source = ["test 1", "test 2"]
  let d.sink = function('UpdateQfList')
  call fzf#run(d)
endfunction

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
" fzf-preview {{{
" let g:fzf_preview_layout = 'top split new'
let g:fzf_preview_layout = ''
" Key to toggle fzf window size of normal size and full-screen
let g:fzf_full_preview_toggle_key = '<C-s>'
"}}}
" Csv config {{{
" There is the analyze command as well
let g:csv_autocmd_arrange = 0
" let g:csv_autocmd_arrange_size = 1024*1024

" call InitCSV after changing this value
" :let g:csv_delim=','
" }}}
" unicode.vim {{{
" overrides ga
nmap ga <Plug>(UnicodeGA)
" }}}
" Search parameters {{{
set hlsearch " highlight search terms
set incsearch " show search matches as you type
set ignorecase " ignore case when searching
set smartcase " take case into account if search entry has capitals in it
set wrapscan " prevent from going back to the beginning of the file

set inccommand=nosplit

nnoremap <Leader>/ :set hlsearch! hls?<CR> " toggle search highlighting

" }}}
" limelight {{{
" Color name (:help cterm-colors) or ANSI code
" let g:limelight_conceal_ctermfg = 'gray'
" let g:limelight_conceal_ctermfg = 240

" " Color name (:help gui-colors) or RGB color
" let g:limelight_conceal_guifg = 'DarkGray'
" let g:limelight_conceal_guifg = '#777777'

" " Default: 0.5
" let g:limelight_default_coefficient = 0.7

" " Number of preceding/following paragraphs to include (default: 0)
" let g:limelight_paragraph_span = 1

" " Beginning/end of paragraph
" "   When there's no empty line between the paragraphs
" "   and each paragraph starts with indentation
" let g:limelight_bop = '^\s'
" let g:limelight_eop = '\ze\n^\s'

" " Highlighting priority (default: 10)
" "   Set it to -1 not to overrule hlsearch
" let g:limelight_priority = -1
" goyo.vim integration
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!
" }}}
" inyoface (highlight only comments) {{{
" nnoremap <leader>c <Plug>(InYoFace_Toggle)<CR>
" }}}
" vim-sayonara {{{
nnoremap <silent><leader>Q  <Cmd>Sayonara<cr>
nnoremap <silent><leader>q  <Cmd>Sayonara!<cr>

let g:sayonara_confirm_quit = 0
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
" goyo {{{
let g:goyo_linenr=1
let g:goyo_height= '90%'
let g:goyo_width = 120
" }}}
" Generic Tex configuration {{{
" See :help ft-tex-plugin
let g:tex_flavor = "latex"
"}}}
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
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_format_enabled = 0
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_complete_close_braces = 0
let g:vimtex_fold_comments=0
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
" github-comment {{{
" ,precedes:❮,nbsp:×
let g:github_user = 'teto'
"}}}
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

set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
" set listchars+=conceal:X
" conceal is used by deefault if cchar does not exit
set listchars+=conceal:❯
" }}}
" Grepper {{{

" nnoremap <leader>git :Grepper -tool git -open -nojump
" nnoremap <leader>ag  :Grepper -tool ag  -open -switch
nnoremap <leader>rg  <Cmd>Grepper -tool rg -open -switch<CR>
nnoremap <leader>rgb  <Cmd>Grepper -tool rg -open -switch -buffer<CR>
" TODO add 
vnoremap <leader>rg  <Cmd>Grepper -tool rg -open -switch<CR>

" highlight! link QuickFixLine Normal

" function! OnGrepperCompletion()
"   copen
"   hi link GrepperNormal   StatusLineNC
"   " guibg=lightblue
"   if exists("winhl")
"     setlocal winhl=Normal:GrepperNormal
"   endif
" " call notify#emitNotification('grepper', 'Search finished') |
" endfunction

" autocmd User Grepper call OnGrepperCompletion()

" nmap gs <plug>(GrepperOperator)
" xmap gs <plug>(GrepperOperator)

" }}}
" folding config {{{
" block,hor,mark,percent,quickfix,search,tag,undo
" set foldopen+=all " specifies commands for which folds should open
" set foldclose=all
"set foldtext=
  set fillchars+=foldopen:▾,foldsep:│
  set fillchars+=foldclose:▸
  set fillchars+=msgsep:‾
  hi MsgSeparator ctermbg=black ctermfg=white

  set fdc=auto:2
" }}}
" vim-sneak {{{
let g:sneak#s_next = 1 " can press 's' again to go to next result, like ';'
let g:sneak#prompt = 'Sneak>'

let g:sneak#streak = 0

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" }}}
" Peekaboo config {{{
" Default peekaboo window
let g:peekaboo_window = 'vertical botright 30new'

" Delay opening of peekaboo window (in ms. default: 0)
let g:peekaboo_delay = 0

" Compact display; do not display the names of the register groups
let g:peekaboo_compact = 1
" }}}
" vimplug bindings {{{
nnoremap <leader>pi <Cmd>PlugInstall<CR>
nnoremap <leader>pU <Cmd>PlugUpgrade<CR>
nnoremap <leader>pu <Cmd>PlugUpdate<CR>
" }}}
" signify (display added/removed lines from vcs) {{{
let g:signify_vcs_list = [ 'git']
" let g:signify_mapping_next_hunk = '<leader>hn' " hunk next
" let g:signify_mapping_prev_hunk = '<leader>gk'
" let g:signify_mapping_toggle_highlight = '<leader>gh'
let g:signify_line_highlight = 0 " display added/removed lines in different colors
"let g:signify_line_color_add    = 'DiffAdd'
"let g:signify_line_color_delete = 'DiffDelete'
"let g:signify_line_color_change = 'DiffChange'
" let g:signify_mapping_toggle = '<leader>gt'
" let g:signify_sign_add =  '+'
let g:signify_sign_show_text = 1
"\u00a0  " unbreakable space

" let g:signify_sign_add =  "▎"
let g:signify_sign_add =  "▊"
let g:signify_sign_delete            = g:signify_sign_add
" " let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = g:signify_sign_add
let g:signify_sign_changedelete      = g:signify_sign_change
let g:signify_sign_show_count= 0
" master

 " foire dans le commit suivant
 " \'git': 'git diff --no-color --no-ext-diff -U0 bfb9cf1 -- %f'
" let g:signify_vcs_cmds = {
"       \'git': 'git diff --no-color --no-ext-diff -U0 master -- %f'
"   \}
" git log --format=format:%H $FILE | xargs -L 1 git blame $FILE -L $LINE,$LINE

let g:signify_cursorhold_insert     = 0
let g:signify_cursorhold_normal     = 0
let g:signify_update_on_bufenter    = 1
let g:signify_update_on_focusgained = 1
" hunk jumping
" nmap <leader>wj :call sy#jump#next_hunk(v:count1)<CR>
" nmap <leader>wj <plug>(signify-next-hunk)
" nnoremap <leader>sj :echomsg 'next-hunk'<CR>
" nmap <leader>sk <plug>(signify-prev-hunk)

" }}}
" vim-scripts/QuickFixCurrentNumber {{{
" *:QuickhlManualEnable*		Enable.
" }}}
" Tips from vim-galore {{{

" to alternate between header and source file
" autocmd BufLeave *.{c,cpp} mark C
" autocmd BufLeave *.h       mark H

" Don't lose selection when shifting sidewards
"xnoremap <  <gv
"xnoremap >  >gv
" todo do the same for .Xresources ?
autocmd BufWritePost ~/.Xdefaults call system('xrdb ~/.Xdefaults')

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
" easymotion {{{
" let g:EasyMotion_do_shade = 1
" let g:EasyMotion_do_mapping = 1
" let g:EasyMotion_use_upper = 1 " display upper case letters but let u type lower case
" let g:EasyMotion_inc_highlight = 0
" let g:EasyMotion_disable_two_key_combo = 0

" map , <Plug>(easymotion-prefix)
" Easymotion settings {{{
" nmap s <Plug>(easymotion-s2)
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_verbose = 0
" }}}


" }}}
" quickhl (similar to interesting words) {{{
" nmap <Space>m <Plug>(quickhl-manual-this)
" xmap <Space>m <Plug>(quickhl-manual-this)
" nmap <Space>M <Plug>(quickhl-manual-reset)
" xmap <Space>M <Plug>(quickhl-manual-reset)
" }}}
" vim-halo (to show cursor) {{{
" disabled cause creating pb for now
" nnoremap <silent> <Esc> :<C-U>call halo#run()<CR>
" nnoremap <silent> <C-c> :<C-U>call halo#run()<CR><C-c>
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
command! NvimLintToggle :call VarToggle("g:nvimdev_auto_lint")
        " \ 'remove_invalid_entries': get(g:, 'neomake_remove_invalid_entries', 0),
"}}}
"coquille{{{
" Maps Coquille commands to <F2> (Undo), <F3> (Next), <F4> (ToCursor)
au FileType coq call coquille#FNMapping()
let g:coquille_auto_move=1
" }}}
" miniyank (from bfredl) {{{
let g:miniyank_delete_maxlines=100
let g:miniyank_filename = $XDG_CACHE_HOME."/miniyank.mpack"
" map p <Plug>(miniyank-autoput)
" map P <Plug>(miniyank-autoPut)


function! FZFYankList() abort
  function! KeyValue(key, val)
    let line = join(a:val[0], '\n')
    if (a:val[1] ==# 'V')
      let line = '\n'.line
    endif
    return a:key.' '.line
  endfunction
  return map(miniyank#read(), function('KeyValue'))
endfunction

function! FZFYankHandler(opt, line) abort
  let key = substitute(a:line, ' .*', '', '')
  if !empty(a:line)
    let yanks = miniyank#read()[key]
    call miniyank#drop(yanks, a:opt)
  endif
endfunction

command! YanksAfter call fzf#run(fzf#wrap('YanksAfter', {
\ 'source':  FZFYankList(),
\ 'sink':    function('FZFYankHandler', ['p']),
\ 'options': '--no-sort --prompt="Yanks-p> "',
\ }))

command! YanksBefore call fzf#run(fzf#wrap('YanksBefore', {
\ 'source':  FZFYankList(),
\ 'sink':    function('FZFYankHandler', ['P']),
\ 'options': '--no-sort --prompt="Yanks-P> "',
\ }))

map <A-p> <Cmd>YanksAfter<CR>
map <A-P> <Cmd>YanksBefore<CR>

:
"}}}
" nvim-hs haskell stuff {{{
" let g:nvimhsPluginStarter=nvimhs#stack#pluginstarter()
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
" neosnippet {{{
" let g:neosnippet#enable_completed_snippet = 1
" let g:neosnippet#enable_snipmate_compatibility = 1
" let g:neosnippet#enable_complete_done = 1
" imap <C-k>     <expr><Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <expr><Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)

" inoremap <expr><C-q> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
" inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr><C-o> deoplete#mappings#manual_complete()
" autocmd CompleteDone * call neosnippet#complete_done()
"}}}
" vim-translate-me / vtm {{{
" Which language that the text will be translated
let g:vtm_default_to_lang='en'
let g:vtm_default_api='bing'
" Type <Leader>t to translate the text under the cursor, print in the cmdline
" nmap <silent> <Leader>t <Plug>Translate
" vmap <silent> <Leader>t <Plug>TranslateV
" Type <Leader>w to translate the text under the cursor, display in the popup window
nmap <silent> ,te <Plug>TranslateW
vmap <silent> ,te <Plug>TranslateWV
" Type <Leader>r to translate the text under the cursor and replace the text with the translation
nmap <silent> <Leader>r <Plug>TranslateR
vmap <silent> <Leader>r <Plug>TranslateRV
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
" nvim-palette{{{
let g:palette_debug=1
let g:palette_histadd=1
" overrides default
" let g:palette_descriptions_file='/home/teto/neovim2/build/runtime/data/options.mpack'
" let g:palette_fzf_opts={
" 	\ 'options': ' --prompt "Palette>"',
" 	\ 'down': '50%',
" 	\ }


" nmap <Leader>p :Palette<CR>
nmap <Leader>x <Plug>(PaletteRun)
"}}}
" highlightedyank {{{
let g:highlightedyank_highlight_duration = 1000
" let g:highlightedyank_max_linesr=
" }}}
" tagbar {{{
let g:tagbar_left = 0
let g:tagbar_indent = 1
let g:tagbar_show_linenumbers= 1
" }}}
" vim-open-url {{{
let g:open_url_browser_default="qutebrowser"
"}}}
" qfgrep {{{
" <Leader>g to filter entries (user will be asked for pattern) works only in
" location list/quickfix similar to :QFGrep
" <Leader>r to restore original quickfix entires.
let g:QFG_hi_error = 'ctermbg=167 ctermfg=16 guibg=#d75f5f guifg=black'
"}}}
" location list / quickfix config {{{
" location list can be associated with only one window.
" The location list is independent of the quickfix list.
" }}}
" iron.nvim {{{
" cp = repeat the previous command
" ctr send a chunk of text with motion
" nmap <localleader>t <Plug>(iron-send-motion)
let g:iron_repl_open_cmd="vsplit"
" if TODO only if included
" luafile $HOME/.config/nvim/iron-config.lua
" let g:iron_new_repl_hooks
" let g:iron_new_lua_repl_hooks
"let g:iron_map_defaults
"}}}
" bookmarks.vim {{{
  let g:bookmark_no_default_key_mappings = 1
"}}}
" mardown-preview.nvim {{{
" set to 1, nvim will open the preview window after entering the markdown buffer default: 0
let g:mkdp_auto_start = 0
" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1
    \ }

" use a custom markdown style must be absolute path
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" normal/insert
" <Plug>MarkdownPreview
" <Plug>MarkdownPreviewStop
" <Plug>MarkdownPreviewToggle

" " example
" nmap <C-s> <Plug>MarkdownPreview
" nmap <M-s> <Plug>MarkdownPreviewStop
" nmap <C-p> <Plug>MarkdownPreviewToggle
" Start the preview
" :MarkdownPreview

" " Stop the preview"
" :MarkdownPreviewStop
"}}}
" vista (tagbar-like software) {{{
" Vista finder fzf
" Vista nvim_lsp
" available options are echo/scroll/floating_win/both
let g:vista_echo_cursor_strategy='both'
let g:vista_close_on_jump=0
let g:vista_default_executive='nvim_lsp'

let g:vista_executive_for = {
    \ 'php': 'vim_lsp',
    \ 'markdown': 'toc',
    \ }
let g:vista_highlight_whole_line=1

" Declare the command including the executable and options used to generate ctags output
" for some certain filetypes.The file path will be appened to your custom command.
" For example:
let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -x -o - -c',
      \ }
" let g:vista_finder_alternative_executives=['tags']
" let g:vista_fzf_preview
" let g:vista_blink=[2, 100]
" let g:vista_icon_indent=[ '+', '+' ]
nnoremap <Leader>v <Cmd>Vista<CR>
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
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
" diagnostic builds on nvim's LSP {{{ 
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_show_sign = 1
" happens when PrevDiagnostic
let g:diagnostic_auto_popup_while_jump = 1
" to prevent diagnostics from popping up in insert mode
let g:diagnostic_insert_delay = 1
"}}}
" completion-nvim {{{
let g:completion_docked_hover=1
" let g:completion_enable_auto_popup = 0
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_signature = 1
let g:completion_timer_cycle = 200 "default value is 80
" Configure the completion chains
let g:completion_chain_complete_list = {
    \'default' : {
    \	'default' : [
    \		{'complete_items' : ['lsp', 'snippet']},
    \		{'mode' : 'file'}
    \	],
    \	'comment' : [],
    \	'string' : []
    \	},
    \'vim' : [
    \	{'complete_items': ['snippet']},
    \	{'mode' : 'cmd'}
    \	],
    \'c' : [
    \	{'complete_items': ['lsp'], 'triggered_only': ['.', '::', '->', '_']}
    \	],
    \'python' : [
    \	{'complete_items': ['lsp']}
    \	],
    \'lua' : [
    \	{'complete_items': ['lsp']}
    \	],
    \}

" hello world"
" let g:completion_confirm_key = "\<C-y>"
set completeopt+=menuone  " use pum even for one match
set completeopt+=noinsert,noselect

" Use completion-nvim in every buffer
" autocmd BufEnter * lua require'completion'.on_attach()
" }}}
" treesitter-completion {{{
" Highlight the node at point, its usages and definition when cursor holds
" grammaers are searched in `parser/{lang}.*
" let g:complete_ts_highlight_at_point = 1
" set foldexpr=completion_treesitter#foldexpr()
" set foldmethod=expr
"}}}


set hidden " you can open a new buffer even if current is unsaved (error E37)
" set completeopt+=longest
" draw a line on 80th column
set colorcolumn=80,100

" default behavior for diff=filler,vertical
set diffopt=filler,vertical
set diffopt+=hiddenoff " neovim > change to default ?
set diffopt+=iwhiteall
set diffopt+=internal,algorithm:patience

" Y behave like D or C
nnoremap Y y$


" let undos persist across open/close
let &undodir=stdpath('data').'/undo/'
set undofile


nnoremap <F6> <Cmd>AutoSaveToggle<CR>
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

" Get off my lawn
"noremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

nnoremap <silent> <Leader>B <Cmd>TagbarToggle<CR>
nnoremap <Leader>V <Cmd>Vista finder<CR>

" set vim's cwd to current file's
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

if has('nvim')
	"runtime! python_setup.vim
 " when launching term
	tnoremap <Esc> <C-\><C-n>
endif

" Bye bye ex mode
noremap Q <NOP>

" buffers
map <Leader>n :bnext<CR>
map <Leader>N :bNext<CR>
" map <Leader>p :bprevious<CR>
map <Leader>$ <Cmd>Obsession<CR>
" map <Leader>d :bdelete<CR>

"http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious

map <Leader>lr <Plug>(Luadev-RunLine)

" spell config {{{
" todo better if it could be parsable
" map <Leader>t :!trans :fr -no-ansi <cword><CR>
map <Leader>te :te trans :en <cword><CR>
map <Leader>tf :te trans :fr <cword><CR>
" for thesaurus vim-thesaurus only works with English :/
map <Leader>ttf :te trans :fr <cword><CR>
map <Leader><space> :b#<CR>
"}}}
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

" azerty customizations : utilise <C-V> pour entrer le caractère utilisé {{{
"https://www.reddit.com/r/vim/comments/2tvupe/azerty_keymapping/
" parce que # est l'opposé de * et ù est a coté de *
" map ù %
noremap             <C-j>           }
noremap             <C-k>           {

" }}}
"'.'
"set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada

" added 'n' to defaults to allow wrapping lines to overlap with numbers
" n => ? used for wrapped lines as well
set matchpairs+=<:>  " Characters for which % should work

" TODO to use j/k over
" set whichwrap+=<,>,h,l

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
tmenu Trans.FR Traduire vers le francais

" upstream those to grepper
menu Grepper.Search\ in\ current\ Buffer :Grepper -switch -buffer
menu Grepper.Search\ across\ Buffers :Grepper -switch -buffers
menu Grepper.Search\ across\ directory :Grepper
menu Grepper.Autoopen\ results :let g:grepper.open=1<CR>

" tabulation-related menu {{{2
" menu Search.CurrentBuffer :exe Grepper -grepprg rg --vimgrep $* $.
" menu Search.AllBuffers :exe Grepper -grepprg rg --vimgrep $* $+
" }}}
" tabulation-related menu {{{2
menu Tabs.S2 :set  tabstop=2 softtabstop=2 sw=2<CR>
menu Tabs.S4 :set ts=4 sts=4 sw=4<CR>
menu Tabs.S6 :set ts=6 sts=6 sw=6<CR>
menu Tabs.S8 :set ts=8 sts=8 sw=8<CR>
menu Tabs.SwitchExpandTabs :set expandtab!
"}}}
" }}}
" nvim specific configuration {{{

if has("nvim")
  " should work with vim also but need a very new vim
  set termguicolors
  "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
  let g:netrw_home=$XDG_DATA_HOME.'/nvim'
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
" echo -e "\e[9mstrikethrough\e[0m" works in termite (libvte)
" regarder dans 'guifont' y a s=strikeout
autocmd ColorScheme *
      \ highlight Comment gui=italic
      \ | highlight Search gui=undercurl
      \ | highlight MatchParen guibg=NONE guifg=NONE gui=underline
      \ | highlight NeomakePerso cterm=underline ctermbg=Red  ctermfg=227  gui=underline
" guibg=Red
      " \ | highlight IncSearch guibg=NONE guifg=NONE gui=underline
" highlight Comment gui=italic

" put it after teh auguibg=redtocms ColorScheme
colorscheme molokai
" colorscheme gruvbox
" set bg=light

" }}}

" set guicursor="n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor"
set guicursor=n-v-c:block-blinkon250-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-blinkon250-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
" set guicursor=i:ver3,n:block-blinkon10-Cursor,r:hor50
" try reverse ?
highl Cursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
" highl lCursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227 guibg=NONE guifg=#F08A1F
highlight SignifySignAdd cterm=bold ctermbg=237  ctermfg=227 guibg=NONE guifg=green
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=227 guibg=NONE guifg=red

" TESTING only
nnoremap <kPageUp> :lprev
nnoremap <kPageDown> :lnext
nnoremap <kPageRight> :lnext
nnoremap <kPageRight> :lnext
nnoremap <k2> :echom "hello world"
nnoremap gO i<CR>
" overwrite vimtex status mapping
" let @g="dawi\\gls{p}"
" nnoremap <Leader>lg @g

" testing my PR
set signcolumn=auto:3

function! FzfFlipBool()
  " let l:dict = {}

  " 'source':
  let l:dict = {
    \ 'sink': 'echo'
    \ }
  call fzf#run(l:dict)
endfunc
command! FlipBool call FzfFlipBool()

"
" to open tag in a split
map <A-]> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>


" MATT to test
let g:python_host_tcp=1

function! ExportMenus(path, modes)
	" export all for now
	let m = menu_get(a:path, a:modes)
	let r =  json_encode(m)
	" put =r " to display in current buffer
	call writefile([r], "menus.txt")
endfunc


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
call remote#host#Register('haskell', "*.l\?hs", function('s:RequireHaskellHost'))

" But if you need it for other files as well, you may just start it
" forcefully by requiring it
let hc=remote#host#Require('haskell')

" printer configuration
" set printexpr


set shiftround    " round indent to multiple of 'shiftwidth'

" window-local
set winhl=NormalNC:CursorColumn

" auto reload vim config on save
" Watch for changes to vimrc
augroup myvimrc
  au!
  au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" augroup onnewsocket
"   au!
"   autocmd! OnNewSocket * echom 'New client from init'
" augroup END

" open vimrc
nnoremap <Leader>ev <Cmd>e $MYVIMRC<CR>
" reload vimrc
nnoremap <Leader>sv <Cmd>source $MYVIMRC<CR>

" open netrw/dirvish split
" nnoremap <Leader>e :Vex<CR>
nnoremap <Leader>w :w<CR>

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

nnoremap <S-CR> i<CR><Esc>

hi CursorLine                    guibg=#293739 guifg=None
" hi CocErrorFloat

" au BufWinLeave,BufLeave * if &buftype != 'nofile' | silent! mkview | endif
" au BufWinEnter * if &buftype != 'nofile' | silent! loadview | endif



" highlight NormalFloat cterm=NONE ctermfg=14 ctermbg=0 gui=NONE guifg=#93a1a1 guibg=#002931

" taken from justinmk's config
command! Tags !ctags -R --exclude='build*' --exclude='.vim-src/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *


function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
    " let g:res = luaeval('vim.lsp.buf.hover()')
    " if g:res == v:false && &ft == "haskell"
		" execute '!hoogle '.expand('<cword>')
	" endif
  endif
endfunction

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

" lsp config {{{
" nnoremap <buffer> <silent> <leader>ngd :call lsp#text_document_declaration()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> K  <cmd>Show_documentation()<CR>
nnoremap ,gi  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap ,sh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> ,td <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> ,af <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> ,arf <cmd>lua vim.lsp.buf.range_formatting()<CR>

nnoremap ,ga vim.lsp.buf.code_action()<CR>

" nnoremap <silent> <leader>do :OpenDiagnostic<CR>
nnoremap <leader>dl <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

" vim.lsp.buf.rename()

" when upstreamed
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gA    <cmd>lua vim.lsp.buf.code_action()<CR>

" nnoremap <buffer> <silent> <leader>d :lua require("vim.lsp.util").show_line_diagnostics()<CR>

" lua require 'init.lua'
" Doesn't seem to work
" luafile stdpath('config').'/init.lua'
" vim.fn.stdpath('config')
luafile ~/.config/nvim/init.lua
" logs are written to /home/teto/.local/share/nvim/vim-lsp.log
lua vim.lsp.set_log_level("debug")

" this is set per-buffer so...
" call LSP_maps()

" nnoremap [[ <Cmd>labove<CR>
" nnoremap ]] <Cmd>lbelow<CR>

nmap [[ <Cmd>PrevDiagnostic<cr>
nmap ]] <Cmd>NextDiagnostic<cr>

" set omnifunc=lsp#omnifunc
  " autocmd Filetype rust,python,go,c,cpp setl omnifunc=v:lua.vim.lsp.omnifunc

set omnifunc=v:lua.vim.lsp.omnifunc


autocmd CursorHold lua vim.lsp.util.show_line_diagnostics()
autocmd CursorMoved lua vim.lsp.util.show_line_diagnostics()

" https://github.com/neovim/neovim/pull/11638
" autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
" autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
" autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()


" to test kitty undercurl
hi LspDiagnosticsUnderline cterm=underline gui=undercurl

" ✘'
let g:LspDiagnosticsErrorSign = 'T'
let g:LspDiagnosticsWarningSign = 'R'
let g:LspDiagnosticsInformationSign = 'I'
let g:LspDiagnosticsHintSign = 'H'

" function! LspStatus() abort
"     let sl = ''
"     if luaeval('vim.lsp.buf.server_ready()')
"         let sl.='%#MyStatuslineLSP#E:'
"         let sl.='%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Error\")")}'
"         let sl.='%#MyStatuslineLSP# W:'
"         let sl.='%#MyStatuslineLSPWarnings#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Warning\")")}'
"     else
"         let sl.='%#MyStatuslineLSPErrors#off'
"     endif
"     return sl
" endfunction

" let &l:statusline = '%#MyStatuslineLSP#LSP '.LspStatus() 

" vim.lsp.util.set_qflist
" location_callback
" }}}

" treesitter config {{{
" lua vim.treesitter.add_language("/home/teto/tree-sitter-c/build/Release/tree_sitter_c_binding.node", "c")
" nix-build -A tree-sitter.builtGrammars.c
"}}}
"{{{sessionoptions
set sessionoptions-=terminal
set sessionoptions-=help
"}}}


" Creates a :Watch <filename>
" command ?
" luafile ~/.config/nvim/watch_fs.lua

" nvim__buf_set_watcher
" let g:watcher = { }

" v:lua.vim.fswatch.watch_file()
" let g:watcher.watch = v:lua.vim.fswatch.watch_file
" let g:watcher.stop = v:lua.vim.fswatch.stop

" disable [1/5]
" set shortmess+=S


" nnoremap ' `

" keep selection when shifting
" xnoremap > >gv
" xnoremap < <gv

command! LspStopAllClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())

" set working directory to the current buffer's directory
nnoremap cd :lcd %:p:h<bar>pwd<cr>
nnoremap cu :lcd ..<bar>pwd<cr>

"linewise partial staging in visual-mode.
xnoremap <c-p> :diffput<cr>
xnoremap <c-o> :diffget<cr>
" nnoremap <expr> dp &diff ? 'dp' : ':Printf<cr>'

" command! ProfileVim     exe 'Start '.v:progpath.' --startuptime "'.expand("~/vimprofile.txt").'" -c "e ~/vimprofile.txt"'
" command! NvimTestScreenshot put =\"local Screen = require('test.functional.ui.screen')\nlocal screen = Screen.new()\nscreen:attach()\nscreen:snapshot_util({},true)\"

" quickui {{{
" https://github.com/skywind3000/vim-quickui
let g:quickui_border_style = 1
let content = [
            \ ["&Help Keyword\t\\ch", 'echo 100' ],
            \ ["&Signature\t\\cs", 'echo 101'],
            \ ['-'],
            \ ["Find in &File\t\\cx", 'echo 200' ],
            \ ["Find in &Project\t\\cp", 'echo 300' ],
            \ ["Find in &Defintion\t\\cd", 'echo 400' ],
            \ ["Search &References\t\\cr", '<cmd>lua vim.lsp.buf.references()<CR>'],
            \ ['-'],
            \ ["&Documentation\t\\cm", 'echo 600'],
            \ ]
" set cursor to the last position
let quick_opts = {'index':g:quickui#context#cursor}

map <RightMouse>  <Cmd>call quickui#context#open(content, quick_opts)<CR>

" call quickui#context#open(content, opts)
" }}}
