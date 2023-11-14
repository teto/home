-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://www.reddit.com/r/neovim/comments/o8dlwg/how_to_append_to_an_option_in_lua/
-- local configs = require'nvim_lsp/configs'
-- vim.loader.enable()
-- showcmdloc
local has_fzf_lua, fzf_lua = pcall(require, 'fzf-lua')

local nnoremap = vim.keymap.set
local map = vim.keymap.set
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end-- require("vim.lsp._watchfiles")._watchfunc = require("vim._watch").watch
-- local ffi = require 'ffi'


---  set guicursor as a red block in normal mode

-- workaround slow neovim https://github.com/neovim/neovim/issues/23725
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
	-- disable lsp watcher. Too slow on linux
	wf._watchfunc = function()
	return function() end
	end
end

-- undocumented like --luamod-dev
vim.g.__ts_debug = 10

-- vim.cmd([[packloadall ]])
-- HOW TO TEST our fork of plenary
-- vim.opt.rtp:prepend(os.getenv("HOME").."/neovim/plenary.nvim")
-- local reload = require'plenary.reload'
-- reload.reload_module('plenary')
-- require'plenary'
vim.g.matchparen = 0
vim.g.mousemoveevent = 1-- must be setup before calling lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.colorcolumn = { 100 }
vim.opt.termguicolors = true

-- TODO package last-color in nix
vim.opt.rtp:prepend(lazypath)
-- vim.opt.rtp:prepend("/home/teto/rocks.nvim")

-- set it before loading vim plugins like autosession
-- ,localoptions
vim.o.sessionoptions="blank,buffers,curdir,help,tabpages,winsize,winpos"

require('lazy').setup('lazyplugins', {
	lockfile = vim.fn.stdpath('cache') .. '/lazy-lock.json',
	dev = {
		-- directory where you store your local plugin projects
		-- path = '/home/teto/neovim',
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
	performance = {
		cache = {
			-- try ?
			enabled = true,
		},
		-- we install some packages via nix so we want to load from packpath too
		reset_packpath = false,
		rtp = {
			reset = false,
-- while testing/developing rest.nvim

          paths = {
			  -- '/home/teto/neovim/rest.nvim'
			-- , '/home/teto/tree-sitter-http'
		  }, -- add any custom paths here that you want to includes in the rtp
          disabled_plugins = {
            -- "gzip",
            -- "matchit",
            "matchparen",
            -- "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
		},
	},
	debug = false,
})
-- lazy/config.lua sets vim.go.loadplugins = false so I used to run packloadall to restore those plugins
-- but there seems to be a bug somewhere as overriding VIMRUNTIME would then be dismissed and it would used
-- whatever VIMRUNTIME, even an old one ? so there is some cache invalidation issue somewhere ?
-- this is a quickfix that works around lazyplugins issue but I need to find the rootcause
vim.go.loadplugins = true

-- main config {{{
-- vim.opt.splitbelow = true	-- on horizontal splits
vim.opt.splitright = true -- on vertical split

vim.opt.title = true -- vim will change terminal title
-- look at :h statusline to see the available 'items'
-- to count the number of buffer
-- echo len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
-- let &titlestring=" %t %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) } - NVIM"
vim.opt.titlestring = "%{getpid().':'.getcwd()}"

-- Indentation {{{
vim.opt.tabstop = 4 -- a tab takes 4 characters (local to buffer) abrege en ts
vim.opt.shiftwidth = 4 -- Number of spaces to use per step of (auto)indent.
-- set smarttab -- when inserting tab in front a line, use shiftwidth
-- vim.opt.smartindent = false -- might need to disable ?

-- vim.opt.cindent = true
-- set cinkeys-=0# " list of keys that cause reindenting in insert mode
-- set indentkeys-=0#

vim.opt.softtabstop = 0 -- inserts a mix of <Tab> and spaces, 0 disablres it
-- "set expandtab " replace <Tab with spaces
-- }}}

vim.opt.showmatch = true
vim.opt.showcmd = true
vim.opt.showfulltag = true
vim.opt.hidden = true -- you can open a new buffer even if current is unsaved (error E37) =
vim.opt.shiftround = true -- round indent to multiple of 'shiftwidth'

-- Use visual bell instead of beeping when doing something wrong
vim.opt.visualbell = true
-- easier to test visualbell with it
vim.opt.errorbells = true

-- start scrolling before reaching end of screen in order to keep more context
-- set it to a big value
vim.opt.scrolloff = 2
-- inverts the meaning of g in substitution, ie with gdefault, change all occurences
vim.opt.gdefault = true
vim.opt.cpoptions = 'aABceFsn' -- vi ComPatibility options
-- " should not be a default ?
-- set cpoptions-=_

-- vim.g.vimsyn_embed = 'lP'  -- support embedded lua, python and ruby
-- don't syntax-highlight long lines
vim.opt.synmaxcol = 300
vim.g.did_install_default_menus = 1 -- avoid stupid menu.vim (saves ~100ms)

vim.o.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.laststatus = 3
-- vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
vim.opt.showmode = false -- Show the current mode on command line
vim.opt.cursorline = true -- highlight cursor line

-- set noautoread " to prevent from interfering with our plugin
-- set breakat=80 " characters at which wrap can break line
vim.opt.wrap = true
vim.opt.linebreak = true -- better display (makes sense only with wrap)
vim.opt.breakindent = true -- preserve or add indentation on wrap
--
vim.opt.modeline = true
vim.opt.modelines = 4 -- number of lines checked

vim.opt.backspace = { 'indent', 'eol', 'start' }
-- Search parameters {{{
vim.opt.hlsearch = true -- highlight search terms
vim.opt.incsearch = true -- show search matches as you type
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- take case into account if search entry has capitals in it
vim.opt.wrapscan = true -- prevent from going back to the beginning of the file

vim.opt.inccommand = 'nosplit'

vim.opt.mouse = 'a'
-- https://github.com/neovim/neovim/issues/14921
vim.opt.mousemodel = 'popup_setpos'

vim.opt.signcolumn = 'auto:3'

--set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada

-- added 'n' to defaults to allow wrapping lines to overlap with numbers
-- n => ? used for wrapped lines as well
-- vim.opt.matchpairs+=<:>  -- Characters for which % should work

-- TODO to use j/k over
vim.opt.whichwrap = vim.opt.whichwrap + '<,>,h,l'

-- nnoremap <Leader>/ :set hlsearch! hls?<CR> " toggle search highlighting
-- }}}
-- folding config {{{
-- " block,hor,mark,percent,quickfix,search,tag,undo
-- " set foldopen+=all " specifies commands for which folds should open
-- " set foldclose=all
-- "set foldtext=
vim.opt.fillchars = vim.opt.fillchars + 'foldopen:▾,foldsep:│,foldclose:▸'
vim.opt.fillchars = vim.opt.fillchars + 'msgsep:‾'
vim.opt.fillchars = vim.opt.fillchars + 'diff: ' -- \
-- hi MsgSeparator ctermbg=black ctermfg=white
-- " hi DiffDelete guibg=red
-- }}}
-- default behavior for diff=filler,vertical
vim.opt.diffopt = 'filler,vertical'
-- neovim > change to default ?
vim.opt.diffopt:append('hiddenoff')
vim.opt.diffopt:append('iwhiteall')
-- vim.opt.diffopt:append('linematch')
vim.opt.diffopt:append('internal,algorithm:patience')

vim.opt.undofile = true
-- let undos persist across open/close
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo/'
-- vim.opt.sessionoptions:remove('terminal')
-- vim.opt.sessionoptions:remove('help')
-- folds,
--}}}

-- annoying in fzf-lua ?
-- map('t', '<Esc>', '<C-\\><C-n>')
-- :tnoremap <Esc> <C-\><C-n>
-- nnoremap{ "n", "<C-N><C-N>", function () vim.opt.invnumber end }

-- X clipboard gets aliased to +
vim.opt.clipboard = 'unnamedplus'

-- wildmenu completion
-- TODO must be number
-- vim.opt.wildchar=("<Tab>"):byte()
-- display a menu when need to complete a command
-- list:longest, -- list breaks the pum
vim.opt.wildmode = { 'longest', 'list' } -- longest,list' => fills out longest then show list
-- set wildoptions+=pum

vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache') .. '/hoogle_cache.json'

vim.opt.wildmenu = true
-- vim.opt.omnifunc='v:lua.vim.lsp.omnifunc'
-- navic counts on documentSymbols
-- %=%m %f
vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- sh -c "lua -e 'dofile [[%]] print(description.homepage)' | xdg-open"

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Attach lsp_signature on new client",
	callback = function(args)
		-- print("Called matt's on_attach autocmd")
		if not (args.data and args.data.client_id) then
			return
		end
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		local on_attach = require 'teto.on_attach'
		on_attach.on_attach(client, bufnr)
		-- require'lsp_signature'.on_attach(client, bufnr)
	end
})

vim.api.nvim_create_autocmd("VimLeave", {
	desc = "test to fix stacktrace",
	callback = function(args)
	end
})


function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

vim.api.nvim_create_autocmd("BufRead", {
	desc = "Disable syntax on big files",
	callback = function(args)
		-- print("autocmd BufRead cb", args.file)
		if args.file:endswith("pkgs/development/haskell-modules/hackage-packages.nix") then
			-- print("autocmd BufRead cb", args.file)
			-- print("DISABLING syntax")
			vim.cmd([[setlocal syntax=off]])
		end

	end
})

-- fugitive-gitlab {{{
-- also add our token for private repos
-- }}}
-- set guicursor="n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor"
vim.opt.guicursor =
'n-v-c:block-blinkon250-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-blinkon250-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- highl Cursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
vim.api.nvim_set_hl(0, 'Cursor', { ctermfg = 16, ctermbg = 253, fg = '#000000', bg = '#00FF00' })
vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'None', bg = '#293739' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'grey' })

-- local my_image = require('hologram.image'):new({
--	   source = '/home/teto/doctor.png',
--	   row = 11,
--	   col = 0,
-- })
-- my_image:transmit() -- send image data to terminal

-- while testing/developing rest.nvim
vim.opt.runtimepath:prepend('/home/teto/neovim/rest.nvim')
vim.opt.runtimepath:prepend('/home/teto/tree-sitter-http')
-- lua require'plenary.reload'.reload_module('rest-nvim.request')
-- vim.opt.runtimepath:prepend('/home/teto/nvim-treesitter')

-- f3 to show tree
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>')

vim.keymap.set('n', '<f2>',
	"<cmd>lua require'plenary.reload'.reload_module('rest-nvim.request'); print(require'rest-nvim.request'.ts_get_requests())<cr>"
)

local has_rest, rest = pcall(require, 'rest-nvim')
if has_rest then
	rest.setup({
		-- Open request results in a horizontal split
		result_split_horizontal = false,
		-- Skip SSL verification, useful for unknown certificates
		skip_ssl_verification = false,
		-- engine = 'classic',
		-- parser = 'treesitter',
		-- Highlight request on run
		highlight = {
			enabled = true,
			timeout = 150,
		},
		result = {
			-- toggle showing URL, HTTP info, headers at top the of result window
			show_curl_command = true,
			show_url = true,
			show_http_info = true,
			show_headers = true,
			-- disable formatters else they generate errors/add dependencies
			-- for instance when it detects html, it tried to run 'tidy'
			formatters = {
				html = false,
				jq = false,
			},
		},
		-- Jump to request line on run
		jump_to_request = false,
	})

-- TODO remove once it's merged upstream
vim.api.nvim_create_user_command('RestLog', function()
  vim.cmd(string.format('tabnew %s', vim.fn.stdpath('cache')..'/rest.nvim.log'))
end, {
  desc = 'Opens the rest.nvim log.',
})



end

-- Snippets are separated from the engine. Add this if you want them:

-- " use 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
-- " use 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting

-- prefix commands :Files become :FzfFiles, etc.
vim.g.fzf_command_prefix = 'Fzf'
-- disable statusline overwriting
vim.g.fzf_nvim_statusline = 0

-- This is the default extra key bindings
vim.g.fzf_action = { ['ctrl-t'] = 'tab split', ['ctrl-x'] = 'split', ['ctrl-v'] = 'vsplit' }
vim.g.fzf_history_dir = vim.fn.stdpath('cache') .. '/fzf-history'
vim.g.fzf_buffers_jump = 1
-- Empty value to disable preview window altogether
vim.g.fzf_preview_window = 'right:30%'

-- Default fzf layout - down / up / left / right - window (nvim only)
-- vim.g.fzf_layout = { 'down': '~40%' }

-- For Commits and BCommits to customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- " use 'dhruvasagar/vim-table-mode', {'for': 'txt'}
-- " use 'mhinz/vim-rfc', { 'on': 'RFC' } " requires nokigiri gem
-- " careful maps F4 by default
-- " use 'bronson/vim-trailing-whitespace' " :FixWhitespace

-- TODO this should depend on theme ! computed via lush
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'red' })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextDebug', { fg = 'green' })

-- http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>')

vim.keymap.set('n', '<Leader>ev', '<Cmd>e $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>el', '<Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>')
vim.keymap.set('n', '<F6>', '<Cmd>ASToggle<CR>')

-- set vim's cwd to current file's
-- nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

--  when launching term
--   tnoremap <Esc> <C-\><C-n>


-- This is the default extra key bindings
-- vim.g.fzf_action = { ['ctrl-t']: 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

-- Default fzf layout - down / up / left / right - window (nvim only)
vim.g.fzf_layout = { ['down'] = '~40%' }

-- For Commits and BCommits to customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		-- TODO higroup should be its own ? a darker version of CursorLine
		-- if it doesnt exist
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
	end,
})
nnoremap('n', '<leader>ml', '<Cmd>Modeliner<Enter>')

vim.api.nvim_create_autocmd('ColorScheme', {
	desc = "Set italic codelens on new colorschemes",
	callback = function()
		-- TODO create a TextYankPost highlight if it doesn't exist in scheme ?!
		vim.api.nvim_set_hl(0, 'LspCodeLens', { italic = true })
	end,
})

vim.g.Modeliner_format = 'et ff= fenc= sts= sw= ts= fdm='

-- " auto reload vim config on save
-- " Watch for changes to vimrc
-- " augroup myvimrc
-- "   au!
-- "   au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
-- " augroup END

vim.cmd([[sign define DiagnosticSignError text=✘ texthl=LspDiagnosticsSignError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarning text=！ texthl=LspDiagnosticsSignWarning linehl= numhl=CustomLineWarn]])
vim.cmd(
	[[sign define DiagnosticSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=CustomLineWarn]]
)
vim.cmd([[sign define DiagnosticSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=]])

-- autocmd ColorScheme *
--       \ highlight Comment gui=italic
--       \ | highlight Search gui=underline
--       \ | highlight MatchParen guibg=NONE guifg=NONE gui=underline
--       \ | highlight NeomakePerso cterm=underline ctermbg=Red  ctermfg=227  gui=underline

-- netrw config {{{
vim.g.netrw_browsex_viewer = 'xdg-open'
vim.g.netrw_home = vim.env.XDG_CACHE_HOME .. '/nvim'
vim.g.netrw_liststyle = 1 -- long listing with timestamp
--}}}
vim.keymap.set('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>')

-- vim.keymap.set("n", "<leader>rgb", "<Cmd>Grepper -tool rgb -open -switch -buffer<CR>")

-- vim.api.nvim_create_augroup('bufcheck', {clear = true})

-- autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
-- " convert all kinds of files (but pdf) to plain text
-- autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*.pdf',
	callback = function()
		vim.cmd([[%!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78]])
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
	end,
})

-- local verbose_output = false
-- require("tealmaker").build_all(verbose_output)


local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
	-- use('michaeladler/cmp-notmuch')
	-- nvim-cmp autocompletion plugin{{{
	cmp.setup({
		sorting = {
			comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.kind,
			-- cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
			}
		},
		-- commented to prevent 'Unknown function: vsnip#anonymous'
		snippet = {
			-- SNIPPET SUPPORT MANDATORY in cmp
			expand = function(args)
				-- For `vsnip` user.
				vim.fn['vsnip#anonymous'](args.body)

				-- For `luasnip` user.
				-- require('luasnip').lsp_expand(args.body)

				-- For `ultisnips` user.
				-- vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({

			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			--   ['<C-Space>'] = cmp.mapping.complete(),
			--   ['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		-- view = {
		-- 	entries = 'native'
		-- },
		sources = {
			{ name = 'nvim_lsp' },

			-- For vsnip user.
			{ name = 'vsnip' },

			-- For luasnip user.
			-- { name = 'luasnip' },

			-- For ultisnips user.
			-- { name = 'ultisnips' },

			{ name = 'buffer' },
			-- { name = 'neorg' },
			-- { name = 'orgmode' },
		},
	})
	--  }}}
	-- 	cmp.setup.cmdline {
	-- 	mapping = cmp.mapping.preset.cmdline({
	-- 		-- Your configuration here.
	-- 	})

	-- 	}

	--   end
	-- }
end

-- Load custom tree-sitter grammar for org filetype
-- orgmode depends on treesitter
-- local has_orgmode, orgmode = pcall(require, 'orgmode')
-- if has_orgmode then
-- 	it's already done in nix, but maybe let the possibility to :xa
-- 	require('orgmode').setup{
-- 		org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
-- 		org_default_notes_file = '~/orgmode/refile.org',
-- 		-- TODO add templates
-- 		org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' }  }
-- 	}
-- end


local has_sniprun, sniprun = pcall(require, 'sniprun')

if has_sniprun then
	sniprun.setup({
		-- selected_interpreters = {'Python3_fifo'},        --" use those instead of the default for the current filetype
		-- repl_enable = {'Python3_fifo', 'R_original'},    --" enable REPL-like behavior for the given interpreters
		-- repl_disable = {},                               --" disable REPL-like behavior for the given interpreters
		interpreter_options = { --# interpreter-specific options, see docs / :SnipInfo <name>
			Bash_original = {
				use_on_filetypes = { 'nix' }, --# the 'use_on_filetypes' configuration key is
			},
			--# use the interpreter name as key
			--GFM_original = {
			--use_on_filetypes = {"markdown.pandoc"}    --# the 'use_on_filetypes' configuration key is
			--											--# available for every interpreter
			--},
			--Python3_original = {
			--	error_truncate = "auto"         --# Truncate runtime errors 'long', 'short' or 'auto'
			--									--# the hint is available for every interpreter
			--									--# but may not be always respected
			--}
		},
		-- possible values are 'none', 'single', 'double', or 'shadow'
		borders = 'single',
		--live_display = { "VirtualTextOk" }, --# display mode used in live_mode
		----# You can use the same keys to customize whether a sniprun producing
		----# no output should display nothing or '(no output)'
		--show_no_output = {
		--	"Classic",
		--	"TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
		--},
		--" you can combo different display modes as desired
		display = {
			'Classic', -- "display results in the command-line  area
			'VirtualTextOk', -- "display ok results as virtual text (multiline is shortened)
		},
	})
	vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', { silent = true })
	vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', { silent = true })
	vim.api.nvim_set_keymap('n', '<leader>ff', '<Plug>SnipRun', { silent = true })
end

-- add description
-- lua require("nvim-treesitter.parsers").reset_cache();
vim.api.nvim_set_keymap('n', '<f3>', '<cmd>lua vim.treesitter.inspect_tree()<cr>', {})
vim.api.nvim_set_keymap('n', '<f5>', '<cmd>!make build', {})

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

-- vim.g.should_show_diagnostics_in_statusline = true


if has_fzf_lua then
	require('fzf-lua.providers.ui_select').register({})

	require('teto.fzf-lua').register_keymaps()
	local fzf_history_dir = vim.fn.expand('~/.local/share/fzf-history')
	fzf_lua.setup({
		commands = { sort_lastused = true },
		-- [...]
		fzf_opts = {
			-- [...]
			['--history'] = fzf_history_dir,
			-- to get the prompt at the top
			['--layout'] = 'reverse',
		},
		winopts = {
			preview = {
				-- default = 'builtin'
				hidden = 'hidden',
			},
		},
	})
end
-- nnoremap ( "n", "<Leader>ca", function () vim.lsp.buf.code_action{} end )
nnoremap('n', '<Leader>ca', function()
	vim.cmd([[FzfLua lsp_code_actions]])
end)

-- since it was not merge yet
-- inoremap <C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("i")<CR>
-- nnoremap { "n", "r<C-k><C-k>" , function () require'betterdigraphs'.digraphs("r") end}
-- vnoremap r<C-k><C-k> <ESC><Cmd>lua require'betterdigraphs'.digraphs("gvr")<CR>

local has_bufferline, bufferline = pcall(require, 'bufferline')
if has_bufferline then
	bufferline.setup({

		options = {
			-- buffer_close_icon = '',

			view = 'default',
			numbers = 'buffer_id',
			-- number_style = "superscript" | "",
			-- mappings = true,
			modified_icon = '●',
			close_icon = '',
			-- left_trunc_marker = '',
			-- right_trunc_marker = '',
			-- max_name_length = 18,
			-- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
			-- tab_size = 18,
			show_buffer_close_icons = false,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- -- can also be a table containing 2 custom separators
			-- -- [focused and unfocused]. eg: { '|', '|' }
			-- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
			separator_style = 'slant',
			-- enforce_regular_tabs = false | true,
			always_show_bufferline = false,
			-- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
			-- -- add custom logic
			-- return buffer_a.modified > buffer_b.modified
			-- end
			hover = {
				enabled = true,
				delay = 200,
				reveal = { 'close' },
			},
		},
	})
	for i = 1, 9 do
		vim.keymap.set(
			'n',
			'<leader>' .. tostring(i),
			'<cmd>BufferLineGoToBuffer ' .. tostring(i) .. '<CR>',
			{ silent = true }
		)
	end
end

vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath('config') .. '/snippets' }
vim.g.tex_flavor = 'latex'
-- require('teto.treesitter')

require('teto.lspconfig')

-- vim.lsp.set_log_level('DEBUG')

local has_iron, iron = pcall(require, 'iron.core')
if has_iron then

	-- doc at https://github.com/Vigemus/iron.nvim/tree/master
	local view = require("iron.view")
	iron.setup({
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		config = {
			-- If iron should expose `<plug>(...)` mappings for the plugins
			-- should_map_plug = false,
			-- -- Whether a repl should be discarded or not
			-- scratch_repl = true,
			-- Your repl definitions come here
			repl_definition = {
			    sh = { command = { 'zsh' } },
			    nix = { command = { 'nix', 'repl', '/home/teto/nixpkgs' } },
			    -- copied from the nix wrapper :/
				-- ${pkgs.luajit}/bin
			    lua = { command = 'lua' },
			},
			-- repl_open_cmd = require('iron.view').left(200),
			repl_open_cmd = view.split.vertical.botright(0.4)
			-- how the REPL window will be opened, the default is opening
			-- a float window of height 40 at the bottom.
		},
	})

end

vim.opt.background = 'light' -- or "light" for light mode

vim.opt.showbreak = '↳ ' -- displayed in front of wrapped lines

-- TODO add a command to select a ref  and call Gitsigns change_base afterwards

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

-- local menu_add, menu_add_cmd = myMenu.menu_add, myMenu.menu_add_cmd
-- menu_add('LSP.Declaration', '<cmd>lua vim.lsp.buf.declaration()<cr>')
-- menu_add('LSP.Definition', '<cmd>lua vim.lsp.buf.definition()<cr>')
-- menu_add('LSP.Hover', '<cmd>lua vim.lsp.buf.references()<cr>')
-- menu_add('LSP.Rename', '<cmd>lua vim.lsp.buf.rename()<cr>')
-- menu_add('LSP.Format', '<cmd>lua vim.lsp.buf.format()<cr>')

-- menu_add('Toggle.Minimap', '<cmd>MinimapToggle<cr>')
-- menu_add('Toggle.Obsession', '<cmd>Obsession<cr>')
-- menu_add('Toggle.Blanklines', '<cmd>IndentBlanklineToggle<cr>')
-- menu_add("Toggle.Biscuits", 'lua require("nvim-biscuits").toggle_biscuits()')

-- menu_add('REPL.Send line', [[<cmd>lua require'luadev'.exec(vim.api.nvim_get_current_line())<cr>]])
-- menu_add('REPL.Send selection ', 'call <SID>luadev_run_operator(v:true)')

-- menu_add ("PopUp.Lsp_declaration", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
-- menu_add ("PopUp.Lsp_definition", "<Cmd>lua vim.lsp.buf.definition()<CR>")
-- menu_add('PopUp.LSP_Rename', '<cmd>lua vim.lsp.buf.rename()<cr>')
-- menu_add('PopUp.LSP_Format', '<cmd>lua vim.lsp.buf.format()<cr>')

-- menu_add(
--     'Diagnostic.Display_in_QF',
--     '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
-- )
-- menu_add(
--     'Diagnostic.Set_severity_to_warning',
--     '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
-- )
-- menu_add('Diagnostic.Set_severity_to_all', '<cmd>lua vim.diagnostic.config({virtual_text = { severity = nil }})<cr>')

-- menu_add_cmd('Search.Search_and_replace', "lua require('spectre').open()")
-- menu_add('Search.Test', 'let a=3')

-- menu_add("Search.Search\ in\ current\ Buffer", :Grepper -switch -buffer")
-- menu_add("Search.Search\ across\ Buffers :Grepper -switch -buffers")
-- menu_add("Search.Search\ across\ directory :Grepper")
-- menu_add("Search.Autoopen\ results :let g:grepper.open=1<CR>")
-- menu_add("Tabs.S2 :set  tabstop=2 softtabstop=2 sw=2<CR>")
-- menu_add("Tabs.S4 :set ts=4 sts=4 sw=4<CR>")
-- menu_add("Tabs.S6 :set ts=6 sts=6 sw=6<CR>")
-- menu_add("Tabs.S8 :set ts=8 sts=8 sw=8<CR>")
-- menu_add("Tabs.SwitchExpandTabs :set expandtab!")

-- menu_add("DAP.Add breakpoint", 'lua require"dap".toggle_breakpoint()')
-- menu_add("DAP.Continue", 'lua require"dap".continue()')
-- menu_add("DAP.Open repl", 'lua require"dap".repl.open()')

function open_contextual_menu()
	-- getcurpos()	Get the position of the cursor.  This is like getpos('.'), but
	--		includes an extra "curswant" in the list:
	--			[0, lnum, col, off, curswant] ~
	--		The "curswant" number is the preferred column when moving the
	--		cursor vertically.	Also see |getpos()|.
	--		The first "bufnum" item is always zero.

	local curpos = vim.fn.getcurpos()

	local menu_opts = {
		kind = 'menu',
		prompt = 'Main menu',
		experimental_mouse = true,
		position = {
			screenrow = curpos[2],
			screencol = curpos[3],
		},
		-- ignored
		-- width = 200,
		-- height = 300,
	}

	-- print('### ' ..res)
	require('stylish').ui_menu(vim.fn.menu_get(''), menu_opts, function(res)
		vim.cmd(res)
	end)
end

vim.opt.listchars = 'tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×'
-- set listchars+=conceal:X
-- conceal is used by deefault if cchar does not exit
vim.opt.listchars:append('conceal:❯')

-- "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
vim.g.netrw_home = vim.fn.stdpath('data') .. '/nvim'

vim.keymap.set('n', '<F11>', '<Plug>(ToggleListchars)')

vim.keymap.set('n', '<leader>q', '<Cmd>Sayonara!<cr>', { silent = true })
vim.keymap.set('n', '<leader>Q', '<Cmd>Sayonara<cr>', { silent = true })


vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'

map('n', '<Leader>$', '<Cmd>Obsession<CR>')

-- nvim will load any .nvimrc in the cwd; useful for per-project settings
vim.opt.exrc = true

-- hi CustomLineWarn guifg=#FD971F
-- command! JsonPretty %!jq '.'
vim.api.nvim_create_user_command('Htags', '!hasktags .', {})
vim.api.nvim_create_user_command('JsonPretty', "%!jq '.'", {})

-- taken from justinmk's config
vim.api.nvim_create_user_command(
	'Tags',
	[[
	!ctags -R --exclude='build*' --exclude='.vim-src/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *]]
	,
	{}
)

-- " Bye bye ex mode
-- noremap Q <NOP>

vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua open_contextual_menu()<CR>', { noremap = true, silent = false })

map('n', 'H', '^', {})
map('n', 'L', '$', {})

vim.api.nvim_set_keymap('n', ',a', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('v', ',,', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('n', ',,', '<Plug>(Luadev-RunLine)', { noremap = false, silent = false })

map('n', '<leader>rg', '<Cmd>Grepper -tool git -open -switch<CR>', { remap = true })
map('n', '<leader>rgb', '<Cmd>Grepper -tool rg -open -switch -buffer<CR>', { remap = true })
map('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>', { remap = true })

--
vim.filetype.add({
	extension = {
		http = "http",
		env = "env"

	},
	filename = {
		-- ['.env'] = 'env',
		-- ['.http'] = 'http'
	}
})

-- vim.keymap.set("n", "<Plug>HelloWorld", function() print("Hello World!") end)
-- vim.keymap.set("n", "gs", "<Plug>HelloWorld")

vim.api.nvim_set_keymap('n', ',a', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('v', ',,', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('n', ',,', '<Plug>(Luadev-RunLine)', { noremap = false, silent = false })

-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )
vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

require('teto.context_menu').setup_rclick_menu_autocommands()
require('teto.lsp').set_lsp_lines(true)
require('teto.rest')
require('teto.secrets')


-- commented out till https://github.com/ErikReider/SwayNotificationCenter/issues/323 gets implemented
-- require('teto.notify').override_vim_notify()

-- vim.g.sonokai_style = 'atlantis'
-- vim.cmd([[colorscheme sonokai]])
-- vim.cmd([[colorscheme rose-pine]])
-- vim.cmd([[colorscheme janah]])
-- vim.cmd([[colorscheme pywal]])
local theme = require('last-color').recall() or 'sonokai'
-- print("Setting colorscheme ", theme )
vim.cmd(('colorscheme %s'):format(theme))

-- https://github.com/neovim/neovim/issues/21856#issuecomment-1514723887
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.fn.jobstart('notify-send "closing nvim"', {detach=true})
  end,
})
