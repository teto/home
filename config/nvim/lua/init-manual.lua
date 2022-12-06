-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://www.reddit.com/r/neovim/comments/o8dlwg/how_to_append_to_an_option_in_lua/
-- local configs = require'nvim_lsp/configs'
local has_telescope, telescope = pcall(require, 'telescope')
local has_fzf_lua, _ = pcall(require, 'fzf-lua')

-- my treesitter config
local myMenu = require('teto.menu')

-- local packerCfg =
local packer = require('packer')
local use, _ = packer.use, packer.use_rocks
local nnoremap = vim.keymap.set
local map = vim.keymap.set

-- HOW TO TEST our fork of plenary
-- vim.opt.rtp:prepend(os.getenv("HOME").."/neovim/plenary.nvim")
-- local reload = require'plenary.reload'
-- reload.reload_module('plenary')
-- require'plenary'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.matchparen = 0
vim.g.mousemoveevent = 1

packer.init({
    autoremove = false,
})
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost /home/teto/config/nvim/init-manual.lua source <afile> | PackerCompile
--   augroup end
-- ]])
-- local function file_exists(name)
-- 	local f=io.open(name,"r")
-- 	if f~=nil then io.close(f) return true else return false end
-- end
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
vim.opt.termguicolors = true

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
vim.opt.diffopt:append('internal,algorithm:patience')

vim.opt.undofile = true
-- let undos persist across open/close
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo/'
vim.opt.sessionoptions:remove('terminal')
vim.opt.sessionoptions:remove('help')
--}}}

-- :tnoremap <Esc> <C-\><C-n>
map('t', '<Esc>', '<C-\\><C-n>')
-- nnoremap{ "n", "<C-N><C-N>", function () vim.opt.invnumber end }

-- clipboard {{{
-- X clipboard gets aliased to +
vim.opt.clipboard = 'unnamedplus'
-- copy to external clipboard
-- nnoremap({'n', 'gp', '"+p' })
-- nnoremap({'n', 'gy', '"+y' })
-- }}}

-- wildmenu completion
-- TODO must be number
-- vim.opt.wildchar=("<Tab>"):byte()
-- display a menu when need to complete a command
-- list:longest, " list breaks the pum
vim.opt.wildmode = { 'longest', 'list' } -- longest,list' => fills out longest then show list
-- set wildoptions+=pum

-- TODO ajouter sur le ticket nix
vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache') .. '/hoogle_cache.json'

vim.opt.wildmenu = true
-- vim.opt.omnifunc='v:lua.vim.lsp.omnifunc'
vim.opt.winbar = '%=%m %f'

-- lua vim.diagnostic.setqflist({open = tru, severity = { min = vim.diagnostic.severity.WARN } })
-- fugitive-gitlab {{{
-- also add our token for private repos
vim.g.fugitive_gitlab_domains = { 'https://git.novadiscovery.net' }
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

-- use {
--   -- Display marks for different kinds of decorations across the buffer. Builtin handlers include:
--   -- 'lewis6991/satellite.nvim',
--   config = function()
--     require('satellite').setup()
--   end
-- }
-- installed via nix
-- require('satellite').setup()
-- use {
--   "max397574/colortils.nvim",
--   -- cmd = "Colortils",
--   config = function()
--     require("colortils").setup()
--   end,
-- }

use {'shaunsingh/oxocarbon.nvim', branch = 'fennel'}
use { 'aloussase/scout', rtp = 'vim' }

-- use '~/neovim/fzf-lua' -- markdown syntax compatible with Github's
use('rhysd/vim-gfm-syntax') -- markdown syntax compatible with Github's
-- use 'symphorien/vim-nixhash' -- use :NixHash
-- use 'vim-denops/denops.vim'
-- use 'ryoppippi/bad-apple.vim' -- needs denops
-- use 'eugen0329/vim-esearch' -- search & replace
-- use 'kshenoy/vim-signature' -- display marks in gutter, love it

-- use '~/pdf-scribe.nvim'  -- to annotate pdf files from nvim :PdfScribeInit
-- PdfScribeInit
-- vim.g.pdfscribe_pdf_dir  = expand('$HOME').'/Nextcloud/papis_db'
-- vim.g.pdfscribe_notes_dir = expand('$HOME').'/Nextcloud/papis_db'
-- }}}

-- annotations plugins {{{
-- use 'MattesGroeger/vim-bookmarks' -- ruby  / :BookmarkAnnotate
-- 'wdicarlo/vim-notebook' -- last update in 2016
-- 'plutonly/vim-annotate-- --  last update in 2015
--}}}

use 'eandrju/cellular-automaton.nvim' -- :CellularAutomaton make_it_rain

-- use 'norcalli/nvim-terminal.lua' -- to display ANSI colors
-- use '~/neovim/nvim-terminal.lua' -- to display ANSI colors
use('bogado/file-line') -- to open a file at a specific line
-- use 'glacambre/firenvim' -- to use nvim in firefox
-- call :NR on a region than :w . coupled with b:nrrw_aucmd_create,
-- use 'chrisbra/NrrwRgn' -- to help with multi-ft files
use('chrisbra/vim-diff-enhanced') --


-- competition to potamides/pantran.nvim which uses just AI backends it seems
use({'uga-rosa/translate.nvim',
	config = function ()

	require("translate").setup({
		default = {
			command = "translate-shell",
		},
		preset = {
			output = {
				split = {
					append = true,
				},
			},
		},
	})
end})

use 'linty-org/readline.nvim'

-- to create anki cards
use 'rareitems/anki.nvim'


-- use ({
--   "jghauser/papis.nvim",
--   after = { "telescope.nvim", "nvim-cmp" },
--   requires = {
--     "kkharji/sqlite.lua",
--     "nvim-lua/plenary.nvim",
--     "MunifTanjim/nui.nvim",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   rocks = {
--     {
--       "lyaml"
--       -- If using macOS or Linux, you may need to install the `libyaml` package.
--       -- If you install libyaml with homebrew you will need to set the YAML_DIR
--       -- to the location of the homebrew installation of libyaml e.g.
--       -- env = { YAML_DIR = '/opt/homebrew/Cellar/libyaml/0.2.5/' },
--     }
--   },
--   config = function()
--     require("papis").setup(
--     -- Your configuration goes here
--     )
--   end,
-- })
-- use { 'ldelossa/gh.nvim',
--     requires = { { 'ldelossa/litee.nvim' } },
-- 	config = function ()
-- 		require('litee.lib').setup({
-- 			-- this is where you configure details about your panel, such as
-- 			-- whether it toggles on the left, right, top, or bottom.
-- 			-- leaving this blank will use the defaults.
-- 			-- reminder: gh.nvim uses litee.lib to implement core portions of its UI.
-- 		})
-- 		require('litee.gh').setup({
-- 			-- this is where you configure details about gh.nvim directly relating
-- 			-- to GitHub integration.
-- 		})

-- 	end
--   }
-- use 'rhysd/git-messenger.vim' -- to show git message :GitMessenger

-- use 'tweekmonster/nvim-api-viewer', {'on': 'NvimAPI'} -- see nvim api
-- provider

-- REPL (Read Execute Present Loop) {{{
-- use 'metakirby5/codi.vim', {'on': 'Codi'} -- repl
-- careful it maps cl by default
-- use 'jalvesaq/vimcmdline' -- no help files, mappings clunky
-- github mirror of use 'http://gitlab.com/HiPhish/repl.nvim'
-- use 'http://gitlab.com/HiPhish/repl.nvim' -- no commit for the past 2 years
--}}}
-- Snippets are separated from the engine. Add this if you want them:

-- " use 'justinmk/vim-gtfo' " gfo to open filemanager in cwd
-- " use 'wannesm/wmgraphviz.vim', {'for': 'dot'} " graphviz syntax highlighting
use('tpope/vim-rhubarb') -- github support in fugitive, use |i_CTRL-X_CTRL-O|
-- use {
--     'goolord/alpha-nvim',
--     requires = { 'kyazdani42/nvim-web-devicons' },
--     config = function ()
--         require'alpha'.setup(require'alpha.themes.startify'.config)
--     end
-- }
-- diagnostic
-- use { 'neovim/nvimdev.nvim', opt = true }
use({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        require('null-ls').setup({
            sources = {
                -- needs a luacheck in PATH
                require('null-ls').builtins.diagnostics.luacheck,
                -- require("null-ls").builtins.formatting.stylua,
                -- require("null-ls").builtins.diagnostics.eslint,
                -- require("null-ls").builtins.completion.spell,
            },
        })
    end,
})
use({
    'AckslD/nvim-FeMaco.lua',
    config = 'require("femaco").setup()',
})
-- use { 'folke/noice.nvim',
--   event = "VimEnter",
--   requires = { "rcarriga/nvim-notify" },
--   config = function()
-- 	local fakeColor = { fg='#000000', bg='#00FF00' }
-- 	vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', fakeColor)
-- 	vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderCmdline', fakeColor)

-- 	-- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
--     require("noice").setup({
--       cmdline = {
--         view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
--         opts = {
-- 			buf_options = {
-- 				-- filetype = "vim"
-- 			}
-- 		}, -- enable syntax highlighting in the cmdline
--         icons = {
--           ["/"] = { icon = " ", hl_group = "Normal" },
--           ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
--           [":"] = { icon = " ", hl_group = "DiagnosticInfo", firstc = false },
--         },
--       },
-- 	  lsp_progress ={
-- 		  enabled = true
-- 	  },
-- 	  popupmenu = {
-- 		  enabled = false;
-- 	  },
--       history = {
--         -- options for the message history that you get with `:Noice`
--         view = "split",
--         opts = { enter = true },
--         filter = { event = "msg_show", ["not"] = { kind = { "search_count", "echo" } } },
--       },
-- 	  -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
--       throttle = 1000 / 30,
--       views = {
--         -- cmdline = {
-- 		-- }
-- 		-- @see the section on views below
-- 		cmdline_popup = {
-- 			border = {
-- 				-- style = "none",
-- 				padding = { 2, 3 },
-- 			},
--         -- filter_options = {},
-- 			win_options = {
-- 				winhighlight = {
-- 					-- Normal = "NormalFloat",
-- 					-- FloatBorder = "NormalFloat",
-- 					-- Normal = "NoicePopupmenu", -- change to NormalFloat to make it look like other floats
-- 					-- FloatBorder = "NoicePopupmenuBorder", -- border highlight
-- 					-- CursorLine = "NoicePopupmenuSelected", -- used for highlighting the selected item
-- 					-- PmenuMatch = "NoicePopupmenuMatch", -- used to highlight the part of the item that matches the input
-- 				},
-- 			},
-- 			position = {
-- 				-- row = 5,
-- 				col = "50%",
-- 			},
-- 			size = {
-- 				width = 210,
-- 				-- height = "auto",
-- 				height = 3
-- 			},
-- 		},
-- 		popupmenu = {
-- 			relative = "editor",
-- 			position = {
-- 			row = 8,
-- 			col = "50%",
-- 			},
-- 			size = {
-- 			width = 60,
-- 			height = 10,
-- 			},
-- 			border = {
-- 			style = "rounded",
-- 			padding = { 0, 1 },
-- 			},
-- 			win_options = {
-- 			winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
-- 			},
-- 		},

-- 	  },
--       routes = {
-- 		-- skip search_count messages instead of showing them as virtual text
--           -- filter = { event = "msg_show", kind = "search_count" },
--           -- opts = { skip = true },
--       { -- shows @Recording message
--         view = "notify",
--         filter = { event = "msg_showmode" },
--       },
--       {
--         filter = {
--           event = "cmdline",
--           find = "^%s*[/?]",
--         },
--         view = "cmdline",
--       },
-- 	  {
--         filter = {
--           event = "msg_show",
--           kind = "",
--           find = "written",
--         },
--         opts = { skip = true },
--       },
-- 	  }, -- @see the section on routes below
--   })
--   end,
-- }
use({ 'seandewar/nvimesweeper', opt = true })
use({ 'voldikss/vim-translator', opt = true })
use('calvinchengx/vim-aftercolors') -- load after/colors
use('bfredl/nvim-luadev') -- lua repl :Luadev
-- use('alok/notational-fzf-vim') -- to take notes, :NV
-- use {
-- 	'hkupty/iron.nvim',
-- 	config = function ()
-- 		local iron = require("iron.core")
-- 		iron.setup {
-- 		config = {
-- 			-- If iron should expose `<plug>(...)` mappings for the plugins
-- 			should_map_plug = false,
-- 			-- Whether a repl should be discarded or not
-- 			scratch_repl = true,
-- 			-- Your repl definitions come here
-- 			repl_definition = {
-- 				sh = { command = {"zsh"} },
-- 				nix = { command = {"nix",  "repl", "/home/teto/nixpkgs"} },
-- 				-- copied from the nix wrapper :/
-- 				lua = { command = "/nix/store/snzm30m56ps3wkn24van553336a4yylh-luajit-2.1.0-2022-04-05-env/bin/lua"}
-- 			},
-- 			repl_open_cmd = require('iron.view').curry.bottom(40),
-- 			-- how the REPL window will be opened, the default is opening
-- 			-- a float window of height 40 at the bottom.
-- 		},
-- 		-- Iron doesn't set keymaps by default anymore. Set them here
-- 		-- or use `should_map_plug = true` and map from you vim files
-- 		keymaps = {
-- 			send_motion = "<space>sc",
-- 			visual_send = "<space>sc",
-- 			send_file = "<space>sf",
-- 			send_line = "<space>sl",
-- 			send_mark = "<space>sm",
-- 			mark_motion = "<space>mc",
-- 			mark_visual = "<space>mc",
-- 			remove_mark = "<space>md",
-- 			cr = "<space>s<cr>",
-- 			interrupt = "<space>s<space>",
-- 			exit = "<space>sq",
-- 			clear = "<space>cl",
-- 		},
-- 		-- If the highlight is on, you can change how it looks
-- 		-- For the available options, check nvim_set_hl
-- 		highlight = {
-- 			italic = true
-- 		}
-- 		}

-- 	end
-- }
-- use 'neovimhaskell/nvim-hs.vim' -- to help with nvim-hs
use('teto/vim-listchars') -- to cycle between different list/listchars configurations
use('chrisbra/csv.vim')
use('teto/Modeliner') -- <leader>ml to setup buffer modeline
-- " use 'antoinemadec/openrgb.nvim'  " to take into account RGB stuff

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

-- " use 'vhakulinen/gnvim-lsp' " load it only for gnvim

-- " use 'Rykka/riv.vim', {'for': 'rst'}
-- " use 'Rykka/InstantRst', {'for': 'rst'} " rst live preview with :InstantRst,
-- " use 'dhruvasagar/vim-table-mode', {'for': 'txt'}

-- " use 'mhinz/vim-rfc', { 'on': 'RFC' } " requires nokigiri gem
-- " careful maps F4 by default
-- use 'tpope/vim-unimpaired' " [<space> [e [n ]n pour gerer les conflits etc...
-- use 'tpope/vim-scriptease' " Adds command such as :Messages
-- use 'tpope/vim-eunuch' " {provides SudoEdit, SudoWrite , Unlink, Rename etc...
-- " use 'ludovicchabant/vim-gutentags' " automatic tag generation, very good
-- " use 'junegunn/limelight.vim' " focus writing :Limelight, works with goyo
-- " leader
-- " use 'bronson/vim-trailing-whitespace' " :FixWhitespace

vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'red' })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextDebug', { fg = 'green' })

-- http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>')

vim.keymap.set('n', '<Leader>ev', '<Cmd>e $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>el', '<Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>')
vim.keymap.set('n', '<Leader>em', '<Cmd>e ~/.config/nvim/lua/init-manual.vim<CR>')
vim.keymap.set('n', '<F6>', '<Cmd>ASToggle<CR>')

-- " set vim's cwd to current file's
-- nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

--  " when launching term
--   tnoremap <Esc> <C-\><C-n>

-- nnoremap <Leader>el <Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>
-- nnoremap <Leader>em <Cmd>e ~/.config/nvim/init.manual.vim<CR>
-- -- pb c'est qu'il l'autofocus
-- autocmd User LspDiagnosticsChanged lua vim.lsp.diagnostic.set_loclist( { open = false,  open_loclist = false})

-- command! LspStopAllClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())

vim.api.nvim_set_hl(0, 'SignifySignChange', {
    cterm = { bold = true },
    ctermbg = 237,
    ctermfg = 227,
    bg = 'NONE',
    fg = '#F08A1F',
})
vim.api.nvim_set_hl(
    0,
    'SignifySignAdd',
    { cterm = { bold = true }, ctermbg = 237, ctermfg = 227, bg = 'NONE', fg = 'green' }
)
vim.api.nvim_set_hl(
    0,
    'SignifySignDelete',
    { cterm = { bold = true }, ctermbg = 237, ctermfg = 227, bg = 'NONE', fg = 'red' }
)

-- This is the default extra key bindings
-- vim.g.fzf_action = { ['ctrl-t']: 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

-- Default fzf layout - down / up / left / right - window (nvim only)
vim.g.fzf_layout = { ['down'] = '~40%' }

-- For Commits and BCommits to customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
    end,
})
nnoremap('n', '<leader>ml', '<Cmd>Modeliner<Enter>')

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
		vim.api.nvim_set_hl(0, 'LspCodeLens', { italic=true })
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
-- rgb
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

-- display buffer name top-right
-- use {
-- 	"b0o/incline.nvim",
-- 	config = function ()
-- 		require('incline').setup()
-- 	end
-- }

-- use {
-- 	'norcalli/nvim-colorizer.lua',
-- 	config = function ()
-- 		require('colorizer').setup()
-- 	end
-- }

-- use {
-- 	-- a zenity picker for several stuff (colors etc)
-- 	'DougBeney/pickachu'
-- }

use('/home/teto/neovim/rest.nvim')
-- provides 'NvimTree'
use('kyazdani42/nvim-tree.lua')
use 'rhysd/committia.vim'
-- TODO package in nvim
use({
    'MrcJkb/haskell-tools.nvim',
    config = function()
        local ht = require('haskell-tools')
        ht.setup({
            tools = { -- haskell-tools options
                codeLens = {
                    -- Whether to automatically display/refresh codeLenses
                    autoRefresh = true,
                },
                -- hoogle = {
                --     -- 'auto': Choose a mode automatically, based on what is available.
                --     -- 'telescope-local': Force use of a local installation.
                --     -- 'telescope-web': The online version (depends on curl).
                --     -- 'browser': Open hoogle search in the default browser.
                --     mode = 'auto',
                -- }
				-- ,
				repl = {
					-- 'builtin': Use the simple builtin repl
					-- 'toggleterm': Use akinsho/toggleterm.nvim
					handler = 'builtin',
					builtin = {
						create_repl_window = function(view)
						-- create_repl_split | create_repl_vsplit | create_repl_tabnew | create_repl_cur_win
						return view.create_repl_split { size = vim.o.lines / 3 }
						end
					},
				},
            },
            hls = { -- LSP client options
                on_attach = function(client, bufnr)
                    local attach_cb = require('on_attach')
                    attach_cb.on_attach(client, bufnr)

                    -- haskell-language-server relies heavily on codeLenses,
                    -- so auto-refresh (see advanced configuration) is enabled by default
                    vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
                    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
                    -- vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
                    -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
                end,
                -- ...
                settings = { -- haskell-language-server options
					haskell = {
						formattingProvider = 'ormolu',
						checkProject = true, -- Setting this to true could have a performance impact on large mono repos.
						-- ...
						plugin = {
							refineImports = {
							codeActionsOn = true,
							codeLensOn = false,
							},
						},
					},
                },
            },
        })
    end,
})

-- defaults
-- use {
-- 	"~/telescope-frecency.nvim",
-- 	config = function ()
-- 		nnoremap ( "n", "<Leader>f", function () require('telescope').extensions.frecency.frecency({
-- 			query = "toto"
-- 		}) end )
-- 	end
-- 	}

-- use {
-- 	'VonHeikemen/fine-cmdline.nvim',
-- 	config = function ()
-- 	require('fine-cmdline').setup()
-- 	end
-- 	  -- requires = {
--     -- {'MunifTanjim/nui.nvim'}
--   -- }
-- }

-- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}


-- for quickreading: use :FSToggle to Toggle flow state
use({'nullchilly/fsread.nvim', config = function ()

	-- vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
	-- vim.g.skip_flow_default_hl = true -- If you want to override default highlights
	-- vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
	-- vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
end})

-- overrides vim.ui / vim.select with the backend of my choice
use({
    'stevearc/dressing.nvim',
    config = function()
        require('dressing').setup({
            input = {
                -- Default prompt string
                default_prompt = '➤ ',
                -- When true, <Esc> will close the modal
                insert_only = true,
                -- These are passed to nvim_open_win
                anchor = 'SW',
                relative = 'cursor',
                border = 'rounded',
                -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                prefer_width = 40,
                width = nil,
                -- min_width and max_width can be a list of mixed types.
                -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },

                -- see :help dressing_get_config
                get_config = nil,
            },
            mappings = {
                ['<C-c>'] = 'Close',
            },
            select = {
                -- Priority list of preferred vim.select implementations
                backend = { 'telescope', 'fzf', 'builtin', 'nui' },

                -- Options for fzf selector
                fzf = {
                    window = {
                        width = 0.5,
                        height = 0.4,
                    },
                },
                telescope = {
                    window = {
                        width = 0.5,
                        height = 0.4,
                    },
                },

                -- Options for nui Menu
                -- nui = {
                -- position = "50%",
                -- size = nil,
                -- relative = "editor",
                -- border = {
                -- style = "rounded",
                -- },
                -- max_width = 80,
                -- max_height = 40,
                -- },

                -- Options for built-in selector
                builtin = {
                    -- These are passed to nvim_open_win
                    anchor = 'NW',
                    relative = 'cursor',
                    border = 'rounded',

                    -- Window options
                    winblend = 10,

                    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- the min_ and max_ options can be a list of mixed types.
                    -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
                    width = nil,
                    max_width = { 140, 0.8 },
                    min_width = { 40, 0.2 },
                    height = nil,
                    max_height = 0.9,
                    min_height = { 10, 0.2 },
                },

                -- see :help dressing_get_config
                get_config = nil,
            },
        })
    end,
})

-- use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
-- use({
--	 "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
--	 as = "lsp_lines",
--	 config = function()

--	   require("lsp_lines").register_lsp_virtual_lines()
--	 end,
-- })

-- use 'mfussenegger/nvim-dap'
-- use {
--	"rcarriga/nvim-dap-ui"
--	, requires = {"mfussenegger/nvim-dap"}
-- }
-- use 'nvim-telescope/telescope-dap.nvim'
--

-- use {
-- 	-- set virtualedit=all, select an area then call :VBox
-- 	'jbyuki/venn.nvim'
-- 	}

-- use {

-- 	'rose-pine/neovim'
-- }
use({
    'rose-pine/neovim',
    as = 'rose-pine',
    tag = 'v1.*',
    -- config = function()
    -- end
})
-- use { 'protex/better-digraphs.nvim' }

use({
    'rcarriga/nvim-notify',
    config = function()
        require('notify').setup({
            -- Animation style (see below for details)
            stages = 'fade_in_slide_out',

            -- Function called when a new window is opened, use for changing win settings/config
            -- on_open = nil,
            -- Function called when a window is closed
            -- on_close = nil,
            -- Render function for notifications. See notify-render()
            -- render = "default",
            -- Default timeout for notifications
            timeout = 5000,
            -- Max number of columns for messages
            max_width = 300,
            -- Max number of lines for a message
            -- max_height = 50,

            -- For stages that change opacity this is treated as the highlight behind the window
            -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
            background_colour = 'Normal',

            -- Minimum width for notification windows
            minimum_width = 50,
        })

        vim.notify = require('notify')
    end,
})

-- terminal image viewer in neovim see https://github.com/edluffy/hologram.nvim#usage for usage
-- use 'edluffy/hologram.nvim' -- hologram-nvim
-- use 'ellisonleao/glow.nvim' -- markdown preview, run :Glow

-- use {
-- 	-- Show where your cursor moves
-- 	'edluffy/specs.nvim',
-- 	config = function ()
-- 		local specs = require 'specs'
-- 		specs.setup{
-- 			show_jumps	= true,
-- 			min_jump = 20,
-- 			popup = {
-- 				delay_ms = 0, -- delay before popup displays
-- 				inc_ms = 10, -- time increments used for fade/resize effects
-- 				blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
-- 				width = 30,
-- 				winhl = "PMenu",
-- 				fader = specs.linear_fader,
-- 				resizer = specs.shrink_resizer
-- 			},
-- 			ignore_filetypes = {},
-- 			ignore_buftypes = {
-- 				nofile = true,
-- 			},
-- 		}
-- 	end
-- }

-- use {
-- 	'code-biscuits/nvim-biscuits',
-- 	config = function ()
-- 	require('nvim-biscuits').setup({
-- 	on_events = { 'InsertLeave', 'CursorHoldI' },
-- 	cursor_line_only = true,
-- 	default_config = {
-- 		max_length = 12,
-- 		min_distance = 50,
-- 		prefix_string = " 📎 "
-- 	},
-- 	language_config = {
-- 		html = { prefix_string = " 🌐 " },
-- 		javascript = {
-- 			prefix_string = " ✨ ",
-- 			max_length = 80
-- 		},
-- 		python = { disabled = true },
-- 		-- nix = { disabled = true }
-- 	}
-- 	})
-- end
-- }

-- use { 'nvim-lua/popup.nvim'	}  -- mimic vim's popupapi for neovim

use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require('indent_blankline').setup({
            char = '│',
            buftype_exclude = { 'terminal' },
            filetype_exclude = { 'help' },
            space_char_blankline = ' ',
            show_end_of_line = true,
            char_highlight_list = {
                'IndentBlanklineIndent1',
                'IndentBlanklineIndent2',
                'IndentBlanklineIndent3',
                'IndentBlanklineIndent4',
                'IndentBlanklineIndent5',
                'IndentBlanklineIndent6',
            },
            max_indent_increase = 1,
            indent_level = 2,
            show_first_indent_level = false,
            -- blankline_use_treesitter,
            char_list = { '.', '|', '-' },
            show_trailing_blankline_indent = false,
            show_current_context = false,
            show_current_context_start = true,
            enabled = false,
        })
    end,
})
-- use {
-- 	-- shows type annotations for functions in virtual text using built-in LSP client
-- 	'jubnzv/virtual-types.nvim'
-- }

-- telescope plugins {{{
-- use({
--     '~/telescope.nvim',
--     requires = {
--         'nvim-telescope/telescope-github.nvim',
--         'nvim-telescope/telescope-symbols.nvim',
--         'nvim-telescope/telescope-fzy-native.nvim',
--         'nvim-telescope/telescope-media-files.nvim',
--         'nvim-telescope/telescope-packer.nvim', -- :Telescope pack,e
--         'MrcJkb/telescope-manix',   -- :Telescope manix
-- 		'luc-tielen/telescope_hoogle'
-- 		-- psiska/telescope-hoogle.nvim looks less advanced
--     },
-- })
--}}}

-- use "terrortylor/nvim-comment"
-- shows a lightbulb where a codeAction is available
-- use { 'kosayoda/nvim-lightbulb',
--	config = function ()
--		vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
--	end
-- }
-- using packer.nvim
use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

-- compete with registers.nvim
-- https://github.com/gelguy/wilder.nvim
-- use { 'gelguy/wilder.nvim' }
-- use { 'gennaro-tedesco/nvim-peekup' }
--use { 'TimUntersberger/neogit',
--	config = function ()
--		vim.defer_fn (
--		function ()
--		require 'neogit'.setup {
--		disable_signs = false,
--		disable_context_highlighting = false,
--		disable_commit_confirmation = false,
--		-- customize displayed signs
--		signs = {
--			-- { CLOSED, OPENED }
--			section = { ">", "v" },
--			item = { ">", "v" },
--			hunk = { "", "" },
--		},
--		integrations = {
--			-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs you can use `sindrets/diffview.nvim`.
--			-- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
--			--
--			-- Requires you to have `sindrets/diffview.nvim` installed.
--			-- use {
--			--	 'TimUntersberger/neogit',
--			--	 requires = {
--			--	   'nvim-lua/plenary.nvim',
--			--	   'sindrets/diffview.nvim'
--			--	 }
--			-- }
--			--
--			diffview = false
--		},
--		-- override/add mappings
--		mappings = {
--			-- modify status buffer mappings
--			status = {
--			-- Adds a mapping with "B" as key that does the "BranchPopup" command
--			["B"] = "BranchPopup",
--			-- Removes the default mapping of "s"
--			["s"] = "",
--			}
--		}

--	}
--end)
--end
--}

-- use { 'notomo/gesture.nvim' , opt = true; }
-- using teto instead to test packer luarocks support
-- use { "rktjmp/lush.nvim" }
use({
    'rktjmp/hotpot.nvim',
    config = function()
        require('hotpot').setup({
            -- allows you to call `(require :fennel)`.
            -- recommended you enable this unless you have another fennel in your path.
            -- you can always call `(require :hotpot.fennel)`.
            provide_require_fennel = false,
            -- show fennel compiler results in when editing fennel files
            enable_hotpot_diagnostics = true,
            -- compiler options are passed directly to the fennel compiler, see
            -- fennels own documentation for details.
            compiler = {
                -- options passed to fennel.compile for modules, defaults to {}
                modules = {
                    -- not default but recommended, align lua lines with fnl source
                    -- for more debuggable errors, but less readable lua.
                    -- correlate = true
                },
                -- options passed to fennel.compile for macros, defaults as shown
                macros = {
                    env = '_COMPILER', -- MUST be set along with any other options
                },
            },
        })
    end,
})

use({ 'alec-gibson/nvim-tetris', opt = true })

-- use { 'mfussenegger/nvim-dap'} -- debug adapter protocol
-- use {
-- 	-- a plugin for interacting with bazel :Bazel build //some/package:sometarget
-- 	-- supports autocompletion
-- 	'bazelbuild/vim-bazel' , requires = { 'google/vim-maktaba' }
-- }
use('bazelbuild/vim-ft-bzl')
use('PotatoesMaster/i3-vim-syntax')

-- colorschemes {{{
use('Matsuuu/pinkmare')
use('flrnd/candid.vim')
use('adlawson/vim-sorcerer')
use('whatyouhide/vim-gotham')
use('vim-scripts/Solarized')
-- use 'npxbr/gruvbox.nvim' " requires lush
use('romainl/flattened')
use('NLKNguyen/papercolor-theme')
use('marko-cerovac/material.nvim')
-- }}}

-- use 'anuvyklack/hydra.nvim' -- to create submodes
use('skywind3000/vim-quickui') -- to design cool uis
use('neovim/nvim-lspconfig') -- while fuzzing details out
-- use '~/neovim/nvim-lspconfig' -- while fuzzing details out

-- use 'vim-scripts/rfc-syntax' -- optional syntax highlighting for RFC files
-- use 'vim-scripts/coq-syntax'
use({ 'tweekmonster/startuptime.vim', opt = true }) -- {'on': 'StartupTime'} " see startup time per script

-- TODO upstream
--use {
--	'chipsenkbeil/distant.nvim'
--	, opt = true
--	, config = function()
--		require('distant').setup {
--		-- Applies Chip's personal settings to every machine you connect to
--		--
--		-- 1. Ensures that distant servers terminate with no connections
--		-- 2. Provides navigation bindings for remote directories
--		-- 3. Provides keybinding to jump into a remote file's parent directory
--		['*'] = require('distant.settings').chip_default()
--		}
--	end
--}
-- use {
-- 	'matbme/JABS.nvim',
-- 	config = function ()
-- 		require 'jabs'.setup {
-- 			position = 'center', -- center, corner
-- 			width = 50,
-- 			height = 10,
-- 			border = 'shadow', -- none, single, double, rounded, solid, shadow, (or an array or chars)

-- 			-- the options below are ignored when position = 'center'
-- 			col = 0,
-- 			row = 0,
-- 			anchor = 'NW', -- NW, NE, SW, SE
-- 			relative = 'win', -- editor, win, cursor
-- 		}
-- 	end
-- }

-- use {
--	'ggandor/lightspeed.nvim',
--	config = function ()
--		require'lightspeed'.setup {
--		-- This can get _really_ slow if the window has a lot of content,
--		-- turn it on only if your machine can always cope with it.
--		jump_to_unique_chars = false,
--		match_only_the_start_of_same_char_seqs = true,
--		limit_ft_matches = 5,
--		-- x_mode_prefix_key = '<c-x>',
--		substitute_chars = { ['\r'] = '¬' },
--		instant_repeat_fwd_key = nil,
--		instant_repeat_bwd_key = nil,
--		-- If no values are given, these will be set at runtime,
--		-- based on `jump_to_first_match`.
--		labels = nil,
--		cycle_group_fwd_key = nil,
--		cycle_group_bwd_key = nil,
--		}
--	end
-- }
-- use 'mrjones2014/dash.nvim' -- only for dash it seems
-- Trouble {{{
--use {
--  "folke/trouble.nvim",
----	 requires = "kyazdani42/nvim-web-devicons",
--	config = function ()

--	end
--}
-- }}}

 -- use {
	 -- 'kdheepak/tabline.nvim',
	 -- config = function()
	   -- require'tabline'.setup {
		 -- -- Defaults configuration options
		 -- enable = true,
		 -- show_filename_only = true,
		 -- show_devicons = false,
	   -- }
	   -- vim.cmd[[
		 -- set guioptions-=e " Use showtabline in gui vim
		 -- set sessionoptions+=tabpages,globals " store tabpages and globals in session
	   -- ]]
	 -- end,
	 -- requires = { { 'hoob3rt/lualine.nvim', opt=true }, 'kyazdani42/nvim-web-devicons' }
 -- }
use('MunifTanjim/nui.nvim') -- to create UIs
use('honza/vim-snippets')
-- use 'sjl/gundo.vim' " :GundoShow/Toggle to redo changes

-- use {
-- 	'hrsh7th/nvim-cmp',
-- -- use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
-- -- use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

-- 	requires = {
-- 		-- "quangnguyen30192/cmp-nvim-ultisnips",
-- 		'hrsh7th/cmp-buffer',
-- 		'hrsh7th/cmp-vsnip',
-- 		'hrsh7th/cmp-nvim-lsp',
-- 		'hrsh7th/vim-vsnip',
-- 		'hrsh7th/vim-vsnip-integ',
-- 		'rafamadriz/friendly-snippets'
-- 	},
-- 	config = function ()

local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
    use('michaeladler/cmp-notmuch')
    -- nvim-cmp autocompletion plugin{{{
    cmp.setup({
        snippet = {
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

vim.api.nvim_create_autocmd('MenuPopup', {
    callback = function()
        -- vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
		print("hello")
    end,
})


-- Load custom tree-sitter grammar for org filetype
-- orgmode depends on treesitter
local has_orgmode, orgmode = pcall(require, 'orgmode')
if has_orgmode then
    orgmode.setup_ts_grammar()
end

-- use {
--	   "nvim-neorg/neorg",
--	   config = function()
--		   require('neorg').setup {
--			   -- Tell Neorg what modules to load
--			   load = {
--				   ["core.defaults"] = {}, -- Load all the default modules
--				   ["core.keybinds"] = { -- Configure core.keybinds
--					   config = {
--						   default_keybinds = true, -- Generate the default keybinds
--						   neorg_leader = "<Leader>n" -- This is the default if unspecified
--					   }
--				   },
--				   ["core.norg.concealer"] = {}, -- Allows for use of icons
--				   ["core.norg.completion"] = {
--					config = {
--						engine =  "nvim-cmp"
--					}
--				}, -- Allows for use of icons
--				   ["core.norg.dirman"] = { -- Manage your directories with Neorg
--					   config = {
--						   workspaces = {
--							   my_workspace = "~/neorg"
--						   }
--					   }
--				   }
--			   },
--		   }
--	   end,
--	   requires = "nvim-lua/plenary.nvim"
-- }
use('ray-x/lsp_signature.nvim') -- display function signature in insert mode
-- use({
--     'Pocco81/AutoSave.nvim' -- :ASToggle /AsOn / AsOff
-- 	, config = function ()
-- 		local autosave = require("autosave")
-- 		autosave.setup({
-- 			enabled = true,
-- 			execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
-- 			events = { "FocusLost"}, -- "InsertLeave"
-- 			conditions = {
-- 				exists = true,
-- 				filetype_is_not = {},
-- 				modifiable = true
-- 			},
-- 			write_all_buffers = false,
-- 			on_off_commands = true,
-- 			clean_command_line_interval = 2500
-- 		}
-- 		)
--     end
-- })

-- use 'sindrets/diffview.nvim' -- :DiffviewOpen

-- lua require('github-notifications.menu').notifications()
-- use 'rlch/github-notifications.nvim'
use({
    'nvim-lualine/lualine.nvim', -- fork of hoob3rt/lualine
    requires = { 'arkav/lualine-lsp-progress' },
    config = function()
		require 'teto.lualine'
    end,
})

-- Inserts a component in lualine_c at left section
-- local function ins_left(component)
--	 table.insert(config.sections.lualine_c, component)
-- end

-- -- Inserts a component in lualine_x ot right section
-- local function ins_right(component)
--	 table.insert(config.sections.lualine_x, component)
-- end

-- shade currently broken
--local has_shade, shade = pcall(require, "shade")
--if has_shade then
--	shade.setup({
--		overlay_opacity = 70,
--		opacity_step = 1,
--		-- keys = {
--		--	 brightness_up	  = '<C-Up>',
--		--	 brightness_down  = '<C-Down>',
--		--	 toggle			  = '<Leader>s',
--		-- }
--	})
--end

-- use fzf to search through diagnostics
-- use { 'ojroques/nvim-lspfuzzy'}

-- for live editing
-- use { 'jbyuki/instant.nvim' }
-- use { 'jbyuki/nabla.nvim' } -- write latex equations in ASCII
-- use { 'jbyuki/monolithic.nvim' } -- write latex equations in ASCII

-- vim.g.sonokai_style = 'atlantis'
-- vim.cmd([[colorscheme sonokai]])
vim.cmd([[colorscheme janah]])
-- vim.cmd([[colorscheme pywal]])
--require'sniprun'.setup({
--  -- selected_interpreters = {'Python3_fifo'},        --" use those instead of the default for the current filetype
--  -- repl_enable = {'Python3_fifo', 'R_original'},    --" enable REPL-like behavior for the given interpreters
--  -- repl_disable = {},                               --" disable REPL-like behavior for the given interpreters
--  -- possible values are 'none', 'single', 'double', or 'shadow'
--  borders = 'single',
--  --" you can combo different display modes as desired
--  display = {
--    "Classic",                    -- "display results in the command-line  area
--    "VirtualTextOk",              -- "display ok results as virtual text (multiline is shortened)
--  },
--})

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'
-- ✓
vim.g.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

vim.g.should_show_diagnostics_in_statusline = true

-- code to toggle diagnostic display
local diagnostics_active = true
vim.keymap.set('n', '<leader>d', function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end)

if has_fzf_lua then
    require('teto.fzf-lua').register_keymaps()
    local fzf_history_dir = vim.fn.expand('~/.local/share/fzf-history')
    require('fzf-lua').setup({
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
elseif has_telescope then
    require('teto.telescope').telescope_create_keymaps()
end
-- nnoremap ( "n", "<Leader>ca", function () vim.lsp.buf.code_action{} end )
nnoremap('n', '<Leader>ca', function()
    vim.cmd([[ FzfLua lsp_code_actions]])
end)

-- nnoremap ( "n", "<leader>S",  function() require('spectre').open() end )

-- use 'folke/which-key.nvim' -- :WhichKey

local has_whichkey, wk = pcall(require, 'which-key')
if has_whichkey then
    wk.setup({
        -- plugins = {
        --	marks = true, -- shows a list of your marks on ' and `
        --	registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        --	-- the presets plugin, adds help for a bunch of default keybindings in Neovim
        --	-- No actual key bindings are created
        --	presets = {
        --	operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        --	motions = true, -- adds help for motions
        --	text_objects = true, -- help for text objects triggered after entering an operator
        --	windows = true, -- default bindings on <c-w>
        --	nav = true, -- misc bindings to work with windows
        --	z = true, -- bindings for folds, spelling and others prefixed with z
        --	g = true, -- bindings for prefixed with g
        --	},
        -- },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        -- operators = { gc = "Comments" },
        -- icons = {
        --	breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        --	separator = "➜", -- symbol used between a key and it's label
        --	group = "+", -- symbol prepended to a group
        -- },
        -- window = {
        --	border = "none", -- none, single, double, shadow
        --	position = "bottom", -- bottom, top
        --	margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        --	padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        -- },
        -- layout = {
        --	height = { min = 4, max = 25 }, -- min and max height of the columns
        --	width = { min = 20, max = 50 }, -- min and max width of the columns
        --	spacing = 3, -- spacing between columns
        -- },
        -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
        -- show_help = true, -- show help message on the command line when the popup is visible
        -- triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
    })
end

-- set tagfunc=v:lua.vim.lsp.tagfunc

-- since it was not merge yet


-- review locally github PRs
local has_octo, octo = pcall(require, 'octo')
if has_octo then
    octo.setup({
        default_remote = { 'upstream', 'origin' }, -- order to try remotes
        reaction_viewer_hint_icon = '', -- marker for user reactions
        user_icon = ' ', -- user icon
        timeline_marker = '', -- timeline marker
        timeline_indent = '2', -- timeline indentation
        right_bubble_delimiter = '', -- Bubble delimiter
        left_bubble_delimiter = '', -- Bubble delimiter
        github_hostname = '', -- GitHub Enterprise host
        snippet_context_lines = 4, -- number or lines around commented lines
        file_panel = {
            size = 10, -- changed files panel rows
            use_icons = true,					   -- use web-devicons in file panel
        },
        mappings = { --{{{
            issue = { --{{{
                close_issue = '<space>ic', -- close issue
                reopen_issue = '<space>io', -- reopen issue
                list_issues = '<space>il', -- list open issues on same repo
                reload = '<C-r>', -- reload issue
                open_in_browser = '<C-b>', -- open issue in browser
                copy_url = '<C-y>', -- copy url to system clipboard
                add_assignee = '<space>aa', -- add assignee
                remove_assignee = '<space>ad', -- remove assignee
                create_label = '<space>lc', -- create label
                add_label = '<space>la', -- add label
                remove_label = '<space>ld', -- remove label
                goto_issue = '<space>gi', -- navigate to a local repo issue
                add_comment = '<space>ca', -- add comment
                delete_comment = '<space>cd', -- delete comment
                next_comment = ']c', -- go to next comment
                prev_comment = '[c', -- go to previous comment
                react_hooray = '<space>rp', -- add/remove 🎉 reaction
                react_heart = '<space>rh', -- add/remove ❤️ reaction
                react_eyes = '<space>re', -- add/remove 👀 reaction
                react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
                react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
                react_rocket = '<space>rr', -- add/remove 🚀 reaction
                react_laugh = '<space>rl', -- add/remove 😄 reaction
                react_confused = '<space>rc', -- add/remove 😕 reaction
            }, --}}}
            pull_request = { --{{{
                checkout_pr = '<space>po', -- checkout PR
                merge_pr = '<space>pm', -- merge PR
                list_commits = '<space>pc', -- list PR commits
                list_changed_files = '<space>pf', -- list PR changed files
                show_pr_diff = '<space>pd', -- show PR diff
                add_reviewer = '<space>va', -- add reviewer
                remove_reviewer = '<space>vd', -- remove reviewer request
                close_issue = '<space>ic', -- close PR
                reopen_issue = '<space>io', -- reopen PR
                list_issues = '<space>il', -- list open issues on same repo
                reload = '<C-r>', -- reload PR
                open_in_browser = '<C-b>', -- open PR in browser
                copy_url = '<C-y>', -- copy url to system clipboard
                add_assignee = '<space>aa', -- add assignee
                remove_assignee = '<space>ad', -- remove assignee
                create_label = '<space>lc', -- create label
                add_label = '<space>la', -- add label
                remove_label = '<space>ld', -- remove label
                goto_issue = '<space>gi', -- navigate to a local repo issue
                add_comment = '<space>ca', -- add comment
                delete_comment = '<space>cd', -- delete comment
                next_comment = ']c', -- go to next comment
                prev_comment = '[c', -- go to previous comment
                react_hooray = '<space>rp', -- add/remove 🎉 reaction
                react_heart = '<space>rh', -- add/remove ❤️ reaction
                react_eyes = '<space>re', -- add/remove 👀 reaction
                react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
                react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
                react_rocket = '<space>rr', -- add/remove 🚀 reaction
                react_laugh = '<space>rl', -- add/remove 😄 reaction
                react_confused = '<space>rc', -- add/remove 😕 reaction
            }, --}}}
            review_thread = { --{{{
                goto_issue = '<space>gi', -- navigate to a local repo issue
                add_comment = '<space>ca', -- add comment
                add_suggestion = '<space>sa', -- add suggestion
                delete_comment = '<space>cd', -- delete comment
                next_comment = ']c', -- go to next comment
                prev_comment = '[c', -- go to previous comment
                select_next_entry = ']q', -- move to previous changed file
                select_prev_entry = '[q', -- move to next changed file
                close_review_tab = '<C-c>', -- close review tab
                react_hooray = '<space>rp', -- add/remove 🎉 reaction
                react_heart = '<space>rh', -- add/remove ❤️ reaction
                react_eyes = '<space>re', -- add/remove 👀 reaction
                react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
                react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
                react_rocket = '<space>rr', -- add/remove 🚀 reaction
                react_laugh = '<space>rl', -- add/remove 😄 reaction
                react_confused = '<space>rc', -- add/remove 😕 reaction
            }, --}}}
            submit_win = { --{{{
                approve_review = '<C-a>', -- approve review
                comment_review = '<C-m>', -- comment review
                request_changes = '<C-r>', -- request changes review
                close_review_tab = '<C-c>', -- close review tab
            }, --}}}
            review_diff = { --{{{
                add_review_comment = '<space>ca', -- add a new review comment
                add_review_suggestion = '<space>sa', -- add a new review suggestion
                focus_files = '<leader>e', -- move focus to changed file panel
                toggle_files = '<leader>b', -- hide/show changed files panel
                next_thread = ']t', -- move to next thread
                prev_thread = '[t', -- move to previous thread
                select_next_entry = ']q', -- move to previous changed file
                select_prev_entry = '[q', -- move to next changed file
                close_review_tab = '<C-c>', -- close review tab
                toggle_viewed = '<leader><space>', -- toggle viewer viewed state
            }, --}}}
            file_panel = { --{{{
                next_entry = 'j', -- move to next changed file
                prev_entry = 'k', -- move to previous changed file
                select_entry = '<cr>', -- show selected changed file diffs
                refresh_files = 'R', -- refresh changed files panel
                focus_files = '<leader>e', -- move focus to changed file panel
                toggle_files = '<leader>b', -- hide/show changed files panel
                select_next_entry = ']q', -- move to previous changed file
                select_prev_entry = '[q', -- move to next changed file
                close_review_tab = '<C-c>', -- close review tab
                toggle_viewed = '<leader><space>', -- toggle viewer viewed state
            },--}}}
        },--}}}
    })
end

-- inoremap <C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("i")<CR>
-- nnoremap { "n", "r<C-k><C-k>" , function () require'betterdigraphs'.digraphs("r") end}
-- vnoremap r<C-k><C-k> <ESC><Cmd>lua require'betterdigraphs'.digraphs("gvr")<CR>

-- local orig_ref_handler = vim.lsp.handlers['textDocument/references']
-- vim.lsp.handlers['textDocument/references'] = function(...)
--     orig_ref_handler(...)
--     vim.cmd([[ wincmd p ]])
-- end

-- require("urlview").setup({
--   picker = "default", -- "default" (vim.ui.select), "telescope" (telescope.nvim)
-- 	title = "URLs: ", -- prompt title
-- 	debug = true, -- logs user errors
-- })

local has_bufferline, bufferline = pcall(require, 'bufferline')
if has_bufferline then
	bufferline.setup{
		options = {
			view =	"default",
			numbers = "buffer_id",
			-- number_style = "superscript" | "",
			-- mappings = true,
			modified_icon = '●',
			close_icon = '',
			left_trunc_marker = '',
			right_trunc_marker = '',
			-- max_name_length = 18,
			-- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
			-- tab_size = 18,
			show_buffer_close_icons = false,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- -- can also be a table containing 2 custom separators
			-- -- [focused and unfocused]. eg: { '|', '|' }
			-- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
			separator_style = "slant",
			-- enforce_regular_tabs = false | true,
			always_show_bufferline = false,
			-- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
			-- -- add custom logic
			-- return buffer_a.modified > buffer_b.modified
			-- end
			hover = {
				enabled = true,
				delay = 200,
				reveal = {'close'}
			},
		}
	}
end

for i=1,9 do
	vim.keymap.set('n',  '<leader>'..tostring(i) , "<cmd>BufferLineGoToBuffer "..tostring(i).."<CR>", { silent = true})
end

-- nvim-colorizer {{{
require('terminal').setup()
-- }}}
use({
    'ethanholz/nvim-lastplace',
    config = function()
        require('nvim-lastplace').setup({
            lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
            lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
            lastplace_open_folds = true,
        })
    end,
})
vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath('config') .. '/snippets' }
vim.g.tex_flavor = 'latex'
-- Treesitter config {{{
--	'nvim-treesitter/completion-treesitter' " extension of completion-nvim,
-- use { 'nvim-treesitter/nvim-treesitter' }
local enable_treesitter = false
if enable_treesitter then
    -- use { 'nvim-treesitter/nvim-treesitter' }
    use({
        'nvim-treesitter/playground',
        requires = { 'nvim-treesitter/nvim-treesitter' },
    })
    -- use {
    -- 	'p00f/nvim-ts-rainbow',
    -- 	requires = { 'nvim-treesitter/nvim-treesitter' }
    -- }
    use({ 'nvim-treesitter/nvim-treesitter-textobjects' })
end
--}}}
-- my treesitter config
require('teto.treesitter')

-- telescope {{{
-- TODO check for telescope github extension too
if false then
    -- telescope.load_extension('ghcli')
    local actions = require('telescope.actions')
    local trouble = require('trouble')
    -- telescope.setup{}
    telescope.setup({
        defaults = {
            layout_config = {
                vertical = { width = 0.7 },
                -- other layout configuration here
            },
            mappings = {
                i = {
                    ['<c-t>'] = trouble.open_with_trouble,

                    -- 				-- -- To disable a keymap, put [map] = false
                    -- 				-- -- So, to not map "<C-n>", just put
                    -- 				-- ["<c-x>"] = false,
                    -- 				-- -- Otherwise, just set the mapping to the function that you want it to be.
                    -- 				-- ["<C-i>"] = actions.goto_file_selection_split,
                    -- 				-- -- Add up multiple actions
                    -- 				-- ["<CR>"] = actions.goto_file_selection_edit + actions.center,
                    -- 				-- -- You can perform as many actions in a row as you like
                    -- 				-- ["<CR>"] = actions.goto_file_selection_edit + actions.center + my_cool_custom_action,
                    ['<esc>'] = actions.close,
                },
                n = {
                    ['<C-t>'] = function(prompt_bufnr, _mode)
                        require('trouble.providers.telescope').open_with_trouble(prompt_bufnr, _mode)
                    end,
                    -- ["<c-t>"] = trouble.open_with_trouble,
                    ['<esc>'] = actions.close,
                },
            },
            -- 		vimgrep_arguments = {
            -- 		'rg',
            -- 		'--color=never',
            -- 		'--no-heading',
            -- 		'--with-filename',
            -- 		'--line-number',
            -- 		'--column',
            -- 		'--smart-case'
            -- 		},
            -- 		prompt_prefix = ">",
            -- 		scroll_strategy = "limit", -- or cycle
            -- 		selection_strategy = "reset",
            -- 		sorting_strategy = "descending",
            -- 		-- horizontal, vertical, center, flex
            -- 		layout_strategy = "horizontal",
            -- 		layout = {
            -- 			width = 0.75,
            -- 			prompt_position = "bottom",
            -- 		},

            -- 		file_ignore_patterns = {},
            -- 		-- get_generic_fuzzy_sorter not very good, doesn't select an exact match
            -- 		-- get_fzy_sorter
            -- 		-- https://github.com/nvim-telescope/telescope.nvim#sorters
            -- 		-- generic_sorter =  require'telescope.sorters'.get_levenshtein_sorter,
            -- 		generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
            -- 		file_sorter =  require'telescope.sorters'.get_fuzzy_file,
            -- 		shorten_path = false,
            -- 		path_display='smart',
            -- 		winblend = 0,
            -- 		-- preview_cutoff = 120,
            -- 		border = true,
            -- 		-- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
            -- 		color_devicons = true,
            -- 		-- use_less = true,
            -- 		-- file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
            -- 		-- grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
            -- 		-- qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

            -- 		-- Developer configurations: Not meant for general override
            -- 		-- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
        },
        extensions = {
            -- 		fzf = {
            -- 			fuzzy = true,					 -- false will only do exact matching
            -- 			override_generic_sorter = true, -- override the generic sorter
            -- 			override_file_sorter = true,	 -- override the file sorter
            -- 			case_mode = "smart_case",		 -- or "ignore_case" or "respect_case"
            -- 										-- the default case_mode is "smart_case"
            -- 		},
            -- 		fzy_native = {
            -- 			override_generic_sorter = false,
            -- 			override_file_sorter = false,
            -- 		},
            frecency = {
                -- 			-- workspaces = {
                -- 				-- ["home"]	= "/home/teto/home",
                -- 				-- ["data"]	= "/home/teto/neovim",
                -- 				-- ["jinko"]	= "/home/teto/jinko",
                -- 				-- -- ["wiki"]    = "/home/my_username/wiki"
                -- },
                -- show_scores = true,
                -- show_unindexed = true,
                -- ignore_patterns = {"*.git/*", "*/tmp/*"},
                db_safe_mode = true,
                auto_validate = false,
                -- devicons_disabled = true
            },
        },
    })
    -- This will load fzy_native and have it override the default file sorter
    -- telescope.load_extension('fzf')
    --jghauser/papis.nvim telescope.load_extension('fzy_native')
    -- telescope.load_extension("notify")
	telescope.load_extension('hoogle')
    telescope.load_extension('frecency')
    telescope.load_extension('manix')
	-- telescope.load_extension('scout')

    -- TODO add autocmd
    -- User TelescopePreviewerLoaded
end
--}}}

local contextMenu = function ()
    local choices = { 'choice 1', 'choice 2' }
    require('contextmenu').open(choices, {
        callback = function(chosen)
            print('Final choice ' .. choices[chosen])
        end,
    })
end
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
    -- disabled because too big in haskell
    virtual_lines = false,
    virtual_text = true,
    -- {
    -- severity = { min = vim.diagnostic.severity.WARN }
    -- },
    signs = true,
    severity_sort = true,
})

require('teto.lsp')

-- logs are written to /home/teto/.cache/vim-lsp.log
vim.lsp.set_log_level('info')

-- hack
local _, notifs = pcall(require, 'notifications')

vim.lsp.notifier = notifs

-- showLineDiagnostic is a wrapper around show_line_diagnostics
-- show_line_diagnostics calls open_floating_preview
-- local popup_bufnr, winnr = util.open_floating_preview(lines, 'plaintext')
-- seems like there is no way to pass options from show_line_diagnostics to open_floating_preview
-- the floating popup has "ownsyntax markdown"
function showLineDiagnostic()
    -- local opts = {
    --	enable_popup = true;
    --	-- options of
    --	popup_opts = {
    --	};
    -- }
    -- return vim.lsp.diagnostic.show_line_diagnostics()
    vim.diagnostic.goto_prev({ wrap = true })
    -- return require'lspsaga.diagnostic'.show_line_diagnostics()
end

-- to disable virtualtext check
-- follow https://www.reddit.com/r/neovim/comments/f8u6fz/lsp_query/fip91ww/?utm_source=share&utm_medium=web2x
-- vim.cmd [[autocmd CursorHold <buffer> lua showLineDiagnostic()]]
-- vim.cmd [[autocmd CursorMoved <buffer> lua showLineDiagnostic()]]
-- function lsp_show_all_diagnostics()
--	local all_diagnostics = vim.lsp.diagnostic.get_all()
--	vim.lsp.util.set_qflist(all_diagnostics)
-- end
vim.opt.background = 'light' -- or "light" for light mode

vim.opt.showbreak = '↳ ' -- displayed in front of wrapped lines

-- TODO add a command to select a ref (from telescope ?) and call Gitsigns change_base
-- afterwards

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

local menu_add, menu_add_cmd = myMenu.menu_add, myMenu.menu_add_cmd
menu_add('LSP.Declaration', '<cmd>lua vim.lsp.buf.declaration()<cr>')
menu_add('LSP.Definition', '<cmd>lua vim.lsp.buf.definition()<cr>')
menu_add('LSP.Hover', '<cmd>lua vim.lsp.buf.references()<cr>')
menu_add('LSP.Rename', '<cmd>lua vim.lsp.buf.rename()<cr>')
menu_add('LSP.Format', '<cmd>lua vim.lsp.buf.format()<cr>')

menu_add('Toggle.Minimap', '<cmd>MinimapToggle<cr>')
menu_add('Toggle.Obsession', '<cmd>Obsession<cr>')
menu_add('Toggle.Blanklines', '<cmd>IndentBlanklineToggle<cr>')
-- menu_add("Toggle.Biscuits", 'lua require("nvim-biscuits").toggle_biscuits()')

menu_add('REPL.Send line', [[<cmd>lua require'luadev'.exec(vim.api.nvim_get_current_line())<cr>]])
-- menu_add('REPL.Send selection ', 'call <SID>luadev_run_operator(v:true)')

menu_add ("PopUp.Lsp_declaration", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
menu_add ("PopUp.Lsp_definition", "<Cmd>lua vim.lsp.buf.definition()<CR>")
menu_add('PopUp.LSP_Rename', '<cmd>lua vim.lsp.buf.rename()<cr>')
menu_add('PopUp.LSP_Format', '<cmd>lua vim.lsp.buf.format()<cr>')

menu_add(
    'Diagnostic.Display_in_QF',
    '<cmd>lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })<cr>'
)
menu_add(
    'Diagnostic.Set_severity_to_warning',
    '<cmd>lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})<cr>'
)
menu_add('Diagnostic.Set_severity_to_all', '<cmd>lua vim.diagnostic.config({virtual_text = { severity = nil }})<cr>')

menu_add_cmd('Search.Search_and_replace', "lua require('spectre').open()")
menu_add('Search.Test', 'let a=3')

menu_add('Rest.RunRequest', "<cmd>lua require('rest-nvim').run(true)<cr>")

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

local function open_contextual_menu()
    -- getcurpos()	Get the position of the cursor.  This is like getpos('.'), but
    --		includes an extra "curswant" in the list:
    --			[0, lnum, col, off, curswant] ~
    --		The "curswant" number is the preferred column when moving the
    --		cursor vertically.	Also see |getpos()|.
    --		The first "bufnum" item is always zero.

    local curpos = vim.fn.getcurpos()

    menu_opts = {
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

-- quickui {{{
-- https://github.com/skywind3000/vim-quickui
-- TODO should be printed only if available
vim.g.quickui_border_style = 1
-- content = {
--             \ ['LSP -'],
--             \ ["Goto &Definition\t\\cd", 'lua vim.lsp.buf.definition()'],
--             \ ["Goto &Declaration\t\\cd", 'lua vim.lsp.buf.declaration()'],
--             \ ["Goto I&mplementation\t\\cd", 'lua vim.lsp.buf.implementation()'],
--             \ ["Hover\t\\ch", 'lua vim.lsp.buf.references()'],
--             \ ["Search &References\t\\cr", 'lua vim.lsp.buf.references()'],
--             \ ["Document  &Symbols\t\\cr", 'lua vim.lsp.buf.document_symbol()'],
--             \ ["Format", 'lua vim.lsp.buf.formatting_sync(nil, 1000)'],
--             \ ["&Execute  Command\\ce", 'lua vim.lsp.buf.execute_command()'],
--             \ ["&Incoming calls\\ci", 'lua vim.lsp.buf.incoming_calls()'],
--             \ ["&Outgoing calls\\ci", 'lua vim.lsp.buf.outgoing_calls()'],
--             \ ["&Signature help\\ci", 'lua vim.lsp.buf.signature_help()'],
--             \ ["&Workspace symbol\\cw", 'lua vim.lsp.buf.workspace_symbol()'],
--             \ ["&Rename\\cw", 'lua vim.lsp.buf.rename()'],
--             \ ["&Code action\\cw", 'lua vim.lsp.buf.code_action()'],
--             \ ['- Diagnostic '],
--             \ ['Display in QF', 'lua vim.diagnostic.setqflist({open = true, severity = { min = vim.diagnostic.severity.WARN } })'],
-- 	    \ ['Set severity to warning', 'lua vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }})'],
-- 	    \ ['Set severity to all', 'lua vim.diagnostic.config({virtual_text = { severity = nil }})'],
--             \ ['- Misc '],
--             \ ['Toggle indentlines', 'IndentBlanklineToggle!'],
--             \ ['Start search and replace', 'lua require("spectre").open()'],
--             \ ['Toggle obsession', 'Obsession'],
--             \ ['Toggle minimap', 'MinimapToggle'],
--             \ ['Toggle biscuits', 'lua require("nvim-biscuits").toggle_biscuits()'],
--             \ ['REPL - '],
--             \ ['Send line ', 'lua require''luadev''.exec(vim.api.nvim_get_current_line())'],
--             \ ['Send selection ', 'call <SID>luadev_run_operator(v:true)'],
-- 	    \ ['DAP -'],
-- 	    \ ['Add breakpoint', 'lua require"dap".toggle_breakpoint()'],
-- 	    \ ["Continue", 'lua require"dap".continue()'],
-- 	    \ ['Open REPL', 'lua require"dap".repl.open()']
--             \ }

-- " formatting_sync
-- " set cursor to the last position
-- let quick_opts = {'index':g:quickui#context#cursor}

-- " TODO map to lua create_menu()
-- map <RightMouse>  <Cmd>call quickui#context#open(content, quick_opts)<CR>
-- vim.keymap.set('n',  '<RightMouse>', '<Cmd>lua open_contextual_menu()<CR>' )

-- " can't click on it plus it disappears
-- " map <RightMouse>  <Cmd>lua create_menu()<CR>
-- }}}
vim.keymap.set('n', '<F11>', '<Plug>(ToggleListchars)')

vim.keymap.set('n', '<leader>pi', '<cmd>PackerInstall<CR>')
vim.keymap.set('n', '<leader>pu', '<cmd>PackerSync<CR>')

vim.keymap.set('n', '<leader>q', '<Cmd>Sayonara!<cr>', { silent = true })
vim.keymap.set('n', '<leader>Q', '<Cmd>Sayonara<cr>', { silent = true })

vim.keymap.set('n', '<leader>rr', '<Plug>RestNvim<cr>', { remap = true, desc = 'Run an http request' })
vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { remap = true, desc = 'Preview an http request' })
-- vim.keymap.set('n',  '<C-j>' , "<use>RestNvimPreview")
-- nnoremap <use>RestNvimPreview :lua require('rest-nvim').run(true)<CR>
-- nnoremap <use>RestNvimLast :lua require('rest-nvim').last()<CR>

-- repl.nvim (from hiphish) {{{
-- vim.g.repl['lua'] = {
--     \ 'bin': 'lua',
--     \ 'args': [],
--     \ 'syntax': '',
--     \ 'title': 'Lua REPL'
-- \ }
-- Send the text of a motion to the REPL
-- nmap <leader>rs  <Plug>(ReplSend)
-- -- Send the current line to the REPL
-- nmap <leader>rss <Plug>(ReplSendLine)
-- nmap <leader>rs_ <Plug>(ReplSendLine)
-- -- Send the selected text to the REPL
-- vmap <leader>rs  <Plug>(ReplSend)
-- }}}

-- alok/notational-fzf-vim {{{
-- use c-x to create the note
-- vim.g.nv_search_paths = []
vim.g.nv_search_paths = { '~/Nextcloud/Notes' }
vim.g.nv_default_extension = '.md'
vim.g.nv_show_preview = 1
vim.g.nv_create_note_key = 'ctrl-x'

-- String. Default is first directory found in `g:nv_search_paths`. Error thrown
--if no directory found and g:nv_main_directory is not specified
--vim.g.nv_main_directory = g:nv_main_directory or (first directory in g:nv_search_paths)
--}}}

vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'

map('n', '<Leader>$', '<Cmd>Obsession<CR>')

-- nvimdev {{{
-- call nvimdev#init(--path/to/neovim--)
vim.g.nvimdev_auto_init = 1
vim.g.nvimdev_auto_cd = 1
-- vim.g.nvimdev_auto_ctags=1
vim.g.nvimdev_auto_lint = 1
vim.g.nvimdev_build_readonly = 1
--}}}

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
	!ctags -R --exclude='build*' --exclude='.vim-src/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *]],
    {}
)

-- " Bye bye ex mode
-- noremap Q <NOP>

vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua open_contextual_menu()<CR>', { noremap = true, silent = false })

vim.cmd([[
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
]])

-- dadbod UI sql connections
-- let g:db_ui_winwidth = 30
-- dadbod is controllable via DBUI
vim.g.dbs = {
    dev = 'sqlite:///home/teto/nova/jinko3/core-platform-db/db.sqlite',
}

-- luadev mappings
-- https://github.com/bfredl/nvim-luadev
-- for i=1,2 do
-- 	print("hello: "..tostring(i))
-- end

vim.api.nvim_set_keymap('n', ',a', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('v', ',,', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('n', ',,', '<Plug>(Luadev-RunLine)', { noremap = false, silent = false })

map('n', '<leader>rg', '<Cmd>Grepper -tool git -open -switch<CR>', { remap = true })
map('n', '<leader>rgb', '<Cmd>Grepper -tool rg -open -switch -buffer<CR>', { remap = true })
map('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>', { remap = true })

-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )
vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

require 'teto.context_menu'.setup_rclick_menu_autocommands()
