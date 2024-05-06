-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://www.reddit.com/r/neovim/comments/o8dlwg/how_to_append_to_an_option_in_lua/
-- local configs = require'nvim_lsp/configs'
-- vim.loader.enable()
-- showcmdloc
local has_fzf_lua, fzf_lua = pcall(require, 'fzf-lua')

-- set to true to enable it
local use_fzf_lua  = has_fzf_lua and false
local use_telescope = not use_fzf_lua
local use_org = true
local use_neorg = false
local has_luasnip, ls = pcall(require, 'luasnip')
local use_luasnip = has_luasnip and true


local has_gitsigns, gitsigns = pcall(require, 'gitsigns')

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

vim.g.loaded_matchit = 1 
vim.opt.shortmess:append("I")
vim.opt.foldlevel = 99
vim.opt.mousemoveevent = true

---  set guicursor as a red block in normal mode

-- workaround slow neovim https://github.com/neovim/neovim/issues/23725
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
	-- disable lsp watcher. Too slow on linux
	wf._watchfunc = function()
	return function() end
	end
end

--
vim.filetype.add({
	extension = {
		http = "http",
		env = "env",
		kbd = "kbd",
		v = "coq"

	},
	filename = {
		['wscript'] =  'python',
		['.env'] = 'env',
		-- ['.http'] = 'http'
	}
})


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
vim.opt.smoothscroll = true
vim.opt.colorcolumn = { 100 }
vim.opt.termguicolors = true

-- that's where treesitter installs grammars
vim.opt.rtp:prepend('/home/teto/parsers')
vim.opt.rtp:prepend(lazypath)
-- vim.opt.rtp:prepend("/home/teto/rocks.nvim")

-- set it before loading vim plugins like autosession
-- ,localoptions
vim.o.sessionoptions="buffers,curdir,help,tabpages,winsize,winpos"
-- vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

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
            "matchit",
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
--[[
Mouse configuration: 
https://github.com/neovim/neovim/issues/14921

]]--
vim.opt.mousemodel = 'popup_setpos'
-- vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua open_contextual_menu()<CR>', { noremap = true, silent = false })
require('teto.context_menu').setup_rclick_menu_autocommands()

-- MenuPopup
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
	callback = function(_args)
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

-- f3 to show tree
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>')

require'teto.rest-nvim'

-- TODO I should get the same 
-- neorg config{{{

if use_neorg then
	local neorg = require'teto.neorg'
	neorg.setup()
	neorg.setup_mappings()
	vim.api.nvim_create_user_command('Notes', function()
		vim.cmd(":Neorg workspace notes")
		end, {
		desc = 'Opens my neorg notes.',
		})

end
-- }}}

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

-- " use 'mhinz/vim-rfc', { 'on': 'RFC' } " requires nokigiri gem
-- " careful maps F4 by default
-- " use 'bronson/vim-trailing-whitespace' " :FixWhitespace

-- TODO this should depend on theme ! computed via lush
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'red' })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextDebug', { fg = 'green' })

-- http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>', {desc="Focus alternate buffer"})

vim.keymap.set('n', '<Leader>ev', '<Cmd>e $MYVIMRC<CR>', {desc="Edit home-manager's generated neovim config"})
vim.keymap.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>', { desc = "Reload my neovim config"})
vim.keymap.set('n', '<Leader>el', '<Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>')
vim.keymap.set('n', '<F6>', '<Cmd>ASToggle<CR>', { desc = "Toggle autosave"})

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

vim.api.nvim_create_autocmd('ColorScheme', {
	desc = "Set italic codelens on new colorschemes",
	callback = function()
		-- TODO create a TextYankPost highlight if it doesn't exist in scheme ?!
		vim.api.nvim_set_hl(0, 'LspCodeLens', { italic = true })
	end,
})

vim.api.nvim_set_hl(0, 'LspCodeLens', { bg = "red" })
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
	cmp_sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
		-- { name = "cmp-dbee" },
	}
    if use_neorg then
		table.insert(cmp_sources, { name = 'neorg' })
	end
    if use_org then
		table.insert(cmp_sources, { name = 'orgmode' })
	end
	if use_luasnip then
			-- For luasnip user.
			-- " Plug 'saadparwaiz1/cmp_luasnip'
		table.insert(cmp_sources, { name = 'luasnip' })
    end

	--[[
	:CmpStatus
	]]
	cmp.setup({

		-- https://github.com/hrsh7th/nvim-cmp/issues/1747
		enabled = function()
			-- return vim.g.cmptoggle
			return true
		end,
		completion = {
			-- autocomplete = true
			-- local types = require('cmp.types')
			-- autocomplete is on by default and it should only be a trigger event array or false
			autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
		},
		view = {
			entries = "custom" -- can be "custom", "wildmenu" or "native"
		},
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
				-- For `vsnip` user. broken
				-- vim.fn['vsnip#anonymous'](args.body)

				-- For `luasnip` user.
				require('luasnip').lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
		}),
		-- mapping = cmp.mapping.preset.insert({

		-- 	['<C-d>'] = cmp.mapping.scroll_docs(-4),
		-- 	['<C-f>'] = cmp.mapping.scroll_docs(4),
		-- 	--   ['<C-Space>'] = cmp.mapping.complete(),
		-- 	--   ['<C-e>'] = cmp.mapping.close(),
		-- 	['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- }),
		-- view = {
		-- 	entries = 'native'
		-- },
		sources = cmp_sources,
	    window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
	})

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
	-- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      { name = 'git' }, 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline({ '/', '?' }, {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = 'buffer' }
  --   }
  -- })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline(':', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })
	--  }}}
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
	vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', { silent = true, desc = "Run code (pending operator)";})
	vim.api.nvim_set_keymap('n', '<leader>ff', '<Plug>SnipRun', { silent = true, desc = "Run some code"})
end

-- add description
-- lua require("nvim-treesitter.parsers").reset_cache();
vim.api.nvim_set_keymap('n', '<f3>', '<cmd>lua vim.treesitter.inspect_tree()<cr>', {})
vim.api.nvim_set_keymap('n', '<f5>', '<cmd>!make build', { desc = "Run make build"})

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'

-- ✓
vim.g.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

-- vim.g.should_show_diagnostics_in_statusline = true


-- vim.ui.select
-- gotten from https://github.com/ibhagwan/fzf-lua/wiki#ui-select-auto-size
fzf_lua.register_ui_select(function(_, items)
  local min_h, max_h = 0.15, 0.70
  local h = (#items + 4) / vim.o.lines
  if h < min_h then
    h = min_h
  elseif h > max_h then
    h = max_h
  end

  local dopreview = vim.o.columns > 200
  local hidden = 'hidden'
  if dopreview then
	  hidden = 'nohidden'
  end
  return {
	winopts = {
	  height = h, width = 0.80, row = 0.40,

	  preview = {
		  hidden = hidden,
	  }
  	}
  }
end)

if use_fzf_lua then

	-- require('fzf-lua.providers.ui_select').register({})

	require('teto.fzf-lua').register_keymaps()
	local fzf_history_dir = vim.fn.expand('~/.local/share/fzf-history')
	fzf_lua.setup({
		'default-title', 
		defaults = { formatter = 'path.filename_first' } ,
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
				-- Only used with the builtin previewer:
				title          = true,            -- preview border title (file/buf)?
				title_pos      = "left",        -- left|center|right, title alignment
				scrollbar      = 'float',         -- `false` or string:'float|border'
													-- float:  in-window floating border
													-- border: in-border chars (see below)
				scrolloff      = '-2',            -- float scrollbar offset from right
													-- applies only when scrollbar = 'float'
				scrollchars    = {'█', '' },      -- scrollbar chars ({ <full>, <empty> }
			},
			layout = 'flex'
		},
	})
end

if use_telescope then

	local tts = require('teto.telescope')
	-- if we want to use telescope
	tts.setup()
	tts.telescope_create_keymaps()
end


-- local use_gp = true
-- if use_gp then

-- 	local my_gp = require('teto.gp')
-- 	-- if we want to use telescope
-- 	my_gp.Translator(gp)
-- end

-- since it was not merge yet
-- inoremap <C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("i")<CR>
-- nnoremap { "n", "r<C-k><C-k>" , function () require'betterdigraphs'.digraphs("r") end}
-- vnoremap r<C-k><C-k> <ESC><Cmd>lua require'betterdigraphs'.digraphs("gvr")<CR>

local has_bufferline, bufferline = pcall(require, 'bufferline')
if has_bufferline then
	-- check :h bufferline-configuration
	bufferline.setup({
		highlights = {},

		options = {
			mode = 'buffers',
			themable = true,
			-- buffer_close_icon = '',

			numbers = 'buffer_id', -- 'ordinal' ?
			indicator = {
				style = "underline"
			},
			view = 'default',
			-- number_style = "superscript" | "",
			-- mappings = true,
			modified_icon = '●',
			close_icon = '',
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
			color_icons = true , -- whether or not to add the filetype icon highlights
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
			separator_style = 'thick',
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

require('teto.treesitter')
-- local available, config = pcall(require, 'nvim-treesitter.configs')



require('teto.lspconfig')

-- vim.lsp.set_log_level('DEBUG')

-- setup haskell-tools
vim.g.haskell_tools = require'teto.haskell-tools'.generate_settings()

-- iron.nvim repl configuration {{{
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
				haskell = {
				  command = function(meta)
					local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
					-- call `require` in case iron is set up before haskell-tools
					return require('haskell-tools').repl.mk_repl_cmd(file)
				  end,
				},
			},
			-- repl_open_cmd = require('iron.view').left(200),
			repl_open_cmd = view.split.vertical.botright(0.4)
			-- how the REPL window will be opened, the default is opening
			-- a float window of height 40 at the bottom.
		},
	})
	require'teto.iron'
                -- Iron doesn't set keymaps by default anymore. Set them here
                -- or use `should_map_plug = true` and map from you vim files
                -- keymaps = {
                --     send_motion = '<space>sc',
                --     visual_send = '<space>sc',
                --     send_file = '<space>sf',
                --     send_line = '<space>sl',
                --     send_mark = '<space>sm',
                --     mark_motion = '<space>mc',
                --     mark_visual = '<space>mc',
                --     remove_mark = '<space>md',
                --     cr = '<space>s<cr>',
                --     interrupt = '<space>s<space>',
                --     exit = '<space>sq',
                --     clear = '<space>cl',
                -- },

end
-- }}}
vim.opt.background = 'light' -- or "light" for light mode

vim.opt.showbreak = '↳ ' -- displayed in front of wrapped lines

-- TODO add a command to select a ref  and call Gitsigns change_base afterwards

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])


vim.opt.listchars = 'tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×'
-- set listchars+=conceal:X
-- conceal is used by deefault if cchar does not exit
vim.opt.listchars:append('conceal:❯')

-- "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
vim.g.netrw_home = vim.fn.stdpath('data') .. '/nvim'

vim.keymap.set('n', '<F11>', '<Plug>(ToggleListchars)', 
	{ desc = "Change between different flavors of space/tab characters" })

vim.keymap.set('n', '<leader>q', '<Cmd>Sayonara!<cr>', { silent = true, desc = "Closes current window"})
vim.keymap.set('n', '<leader>Q', '<Cmd>Sayonara<cr>', 
	{ silent = true, desc = "Close current window, no question asked" })


-- vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'

-- used to be obsession
map('n', '<Leader>$', '<Cmd>SessionSave<CR>')

-- nvim will load any .nvimrc in the cwd; useful for per-project settings
vim.opt.exrc = true

-- hi CustomLineWarn guifg=#FD971F
-- command! JsonPretty %!jq '.'
vim.api.nvim_create_user_command('Htags', '!hasktags .', { desc = "Regenerate tags"})
vim.api.nvim_create_user_command('JsonPretty', "%!jq '.'", { desc = "Prettify json"})

-- taken from justinmk's config
vim.api.nvim_create_user_command(
	'Tags',
	[[
	!ctags -R --exclude='build*' --exclude='.vim-src/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *]]
	,
	{}
)

if use_luasnip then
	-- debug with :LuaSnipListAvailable
	vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true, desc="Invoke luasnip"})
	vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
	vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

	-- |"warn"|"info"|"debug")
	ls.log.set_loglevel("debug")
	-- ls.log.ping()

	vim.keymap.set({"i", "s"}, "<C-E>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, {silent = true})

	-- ls.add_snippets(filetype, snippets)
	-- require("luasnip-snippets").load_snippets()
	-- require("luasnip.loaders").edit_snippet_files(opts:table|nil)
	-- 
	-- require("luasnip.loaders.from_lua").load()

	-- loads lua files
	require("luasnip.loaders.from_lua").lazy_load(
		{ paths = { vim.fn.stdpath("config") .."/snippets"} }
	)

	-- loads json(c) files if there is a package.json
	require("luasnip.loaders.from_vscode").lazy_load(
		{ paths = { vim.fn.stdpath("config") .."/snippets"} }

	)

	local snip = ls.snippet
	local s = ls.snippet
	local sn = ls.snippet_node
	local t = ls.text_node
	local func = ls.function_node
	local i = ls.insert_node
	local f = ls.function_node
	-- local c = ls.choice_node
	-- local d = ls.dynamic_node
	-- local r = ls.restore_node

	-- require("luasnip.loaders.from_vscode").lazy_load()
	ls.config.setup {}


	-- see also :h haskell-snippets
	-- needs a treesitter grammar
	local haskell_snippets = require('haskell-snippets').all
	ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
	local date = function() return {os.date('%Y-%m-%d')} end
	ls.add_snippets(nil, {
		all = {
			snip({
				trig = "date",
				namr = "Date",
				dscr = "Date in the form of YYYY-MM-DD",
			}, {
				func(date, {}),
			}),
		},
		sh = {
			snip("shebang", {
				t { "#!/bin/sh", "" },
				i(0),
			}),
		},
    -- python = {
    --     snip("shebang", {
    --         t { "#!/usr/bin/env python", "" },
    --         i(0),
    --     }),
    -- },

	})

	-- ls.add_snippets("lua", {
	-- 	-- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
	-- 	s("fn", {
	-- 		-- Simple static text.
	-- 		t("//Parameters: "),
	-- 		-- function, first parameter is the function, second the Placeholders
	-- 		-- whose text it gets as input.
	-- 		-- f(copy, 2),
	-- 		t({ "", "function " }),
	-- 		-- Placeholder/Insert.
	-- 		i(1),
	-- 		t("("),
	-- 		-- Placeholder with initial text.
	-- 		i(2, "int foo"),
	-- 		-- Linebreak
	-- 		t({ ") {", "\t" }),
	-- 		-- Last Placeholder, exit Point of the snippet.
	-- 		i(0),
	-- 		t({ "", "}" }),
	-- 	}),
	-- })

    require("luasnip.loaders.from_lua").load({paths = {vim.fn.stdpath("config").."/snippets"}})


end

-- " Bye bye ex mode
-- noremap Q <NOP>

map('n', 'H', '^', {})
map('n', 'L', '$', {})

vim.api.nvim_set_keymap('n', ',a', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('v', ',,', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('n', ',,', '<Plug>(Luadev-RunLine)', { noremap = false, silent = false })

map('n', '<leader>rg', '<Cmd>Grepper -tool git -open -switch<CR>', { remap = true })
map('n', '<leader>rgb', '<Cmd>Grepper -tool rg -open -switch -buffer<CR>', { remap = true })
map('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>', { remap = true })

-- vim.keymap.set("n", "<Plug>HelloWorld", function() print("Hello World!") end)
-- vim.keymap.set("n", "gs", "<Plug>HelloWorld")

-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )
vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

require('teto.lsp').set_lsp_lines(true)
require('teto.rest')
require('teto.secrets')

if has_gitsigns then
	local tgitsigns = require'teto.gitsigns'
	tgitsigns.setup()
end

-- commented out till https://github.com/ErikReider/SwayNotificationCenter/issues/323 gets implemented
local teto_notify = require('teto.notify')
if teto_notify.should_use_provider() then
	teto_notify.override_vim_notify()
end

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
    -- vim.fn.jobstart('notify-send "closing nvim"', {detach=true})
    vim.fn.jobstart('sleep 2', {detach=true})
  end,
})


local has_cloak, cloak = pcall(require, 'cloak')
if has_cloak then
cloak.setup({
  enabled = false,
  cloak_character = '*',
  -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
  highlight_group = 'Comment',
  -- Applies the length of the replacement characters for all matched
  -- patterns, defaults to the length of the matched pattern.
  cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
  -- Whether it should try every pattern to find the best fit or stop after the first.
  try_all_patterns = true,
  patterns = {
    {
      -- Match any file starting with '.env'.
      -- This can be a table to match multiple file patterns.
      file_pattern = '.env*',
      -- Match an equals sign and any character after it.
      -- This can also be a table of patterns to cloak,
      -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
      cloak_pattern = '=.+',
      -- A function, table or string to generate the replacement.
      -- The actual replacement will contain the 'cloak_character'
      -- where it doesn't cover the original text.
      -- If left empty the legacy behavior of keeping the first character is retained.
      replace = nil,
    },
  },
})
end

vim.keymap.set('n', '[w', function()
	vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN })
end, { buffer = true })
vim.keymap.set('n', ']w', function()
	vim.diagnostic.goto_next({ wrap = true , severity = vim.diagnostic.severity.WARN })
end, { buffer = true })


vim.opt.runtimepath:prepend('/home/teto/neovim/nvim-dbee')

local has_dbee, dbee = pcall(require, 'dbee')
if has_dbee then
	dbee.setup({})
end

local has_ollama, ollama = pcall(require, 'ollama')
if has_ollama then
	ollama.setup({})
end
