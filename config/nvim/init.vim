" vim: set noet fenc=utf-8 ff=unix sts=0 sw=2 ts=8 fdm=marker :
" to debug vimscript, use :mess to display error messages
" :scriptnames to list loaded scripts
" and prefix you command with 'verbose' is a very good way to get info
" like ':verbose map J' to know where it was loaded last
" map <C-D> <C-]>"{{{"{{{"{{{
" map <C-D> :tag<CR>"}}}
map <D-b> :echom "hello papy"

"$NVIM_PYTHON_LOG_FILE
" to test startup time"}}}
" nvim --startuptime startup.log
" nvim -u NONE --startuptime startup.log
"}}}
" to see the difference highlights,
" runtime syntax/hitest.vim

" vim-plug autoinstallation {{{
" TODO move to XDG_DATA_HOME
" let s:nvimdir = (exists("$XDG_CONFIG_HOME") ? $XDG_CONFIG_HOME : $HOME.'/.config').'/nvim'
" appended site to be able to use packadd (since it is in packpath)
let s:nvimdir = (exists("$XDG_DATA_HOME") ? $XDG_DATA_HOME : $HOME.'/.local/share').'/nvim'
let s:plugscript = s:nvimdir.'/autoload/plug.vim'
let s:plugdir = s:nvimdir.'/site/pack'

"silent echom s:plugscript
"silent echom s:nvimdir
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
" Read-only pdf through pdftotext
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
" }}}
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
" filnxtToO
set shortmess+=I
set cmdheight=2 " for echodoc

" inverts the meaning of g in substitution, ie with gdefault, change all
" occurences
set gdefault
" lustyjuggler plugin
" https://github.com/sjbach/lusty

" nvim will load any .nvimrc in the cwd; useful for per-project settings
set exrc

" vim-plug plugin declarations {{{1
call plug#begin(s:plugdir)
" branch v2-integration
" Plug 'joonty/vdebug' " to add breakpoints etc
" Plug 'andymass/vim-matchup' " to replace matchit
Plug 'mhinz/vim-signify' " Indicate changed lines within a file using a VCS.
" Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'moznion/github-commit-comment.vim' " last update from 2014
" Plug 'dhruvasagar/vim-open-url' " gB/gW to open browser
Plug 'Carpetsmoker/xdg_open.vim' " overrides gx
Plug 'tweekmonster/nvim-api-viewer', {'on': 'NvimAPI'} " see nvim api
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'} " see startup time per script
" Plug 'jamessan/vim-gnupg'
" Plug 'mattn/gist-vim' " to gist requires webapi
" provider dependant {{{
" new deoplete relies on yarp :
Plug 'AndrewRadev/splitjoin.vim' " gS/gJ to 
Plug 'Shougo/deoplete.nvim' ", { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-yarp' " required for deoplete
Plug 'roxma/vim-hug-neovim-rpc'
" Plug '~/vim-config'
Plug '~/nvim-palette', { 'do': ':UpdateRemotePlugins' }
Plug 'LnL7/vim-nix', {'for': 'nix'}
" Plug 'romainl/vim-qf' " can create pb with neomake
" Plug 'gelguy/Cmd2.vim' " test
Plug 'editorconfig/editorconfig-vim' " not remote but involves python
" provider
Plug 'brooth/far.vim', { 'on': 'Far','do': ':UpdateRemotePlugins' } " search and replace across files
" needs ruby support, works in recent neovim
Plug 'junegunn/vim-github-dashboard', { 'do': ':UpdateRemotePlugins' }
Plug 'fmoralesc/vim-pad', {'branch': 'devel'} " :Pad new, note taking
"}}}
" to test https://github.com/neovim/neovim/issues/3688
" Plug 'haya14busa/incsearch.vim' " just to test
" while waiting for my neovim notification provider...
Plug 'tjdevries/descriptive_maps.vim', {'do': ':UpdateRemotePlugins' } " :call DescriptiveStart()
Plug 'gianarb/notify.vim' " call notify#emitNotification('Title', 'Body')
" Plug 'vim-scripts/coq-syntax', {'for': 'coq'}
" Plug 'the-lambda-church/coquille', {'branch': 'matt', 'for': 'coq'}
" Plug 'teto/coquille', {'branch': 'matt', 'for': 'coq'}
Plug 'let-def/vimbufsync', {'for': 'coq'} " for coq
" Plug 'vim-scripts/ProportionalResize'
" Plug 'inside/vim-search-pulse' " Search related

" vim-search-pulse {{{
let g:vim_search_pulse_mode = 'cursor_line'
let g:vim_search_pulse_duration = 400
"}}}

" Plug 'kassio/neoterm' " some kind of REPL
" Plug 'ehamberg/vim-cute-python' " display unicode characters, kinda looks bad on vim grid
Plug 'dbakker/vim-projectroot' " projectroot#guess()
" Plug 'sunaku/vim-dasht' " get documentation (zeavim is also a contender KabbAmine/zeavim.vim)
" Plug 'git@github.com:reedes/vim-wordy.git' " pdt la these, pr trouver la jargon :Wordy
" Plug 'sk1418/QFGrep' " Filter quickfix
" Plug 'git@github.com:pseewald/vim-anyfold.git' " speed up folds processing
" (upstreamd already or ?)
" Plug 'mtth/scratch.vim' " , {'on': 'Scratch'} mapped to ?
" Plug 'tjdevries/vim-inyoface.git' "InYoFace_toggle to display only comments
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' } " :h LanguageClientUsage
" Plug 'tjdevries/nvim-langserver-shim' " for LSP
" Plug 'powerman/vim-plugin-AnsiEsc' " { to hl ESC codes
" Plug 'git@github.com:junegunn/gv.vim.git' " git commit viewer :Gv
" Plug 'git@github.com:xolox/vim-easytags.git' "
" Plug 'mhinz/vim-halo' " to hight cursor line
Plug 'ludovicchabant/vim-gutentags' " automatic tag generation, very good
Plug 'junegunn/goyo.vim', {'on': 'Goyo'} "distraction free writing
Plug 'junegunn/limelight.vim' " highlights
Plug 'calvinchengx/vim-aftercolors' " load after/colors
"Plug 'junegunn/limelight.vim' " to highlight ucrrent paragraph only
" Plug 'ntpeters/vim-better-whitespace' " StripWhitespace care it stole my
" leader
" Plug 'bronson/vim-trailing-whitespace' " :FixTrailingWhitespace
" Plug 'tkhoa2711/vim-togglenumber' " by default mapped to <leader>n
" Plug 'blindFS/vim-translator' " fails during launch :/
" Plug 'timeyyy/orchestra.nvim' " to play some music on
" Plug 'timeyyy/clackclack.symphony' " data to play with orchestra.vim
Plug 'tpope/vim-scriptease' " Adds command such as :Messages
" Plug 'tpope/vim-eunuch' " {provides SudoEdit, SudoWrite , Unlink, Rename etc...

" REPL (Read Execute Present Loop) {{{
Plug 'metakirby5/codi.vim', {'on': 'Codi'} " repl
Plug 'hkupty/iron.nvim', {'do': ':UpdateRemotePlugins'}
" Plug 'jalvesaq/vimcmdline' " no help files, mappings clunky
" github mirror of Plug 'http://gitlab.com/HiPhish/repl.nvim'
" Plug 'HiPhish/repl.nvim'
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
" Plug 'git@github.com:SirVer/ultisnips' " handle snippets
" Snippets are separated from the engine. Add this if you want them:
" Plug 'honza/vim-snippets' "  ultisnips compatible snippets
Plug 'sjl/gundo.vim' " :GundoShow/Toggle to redo changes
" Plug 'vim-scripts/DrawIt' " to draw diagrams
" Plug 'Yggdroot/indentLine',{ 'for': 'python' }  " draw verticals indents but seems greedy
"  Autocompletion and linting {{{2
"'frozen': 1,
" Plug 'lyuts/vim-rtags'  " a l'air d'etre le plus complet <leader>ri
"
" }}}
" Plug 'beloglazov/vim-online-thesaurus' " thesaurus => dico dde synonymes
" Plug 'mattboehm/vim-unstack'  " to see a
" Plug 'KabbAmine/vCoolor.vim', { 'on': 'VCooler' } " RGBA color picker
" Plug 'arakashic/chromatica.nvim', { 'for': 'cpp' } " semantic color syntax


" to configure vim for haskell, refer to
" http://yannesposito.com/Scratch/en/blog/Vim-as-IDE/
"{{{
Plug 'neovimhaskell/haskell-vim', {'for':'haskell'} " haskell install
" Plug 'enomsg/vim-haskellConcealPlus', {'for':'haskell'}     " unicode for haskell operators
" Plug 'eagletmt/ghcmod-vim', {'do': 'cabal install ghc-mod', 'for': 'haskell'} " requires
Plug 'parsonsmatt/intero-neovim' " replaces ghcmod
" Plug 'bitc/vim-hdevtools'
" Plug 'eagletmt/neco-ghc', {'for': 'haskell'} " completion plugin for haskell + deoplete ?
" Plug 'Shougo/vimproc.vim', {'do' : 'make'} " needed by neco-ghc
" Plug 'SevereOverfl0w/deoplete-github' " completion on commit issues (just
" crashes without netrc
Plug 'zchee/deoplete-zsh'
Plug 'fszymanski/deoplete-abook'
" Plug 'Twinside/vim-hoogle' , {'for':'haskell'}
"}}}

"Plug 'mattn/vim-rtags' a l'air léger
" Plug 'shaneharper/vim-rtags' " <leader>r ou bien :RtagsFind  mais ne marche pas
Plug 'tpope/vim-unimpaired' " [<space> [e [n ]n pour gerer les conflits etc...
Plug 'kana/vim-operator-user' " dependancy for operator-flashy
" better handling of buffer closure (type :sayonara)
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" Using a non-master branch

" Plug 'dbgx/lldb.nvim',{ 'for': 'c' } " To debug (use clang to get correct line numbers
" Plug 'dbgx/gdb.nvim',{ 'for': 'c' } " To debug (use clang to get correct line numbers
" Plug 'powerman/vim-plugin-viewdoc' " looks interesting

" filetypes {{{2
Plug 'cespare/vim-toml', { 'for': 'toml'}
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'dzeban/vim-log-syntax' " hl some keywords like ERROR/DEBUG/WARNING
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
Plug 'tpope/vim-obsession' ", {'on': 'Obsession', 'ObsessionStatus'}  very cool, register edited files in a Session.vim, call with :Obsession
Plug 'mbbill/undotree' " replaces gundo
" Plug '907th/vim-auto-save' " :h auto-save
Plug '907th/vim-auto-save' " autosave :h auto-save
" Plug 'teto/vim-auto-save' " autosave :h auto-save
Plug 'bfredl/nvim-miniyank' " killring alike plugin, cycling paste careful
" hangs with big strings

" Text objects {{{
Plug 'michaeljsmith/vim-indent-object'
Plug 'tommcdo/vim-lion' " Use with gl/L<text object><character to align to>
Plug 'tommcdo/vim-exchange' " Use with cx<text object> to cut, cxx to exchange
Plug 'tommcdo/vim-kangaroo' "  zp to push/zP to pop the position
" Plug 'tommcdo/vim-ninja-feet' " care overwrites z]
" }}}
" {{{ To ease movements
" Plug 'rhysd/clever-f.vim'
"Plug 'unblevable/quick-scope'  " highlight characeters to help in f/F moves
" Plug 'Lokaltog/vim-easymotion' " careful overrides <leader><leader> mappings
"Plug 'wellle/visual-split.vim'
Plug 'wellle/targets.vim' " Adds new motion targets ci{
" Plug 'justinmk/vim-ipmotion' " ?
Plug 'justinmk/vim-sneak' " remaps 's'
Plug 'tpope/vim-rsi'  " maps readline bindings
" }}}

Plug 'mhinz/vim-startify' " very popular, vim's homepage
Plug 'dietsche/vim-lastplace' " restore last cursor postion (is it still needed ?)
" vim-lastplace to restore cursor position {{{
let g:lastplace_ignore = "gitcommit,svn"
" }}}
" Powerline does not work in neovim hence use vim-airline instead
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' " creates problems if not here
"
" Text objects {{{
" Plug 'kana/vim-textobj-fold' " ability to do yaz
" }}}

"
Plug 'justinmk/vim-dirvish' " replaces netrw
Plug 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
Plug 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting
Plug 'tpope/vim-commentary' "gcc to comment/gcgc does not work that well
Plug 'teto/vim-listchars' " to cycle between different list/listchars configurations
"Plug 'vim-voom/VOoM' " can show tex/restDown Table of Content (ToC)
Plug 'blueyed/vim-diminactive' " disable syntax coloring on inactive splits
"Plug 'tpope/vim-sleuth' " Dunno what it is
"Plug 'justinmk/vim-gtfo' " ?
Plug 'tpope/vim-fugitive' " to use with Git, VERY powerful
Plug 'tpope/vim-rhubarb' " github support in fugitive, use |i_CTRL-X_CTRL-O|
"Plug 'jaxbot/github-issues.vim' " works only with vim
"Plug 'tpope/vim-surround' " don't realy know how to use yet
"Plug 'junegunn/vim-peekaboo' " gives a preview of buffers when pasting
Plug 'mhinz/vim-randomtag', { 'on': 'Random' } " Adds a :Random function that launches help at random
Plug 'majutsushi/tagbar' " , {'on': 'TagbarToggle'} disabled lazyloading else it would not work with statusline
Plug 'machakann/vim-highlightedyank' " highlit
" Plug 'haya14busa/vim-operator-flashy' " Flash selection on copy


"  fuzzers {{{2
" Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': './install --completion --key-bindings --64' }
" let distribution (like nixos install fzf
" this package only ocntains fzf#run,
Plug 'junegunn/fzf', " { 'dir': $XDG_DATA_HOME . '/fzf', 'do': ':term ./install --no-update-rc --bin --64'}

" Many options available :
" https://github.com/junegunn/fzf.vim
" Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new tab, a new split, or in a new vertical split
Plug 'junegunn/fzf.vim' " defines :Files / :Commits for FZF

"}}}



" , { 'for': 'markdown', 'do': function('BuildComposer') } " Needs rust, cargo, plenty of things :help markdown-composer
Plug 'euclio/vim-markdown-composer'
Plug 'Rykka/riv.vim', {'for': 'rst'}
Plug 'Rykka/InstantRst', {'for': 'rst'} " rst live preview with :InstantRst,
"Plug 'junegunn/vim-easy-align'   " to align '=' on multiple lines for instance
Plug 'dhruvasagar/vim-table-mode', {'for': 'txt'}

Plug 'kshenoy/vim-signature' " display marks in gutter, love it

" forked it to solve a bug: git@github.com:teto/QuickFixCurrentNumber.git
" Plug '~/QuickFixCurrentNumber' " use :Cnr :Cgo instead of :cnext etc...
" Plug 'Coacher/QuickFixCurrentNumber' " use :Cnr :Cgo instead of :cnext etc...
" =======
" display signature in cmdline after v:completed_item, needs to customize
" cmdheight
Plug 'Shougo/echodoc.vim'
Plug 'teto/QuickFixCurrentNumber' " use :Cnr :Cgo instead of :cnext etc...
Plug 'vim-scripts/ingo-library' " DEPENDANCY of QuickFixCurrentNumber
"Plug 'tomtom/quickfixsigns_vim'
Plug 'nacitar/a.vim' " :A
Plug 'mhinz/vim-rfc', { 'on': 'RFC' } " requires nokigiri gem
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' } " optional syntax highlighting for RFC files
" can show a list of unicode characeters, with their name  :UnicodeTable etc...
" careful maps F4 by default
Plug 'chrisbra/unicode.vim' " , { 'on': ['<plug>(UnicodeComplete)', '<plug>(UnicodeGA)', 'UnicodeTable'] }
Plug 'teto/Modeliner' " <leader>ml to setup buffer modeline
" This one has bindings mapped to <leader>l
"Plug 'vimwiki/vimwiki'   " to write notes
"Plug 'vim-scripts/DynamicSigns'
" async grep neovim only
Plug 'mhinz/vim-grepper' " , { 'on': 'Grepper'}
" Plug 'ddrscott/vim-side-search'  " tOdo
"Plug 'teto/neovim-auto-autoread' " works only in neovim, runs external checker
Plug 'neomake/neomake' " async build for neovim
" Plug 'rhysd/github-complete.vim' " provides github user/repo autocompletion after @ and #
" Plug 'rhysd/vim-clang-format' " C/CPP/C++ development
" VCS related {{{
" Plug 'rhysd/committia.vim' " ne marche pas en rebase ?
" }}}
" Plug 'teddywing/auditory.vim' " play sounds as you type

" does not work seems to be better ones
Plug 'vasconcelloslf/vim-interestingwords' " highlight the words you choose <leader>k (does not work in neovim)
" Plug 't9md/vim-quickhl' " hl manually selected words :h QuickhlManualEnable

" colorschemes {{{
Plug 'whatyouhide/vim-gotham'
Plug 'sickill/vim-monokai'
Plug 'justinmk/molokai'
Plug 'mhinz/vim-janah'
Plug 'vim-scripts/Solarized'
Plug 'morhetz/gruvbox'
Plug 'romainl/flattened'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
" }}}

" Had to disable this one, needs a vim with lua compiled
" and it's not possible in neovim yet
" color_coded requires vim to be compiled with -lua
"Plug 'jeaye/color_coded'
" Plug 'bbchung/clighter'
" YCM generator is not really a plugin is it ?
" Plug 'erezsh/erezvim' "zenburn scheme. This plugin resets some keymaps,
" annoying
" Plug 'chrisbra/csv.vim', {'for': 'csv'}

" editorconfig {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_max_line_indicator = "line"
" let g:EditorConfig_verbose = 1
" }}}
" Plug 'junegunn/rainbow_parentheses.vim' " the recommanded one
" {{{ Latex attempts
" this one could not compile my program
" "Plug 'vim-latex/vim-latex', {'for': 'tex'}
" " ATP author gh mirror seems to be git@github.com:coot/atp_vim.git
" "Plug 'coot/atp_vim', {'for': 'tex'}
Plug 'lervag/vimtex', {'for': 'tex'} " so far the best one
" to autocomplete citations we use vim-ycm-latex-semantic-completer
" }}}

" Plug 'vim-scripts/YankRing.vim' " breaks in neovim, overrides yy as well
" far config (Find And Replace) {{{
" let g:far#source='agnvim'
" let g:far#source='vimgrep'
" let g:far#source='ag'
" let g:far#limit
let g:far#collapse_result=1
" }}}

Plug 'gregsexton/gitv'
Plug 'tweekmonster/nvimdev.nvim' " thanks tweekmonster !
call plug#end()
" }}}

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
map <C-N><C-N> :set invnumber<CR>

" Display unprintable characters with '^' and
" set nolist to disable or set list!

" set timeoutlen=400 " Quick timeouts on key combinations.

" in order to scroll faster
" nnoremap <C-e> 3<C-e>
" nnoremap <C-y> 3<C-y>

" to load plugins in ftplugin matching ftdetect
filetype plugin on
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
" Modeliner shortcuts  {{{
set modeline
set modelines=4 "number of lines checked
nmap <leader>ml :Modeliner<Enter>
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
" {{{ Markdown composer
" Run with :ComposerStart
" let g:markdown_composer_open_browser        = "qutebrowser"
let g:markdown_composer_autostart           = 0
" }}}
"set winheight=30
"set winminheight=5
" instant restructured text {{{
let g:instant_rst_browser = "qutebrowser"
let g:instant_rst_additional_dirs=[ "/home/teto/mptcpweb" ]
" }}}
" Appearance {{{
set background=dark " remember: does not change the background color !
" set fillchars=vert:│,fold:>,stl:\ ,stlnc:\ ,diff:-
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
if has ("signcolumn")
  set signcolumn=auto " display signcolumn depending on
endif

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
" g:UltiSnipsSnippetsDir
" <FocusLost><FocusLost>
let g:UltiSnipsExpandTrigger = "<C-y>"
" " inoremap <expr> <CR> pumvisible() ? "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"


" " let g:endwise_no_mappings = 1
" " inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR>"

" " let g:UltiSnipsExpandTrigger="<Tab>"
" let g:UltiSnipsJumpForwardTrigger="<C-l>"
" let g:UltiSnipsJumpBackwardTrigger="<C-h>"
" " let g:UltiSnipsListSnippets = '<c-tab>'
"    " g:UltiSnipsJumpForwardTrigger          <c-j>
"    " g:UltiSnipsJumpBackwardTrigger         <c-k>
" let g:UltiSnipsUsePythonVersion = 3
" http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme/18685821#18685821
" function! g:UltiSnips_Complete()
"     call UltiSnips#ExpandSnippet()
"     if g:ulti_expand_res == 0
"         if pumvisible()
"             return "\<C-n>"
"         else
"             call UltiSnips#JumpForwards()
"             if g:ulti_jump_forwards_res == 0
"                return "\<TAB>"
"             endif
"         endif
"     endif
"     return ""
" endfunction

" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsListSnippets="<c-e>"
" " this mapping Enter key to <C-y> to chose the current highlight item
" " and close the selection list, same as other IDEs.
" " CONFLICT with some plugins like tpope/Endwise
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
let g:echodoc#enable_at_startup=1
" g:echodoc#type " only for gonvim
"}}}

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

" augroup onnewsocket
"   au!
"   autocmd! OnNewSocket * echom 'New client from init'
" augroup END

" open vimrc
nnoremap <Leader>ev :e $MYVIMRC<CR>
"nnoremap <Leader>ep :vs ~/.vim/plug.vim<CR>
" reload vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>

" open netrw/dirvish split
" nnoremap <Leader>e :Vex<CR>
nnoremap <Leader>w :w<CR>


" fails with neovim use :te instead ?
"nnoremap <leader>r :<C-U>RangerChooser<CR>

"nnoremap <F8> :vertical wincmd f<CR> " open file under cursor in a split
nnoremap <leader>gfs :vertical wincmd f<CR> " open file under cursor in a split
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
let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
                               \ {'type': 'ruby', 'file': 'Gemfile'},
                               \ {'type': 'haskell', 'file': 'Setup.hs'} ]
let g:gutentags_ctags_executable_haskell = 'hasktags'
let g:gutentags_ctags_exclude = ['.vim-src', 'build', '.mypy_cache']
" }}}
" start haskell host if required  {{{
if has('nvim')
  function! s:RequireHaskellHost(name)
      " It is important that the current working directory (cwd) is where
      " your configuration files are.
      " 'nix-shell', '-p',
      return jobstart([ 'stack', 'exec', 'nvim-hs', a:name.name], {'rpc': v:true, 'cwd': expand('$HOME') . '/.config/nvim'})
    " return jobstart("nvim-hs", ['-l','/home/teto/nvim-haskell.log','-v','DEBUG',a:name.name])
  endfunction

  call remote#host#Register('haskell', "*.l\?hs", function('s:RequireHaskellHost'))
  " let hc=remote#host#Require('haskell')
" " echo rpcrequest(hc, "PingNvimhs") should print Pong
endif
"}}}
" hdevtools {{{
" let g:hdevtools_options = '-g-isrc -g-Wall'
"}}}
" Chromatica (needs libclang > 3.9) {{{
" can compile_commands.json or a .clang file
" let g:chomatica#respnsive_mode=1
" let g:chromatica#libclang_path='/usr/local/opt/llvm/lib'
let g:chromatica#libclang_path="/usr/lib/llvm-3.8/lib/"
let g:chromatica#enable_at_startup=0
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
nnoremap <leader>l :FzfLines<CR>
nnoremap <leader>t :FzfTags<CR>
nnoremap <leader>T :FzfBTags<CR>


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
function! UpdateSignifyBranch(branch)
  " echom 'chosen branch='.a:branch
  let g:signify_vcs_cmds = {
	\'git': 'git diff --no-color --no-ext-diff -U0 '.a:branch.' -- %f'
    \}

endfunc

function! FzfChooseSignifyGitCommit()

  let dict = copy(s:opts)
  let dict.sink = funcref('UpdateSignifyBranch')
  call fzf#run(dict)
endfunction

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

function! NeomakeToggleMaker(maker_name)
  " set(g:, 'neomake_'.&ft.'_enabled_makers', [])

  "   :call filter(list, 'v:val !~ "x"')  " remove items with an 'x'

endfunction

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

let g:fzf_history_dir = $XDG_CACHE_HOME.'/fzf-history'
" Advanced customization using autoload functions
"autocmd VimEnter * command! Colors
  "\ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})
" Advanced customization using autoload functions

  " [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

imap <c-x><c-f> <plug>(fzf-complete-path)

"

" }}}
" terminal related {{{
" automatic close when htting escape
autocmd! FileType fzf tnoremap <buffer> <Esc> <c-g>
" }}}
" Powerline config {{{
let g:Powerline_symbols = "fancy" " to use unicode symbols
" }}}
" Csv config {{{
" you can use :CsvVertFold to hide commands
" There is the analyze command as well
    let g:csv_autocmd_arrange = 1
    let g:csv_autocmd_arrange_size = 1024*1024
" }}}
" unicode.vim {{{
" overrides ga
nmap ga <Plug>(UnicodeGA)
" }}}
" Search parameters {{{
set hlsearch " highlight search terms
set incsearch " show search matches as you type
set noignorecase " ignore case when searching
set smartcase " take case into account if search entry has capitals in it
set wrapscan " prevent from going back to the beginning of the file

if has("nvim-0.2.0")
  set inccommand=nosplit
endif

nnoremap <Leader>/ :set hlsearch! hls?<CR> " toggle search highlighting

" }}}
" YouCompleteMe config {{{
let g:ycm_global_ycm_extra_conf = $XDG_CONFIG_HOME."/nvim/ycm_extra_conf.py"
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
let g:ycm_server_keep_logfiles = 1
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_server_python_interpreter =  '/usr/bin/python3'
" Add triggers to ycm for LaTeX-Box autocompletion
let g:ycm_semantic_triggers = {
      \ 'mail' : ['@'],
      \ }

let g:ycm_use_ultisnips_completer = 1 " YCM shows snippets
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion = 1

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <F6> :YcmDebugInfo<CR>

"You may also want to map the subcommands to something less verbose; for instance, nnoremap <leader>jd :YcmCompleter GoTo<CR> maps the <leader>jd sequence to the longer subcommand invocation.

"The various GoTo* subcommands add entries to Vim's jumplist so you can use CTRL-O to jump back to where you where before invoking the command (and CTRL-I to jump forward; see :h jumplist for details).

nnoremap <leader>jd :YcmCompleter GoTo<CR>
nnoremap <leader>kd :YcmCompleter GoTo<CR>
nnoremap <leader>kl :YcmCompleter GoTo <CR>
nnoremap <leader>kh :YcmCompleter GoToInclude<CR>
" }}}
" Deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#disable_auto_complete = 0
let g:deoplete#enable_debug = 1
let g:deoplete#auto_complete_delay=50

let g:deoplete#enable_refresh_always=0
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.gitcommit = '.+'

" call deoplete#custom#set('jedi', 'debug_enabled', 1)
" call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')

" fails
" call deoplete#util#set_pattern(
"   \ g:deoplete#omni#input_patterns,
"   \ 'gitcommit', [g:deoplete#keyword_patterns.gitcommit])
" deoplete clang {{{2

let g:deoplete#sources#clang#std#cpp = 'c++11'
let g:deoplete#sources#clang#sort_algo = 'priority'
" let g:deoplete#sources#clang#clang_complete_database = '/home/user/code/build'`


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
" Neomake config {{{
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


" TODO replace with getroot of directory ?
let g:neomake_cmake_maker = {
    \ 'exe': 'make',
    \ 'args': [],
    \ 'cwd': getcwd().'/build',
    \ 'errorformat': '%f:%l:%c: %m',
    \ 'remove_invalid_entries': 1,
    \ 'buffer_output': 0
    \ }

let g:neomake_verbose = 1

" call neomake#quickfix#enable()

" pyflakes can't be disabled on a per error basis
" also it considers everything as error => disable
" flake8  or pycodestyle when supported
" let g:neomake_list_height=5

" how to let 'mypy' ignore warning/errors as pycodestyle does ?
let g:neomake_python_enabled_makers = ['pycodestyle', ]
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
"let g:neomake_python_pep8_maker
" let g:neomake_tex_checkers = [ '' ]
" let g:neomake_tex_enabled_makers = []
let g:neomake_tex_enabled_makers = []
let g:neomake_python_enabled_makers = ['mypy']

" removed chktex because of silly errors
" let g:neomake_tex_enabled_makers = ['chktex']
" let g:neomake_error_sign = {'text': '✖ ', 'texthl': 'NeomakeErrorSign'}
let g:neomake_error_sign = {'text': 'X', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '⚠ ', 'texthl': 'NeomakeWarningSign'}
" let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
" let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

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

call neomake#configure#automake('w')
" augroup my_neomake
"     au!

"     " Run linting when writing filg
"     autocmd BufWritePost * Neomake
"     autocmd User NeomakeJobFinished call OnNeomakeFinished()
" augroup END
" }}}
" Airline {{{
let g:airline_extensions = ['obsession', 'tabline'] " to speed up things
" let g:airline#extensions#default#layout = [
"     \ [ 'a', 'b', 'c' ],
"     \ [ 'x', 'y', 'z', 'error', 'warning' ]
"     \ ]

let g:airline_highlighting_cache = 1
let g:airline_exclude_preview = 0
" control which sections get truncated and at what width. >
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }

let g:airline_highlighting_cache = 1 " to speed up things
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section = '|'
" display buffers as tabs if no split
" see :h airline-tabline
let g:airline_theme = 'molokai'
" let g:airline_section_b = '%#TermCursor#' . NeomakeJobs()
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z', 'error', 'warning' ]
      \ ]
" section y is fileencoding , useless in neovim
" define_raw
call airline#parts#define_function('neomake_custom', 'NeomakeStatusLine')
let g:airline_section_y = airline#section#create_right(['neomake_custom','ffenc'])
" let g:airline_section_y = airline#section#create_right(['neomake','ffenc'])
call airline#parts#define_function('grepper', 'grepper#statusline')
let g:airline_section_x = airline#section#create_right(['grepper'])
" grepper#statusline()
 " airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
" let g:airline_section_z = airline#section#create_right(['linenumber'])
" airline extensions {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#vimtex#enabled=1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_min_count =2
let g:airline#extensions#tabline#tab_min_count = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_tabs = 0
let airline#extensions#tabline#current_first = 0
" to rely on badd only ?
" let airline#extensions#tabline#disable_refresh = 0

let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline_extensions = ['branch', 'tabline', 'obsession']

" rely on tagbar plugin
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'

" csv plugin
let g:airline#extensions#csv#enabled = 1
let g:airline_detect_spell=1

" ycm integration
let g:airline#extensions#ycm#enabled = 0
let g:airline#extensions#ycm#error_symbol = s:gutter_error_sign
let g:airline#extensions#ycm#warning_symbol = s:gutter_warn_sign

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2

let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '$'
"}}}

" let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long' ]
"|neomake#statusline#LoclistStatus should be shown in warning section
" let &statusline .= ' %{grepper#statusline()}'
" let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}'])
" airline mappings {{{
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

" qwerty version
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab

"}}}
" one could change the formatter with 
  " let g:airline#extensions#tabline#formatter = 'default'
"}}}
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
nmap <leader>c <Plug>(InYoFace_Toggle)<CR>
" }}}
" close the preview window on python completion {{{
" autocmd CompleteDone * pclose
set completeopt=menu,longest
" }}}
" vim-sayonara {{{
nnoremap <silent><leader>Q  :Sayonara<cr>
nnoremap <silent><leader>q  :Sayonara!<cr>

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
" neco-ghc (haskell completion) {{{
" slower bu t shows type
let g:necoghc_enable_detailed_browse = 1
let g:necoghc_debug=0
"}}}
" ghcmod ( all :GhcMod* commands) {{{
" let g:ghcmod_ghc_options=[]
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
let g:vimtex_quickfix_open_on_warning = 1
let g:vimtex_view_automatic=1
" autoindent can slow down vim quite a bit
" to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
let g:vimtex_indent_enabled=0
let g:vimtex_indent_bib_enabled=1
let g:vimtex_compiler_enabled=1 " enable new style vimtex
let g:vimtex_compiler_progname='nvr'
" let g:vimtex_compiler_method=
" g:vimtex_quickfix_method=
let g:vimtex_indent_enabled=0
let g:vimtex_indent_bib_enabled=1
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
"let g:vimtex_snippets_leader = ','
let g:vimtex_fold_enabled = 0
let g:vimtex_format_enabled = 0
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_complete_close_braces = 0
let g:vimtex_fold_comments=0
let g:vimtex_view_use_temp_files=1 " to prevent zathura from flickering
let g:vimtex_syntax_minted = [
      \ {
      \   'lang' : 'json',
      \ }]
" let g:vimtex_log_ignore = 
let g:vimtex_log_verbose= 1
let g:vimtex_quickfix_mode = 2 " 1=> opened automatically and becomes active (2=> inactive)
" Package biblatex Warning: B
" with being on anotherline
" deprecated by g:vimtex_quickfix_latexlog|)
"
      " \ 'Biber reported the following issues',
      " \ "Invalid format of field 'month'"
let g:vimtex_quickfix_ignored_warnings = [
      \ 'Underfull',
      \ 'Overfull',
      \ 'specifier changed to',
      \ ]
let g:vimtex_compiler_latexmk = {
        \ 'background' : 1,
        \ 'build_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'options' : [
        \   '-pdf',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \   '-biber'
        \ ],
        \}
      "
"<plug>(vimtex-toc-toggle)
" au BufEnter *.tex exec ":setlocal spell spelllang=en_us"
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
"|
"set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
" }}}
" Grepper {{{
" add -cword to automatically fill with the underlying word
" example given by mhinz to search into current buffer
" https://github.com/mhinz/vim-grepper/issues/27
" let g:grepper = { 'git': { 'grepprg': 'git grep -nI $* -- $.' }}
" Grepper -grepprg ag --vimgrep $* $. works
runtime plugin/grepper.vim  " init grepper with defaults
let g:grepper.tools += ["rgall"]
let g:grepper.rgall = copy(g:grepper.rg)
let g:grepper.rgall.grepprg .= ' --no-ignore'
let g:grepper.highlight = 1
let g:grepper.open = 0
let g:grepper.switch = 1

nnoremap <leader>git :Grepper -tool git -open -nojump
nnoremap <leader>ag  :Grepper -tool ag  -open -switch
nnoremap <leader>rg  :Grepper -tool rg -open -switch



" highlight! link QuickFixLine Normal


function! OnGrepperCompletion()
  copen
  hi link GrepperNormal   StatusLineNC
  " guibg=lightblue
  if exists("winhl")
    setlocal winhl=Normal:GrepperNormal
  endif
" call notify#emitNotification('grepper', 'Search finished') | 
endfunction

autocmd User Grepper call OnGrepperCompletion()

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" }}}
" sidesearch {{{
" SideSearch current word and return to original window
" nnoremap <Leader>ss :SideSearch <C-r><C-w><CR> | wincmd p

" " Create an shorter `SS` command
" command! -complete=file -nargs=+ SS execute 'SideSearch <args>'

" " or command abbreviation
" cabbrev SS SideSearch"
" }}}
" folding config {{{
" block,hor,mark,percent,quickfix,search,tag,undo
" set foldopen+=all " specifies commands for which folds should open
" set foldclose=all
"set foldtext=
set foldcolumn=2

if has("folding_fillchars")
	" removed to test default values
	" ,foldend:^
  set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
  " echo "doing it"
  " set fdc=-1
  set fdc=0
endif
" }}}
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
let g:peekaboo_delay = 0

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
let g:signify_sign_show_text = 0
" let g:signify_sign_add =  "\u00a0" " unbreakable space
" let g:signify_sign_delete            = "\u00a0"
" " let g:signify_sign_delete_first_line = '‾'
" let g:signify_sign_change            = "\u00a0"
" let g:signify_sign_changedelete      = g:signify_sign_change
" let g:signify_sign_show_count|
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
nmap <leader>wj <plug>(signify-next-hunk)
" nnoremap <leader>sj :echomsg 'next-hunk'<CR>
nmap <leader>sk <plug>(signify-prev-hunk)

" }}}
" autosave plugin (:h auto-save) {{{
let g:auto_save_in_insert_mode = 1
let g:auto_save_events = ['FocusLost']
"let g:auto_save_events = ['CursorHold', 'FocusLost']
let g:auto_save_write_all_buffers = 1 " Setting this option to 1 will write all
" Put this in vimrc, add custom commands in the function.
"
" function! AutoSaveOnLostFocus()
"   " to solve pb with Airline https://github.com/vim-airline/vim-airline/issues/1030#issuecomment-183958050
"   exe ":au FocusLost ".expand("%")." :wa | :AirlineRefresh | :echom 'Focus lost'"
" endfunction
" }}}
" Customized commands depending on buffer type {{{

nnoremap <LocalLeader>sv :source $MYVIMRC<CR> " reload vimrc
" }}}
" vim-scripts/QuickFixCurrentNumber {{{
"*:QuickhlManualEnable*		Enable.
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
" rtags {{{
" <leader>rw montre les différents projets ( <=> $rc -w)
let g:rtagsUseLocationList=1
let g:rtagsUseDefaultMappings = 1
let g:rtagsLog=$HOME."/rtags.log"

let g:rtagsExcludeSysHeaders=0
let g:rtagsAutoLaunchRdm=1
" let g:rtagsExcludeSysHeaders
" }}}
" http://vim.wikia.com/wiki/Show_tags_in_a_separate_preview_window {{{
" au! CursorHold *.[ch] nested call PreviewWord()
" CursorHold depends on updatetime
func! PreviewWord()
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand("<cword>")		" get the word under cursor
  if w =~ '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
      exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
      if has("folding")
	silent! .foldopen		" don't want a closed fold
      endif
      call search("$", "b")		" to end of previous line
      let w = substitute(w, '\\', '\\\\', "")
      call search('\<\V' . w . '\>')	" position cursor on match
      " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
      exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfun
"}}}
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
" deoplete-clang2 config {{{
" let g:deoplete#sources#clang#executable="/usr/bin/clang"
" let g:deoplete#sources#clang#autofill_neomake=1
"}}}
" tjdevries lsp {{{
let g:langserver_executables = {
    \ 'go': {
    \ 'name': 'sourcegraph/langserver-go',
    \ 'cmd': ['langserver-go', '-trace', '-logfile', expand('~/Desktop/langserver-go.log')],
    \ },
    \ 'c': {
    \ 'name': 'clangd',
    \ 'cmd': ['clangd', ],
    \ },
    \ 'python': {
    \ 'name': 'pyls',
    \ 'cmd': ['pyls', '--log-file' , expand('~/lsp_python.log')],
    \ },
      \ }
" }}}
" autozimu's lsp {{{
" call LanguageClient_textDocument_hover
" by default logs in /tmp/LanguageClient.log.
let g:LanguageClient_autoStart=1 " Run :LanguageClientStart when disabled
let g:LanguageClient_settingsPath=$MYVIMRC
" pyls.configurationSources
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."/nvim/settings.json"
let g:LanguageClient_selectionUI='fzf'
" let g:LanguageClient_trace="verbose"
" call LanguageClient_setLoggingLevel('DEBUG')
"let g:LanguageClient_diagnosticsList="quickfix"

" hardcoded for now
"fnamemodify( g:python3_host_prog, ':p:h').
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls']
    \ , 'python': [ '/nix/store/811vahmvwab4i2q5mhrxyvdp3yv0fhfd-python3-3.6.5-env/bin/pyls', '--log-file' , expand('~/lsp_python.log')]
    \ }

" todo provide a fallback if lsp not available
" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
"}}}


" dasht{{{

" When in Python, also search NumPy, SciPy, and Pandas:
let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']

" search related docsets
nnoremap <Leader>k :Dasht<Space>

" search ALL the docsets
nnoremap <Leader><Leader>k :Dasht!<Space>
"}}}}}}
set hidden " you can open a new buffer even if current is unsaved (error E37)

" draw a line on 80th column
set colorcolumn=80,100

" default behavior for diff=filler,vertical
set diffopt=filler,vertical

" Y behave like D or C
nnoremap Y y$


" search items in location list (per window)
" nnoremap <F1> :lprev<CR>
" nnoremap <F2> :lnext<CR>
" search for  item in quickfix list (global/unique)
" TODO should be able to look for the next one from where I stand !
" tire du plugin QuickFixCurrentNumber
" au QuickfixCmdPost nmap <F3> <Plug>(QuickFixCurrentNumberLPrev) | nmap <f4> <Plug>(QuickFixCurrentNumberLNext)

" http://vim.1045645.n5.nabble.com/detect-QuickFix-window-list-or-LocationList-td4952180.html
function! GoToNextError()
" qf ? getqflist()
  let list = getloclist(0)
  let ret = len(list)
echomsg ret
  if ret == 0
    echomsg 'GoToNextQF'
    execute "normal \<Plug>(QuickFixCurrentNumberQNext)"
  else

    echomsg 'GoToNextLL'
    " call <Plug>(QuickFixCurrentNumberLNext)
    execute "normal \<Plug>(QuickFixCurrentNumberLNext)"
  endif
endfunc

" <Plug>(QuickFixCurrentNumberLPrev)
nmap <F3> call GoToPrevError()
nmap <F4> call GoToNextError()

" nmap <S-F3> <Plug>(QuickFixCurrentNumberQPrev)
" nmap <S-f4> <Plug>(QuickFixCurrentNumberQNext)


nnoremap <F5> :Neomake! make<CR>
nnoremap <F6> :AutoSaveToggle<CR>
"nnoremap <F6> :AutoSaveOnLostFocus<CR>
" goto previous buffer
nnoremap <F7> :bp<CR>
nnoremap <F8> :bn<CR>
nnoremap <F9> :YcmToggleLogs<CR>
" est mappe a autre chose pour l'instant
"noremap <F13> exec ":emenu <tab>"
" should become useless with neovim
" noremap <F10> :set paste!<CR>
map <F11> <Plug>(ToggleListchars)

" Command to toggle line wrapping.
nnoremap <Leader>wr :set wrap! \| :set wrap?<CR>

" vim:foldmethod=marker:foldlevel=0
" Get off my lawn
"noremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

" flashy config (replaced by highlightedyank) {{{
" map y <Plug>(operator-flashy)
" nmap Y <Plug>(operator-flashy)$
" let g:operator#flashy#flash_time=300 " in milliseconds
" }}}
" highlightedyank {{{
let g:highlightedyank_highlight_duration = 1000
" let g:highlightedyank_max_linesr=
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



" Bye bye ex mode
noremap Q <NOP>

" vim-open-url {{{
let g:open_url_browser_default="qutebrowser"
"}}}
" qfgrep {{{
" <Leader>g to filter entries (user will be asked for pattern) works only in
" location list/quickfix similar to :QFGrep
" <Leader>r to restore original quickfix entires.
let g:QFG_hi_error = 'ctermbg=167 ctermfg=16 guibg=#d75f5f guifg=black'
"}}}
" QuickFixCurrentNumber {{{
let g:no_QuickFixCurrentNumber_maps = 1
" }}}
" location list / quickfix config {{{
" location list can be associated with only one window.
" The location list is independent of the quickfix list.
" }}}
" ListToggle config {{{
let g:lt_location_list_toggle_map = '<F12>' " '<leader>l'
let g:lt_quickfix_list_toggle_map = '<F2>' " '<leader>qq'

nmap <leader>l  <Plug>(ListToggleLToggle)
nmap <F1>  <Plug>(ListToggleQToggle)

" }}}
" iron.nvim {{{
" cp = repeat the previous command
" ctr send a chunk of text with motion
" nmap <localleader>t <Plug>(iron-send-motion)
let g:iron_repl_open_cmd="vsplit"
" let g:iron_new_repl_hooks
" let g:iron_new_lua_repl_hooks
"let g:iron_map_defaults
"}}}

" buffers
map <Leader>n :bnext<CR>
map <Leader>N :bNext<CR>
" map <Leader>p :bprevious<CR>
map <Leader>$ :Obsession<CR>
" map <Leader>d :bdelete<CR>

"http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious

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
" call orchestra#prelude()
" call orchestra#set_tune('clackclack')

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
set cpoptions="aABceFsn" " vi ComPatibility options
set matchpairs+=<:>  " Characters for which % should work

" TODO to use j/k over
" set whichwrap+=<,>,h,l

" repl.nvim (from hiphish) {{{
" let g:repl['lua'] = {
"     \ 'bin': 'lua',
"     \ 'args': [],
"     \ 'syntax': '',
"     \ 'title': 'Lua REPL'
" \ }
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
  "now ignored
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  " let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
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

" }}}
" set guicursor="n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor"
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
" set guicursor=i:ver3,n:block-blinkon10-Cursor,r:hor50
highl Cursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
" highl lCursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00

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

if has("signcolumnwidth")
    set signcolumnwidth=6
endif
" call
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
map <C-5> :Neomake! make<CR>

highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227 guibg=#F08A1F

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


" QuickFixLine
" NonText
" runtime init.generated.vim
