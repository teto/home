-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://www.reddit.com/r/neovim/comments/o8dlwg/how_to_append_to_an_option_in_lua/
-- local configs = require'nvim_lsp/configs'
-- vim.loader.enable(true)
-- showcmdloc
-- require('avante_lib').load()
--
--
--
-- https://www.reddit.com/r/neovim/comments/1kcz8un/great_improvements_to_the_cmdline_in_nightly/
-- require('vim._extui').enable({})
-- vim.g.visual_whitespace = {
--   enabled = true,
--   highlight = { link = "Visual", default = true },
--   match_types = {
--     space = true,
--     tab = true,
--     nbsp = true,
--     lead = false,
--     trail = false,
--   },
--   list_chars = {
--     space = "·",
--     tab = "↦",
--     nbsp = "␣",
--     lead = "‹",
--     trail = "›",
--   },
--   fileformat_chars = {
--     unix = "↲",
--     mac = "←",
--     dos = "↙",
--   },
--   ignore = { filetypes = {}, buftypes = {} },
-- }

-- print(package.cpath)

local has_fzf_lua, _fzf_lua = pcall(require, 'fzf-lua')

-- set to true to enable it
local use_fzf_lua = has_fzf_lua and true
local use_telescope = not use_fzf_lua

local map = vim.keymap.set

local valid_file, nix_deps = pcall(require, 'generated-by-nix')
if not valid_file then
    error('Invalid generated-by-nix')
end
vim.g.rikai = {
    kanjidb = nix_deps.edict_kanjidb,
    jmdictdb = nix_deps.edict_expressiondb,
    log_level = vim.log.levels.DEBUG,
    separator = '===>>>',
    popup = {},
}

-- new option
vim.o.winborder = 'rounded'

diagnostic_default_config = {
    -- disabled because too big in haskell
    virtual_lines = {
        current_line = true,
        -- Function that can transform the diagnostic
        -- format = if
    },
    virtual_text = {
        source = 'if_many',
        -- • {format}?             (`fun(diagnostic:vim.Diagnostic): string?`) If
        --                       not nil, the return value is the text used to
        --                       display the diagnostic. Example: >lua
        --                           function(diagnostic)
        --                             if diagnostic.severity == vim.diagnostic.severity.ERROR then
        --                               return string.format("E: %s", diagnostic.message)
        --                             end
        --                             return diagnostic.message
        --                           end
        --
    },
    {
        severity = { min = vim.diagnostic.severity.WARN },
    },
    signs = {
        severity = { min = vim.diagnostic.severity.WARN },
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
    severity_sort = true,

    -- TODO how to add borders ?
    float = {
        source = true,
        severity_sort = true,
        border = 'rounded',
    },
    update_in_insert = true,
}

vim.diagnostic.config(diagnostic_default_config)

vim.g.rest_nvim = {
    request = {
        skip_ssl_verification = true,
    },
    env = {
        enable = false,
    },
    ui = {
        winbar = true,
    },
}

-- 	-- Open request results in a horizontal split
-- 	-- Skip SSL verification, useful for unknown certificates
-- 	-- engine = 'classic',
-- 	-- parser = 'treesitter',
-- 	-- Highlight request on run
-- 	highlight = {
-- 		-- enabled = true,
-- 		timeout = 150,
-- 	},
-- })
--
--
-- -- TODO remove once it's merged upstream
-- vim.api.nvim_create_user_command('RestLog', function()
--   vim.cmd(string.format('tabnew %s', vim.fn.stdpath('cache')..'/rest.nvim.log'))
-- end, {
--   desc = 'Opens the rest.nvim log.',
-- })

-- this should not be needed anymore
-- vim.cmd([[sign define DiagnosticSignError text=✘ texthl=LspDiagnosticsSignError linehl= numhl=]])
-- vim.cmd([[sign define DiagnosticSignWarning text=！ texthl=LspDiagnosticsSignWarning linehl= numhl=CustomLineWarn]])
-- vim.cmd(
--     [[sign define DiagnosticSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=CustomLineWarn]]
-- )
-- vim.cmd([[sign define DiagnosticSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=]])

-- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- TODO remove in favor of the generated one
-- vim.g.sqlite_clib_path = nix_deps.sqlite_clib_path

-- set it before loading vim plugins like autosession
-- ,localoptions
vim.o.sessionoptions = 'buffers,curdir,help,tabpages,winsize,winpos,localoptions'

-- fixing some stuff
vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/avante.nvim')
-- doing jj tests
vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/diffview.nvim')
-- vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/rocks-dev.nvim')
vim.opt.rtp:prepend(os.getenv('HOME') .. '/rocks.nvim')

-- require("vim.lsp._watchfiles")._watchfunc = require("vim._watch").watch
-- local ffi = require 'ffi'
local custom_luarocks_config_filename = vim.fn.stdpath('config') .. '/luarocks-config-generated.lua'
-- print("Loading custom luarocks config from: "..custom_luarocks_config_filename)
local luarocks_config_fn, errmsg = loadfile(custom_luarocks_config_filename)

if luarocks_config_fn == nil then
    print('Could not load ' .. errmsg)
end

-- function
-- print(tostring(luarocks_config_fn))
-- vim.print(tostring(luarocks_config_fn()))
vim.g.rocks_nvim = {
    -- TODO reference one from
    -- use nix_deps.luarocks_executable
    -- coming from nixpkgs
    -- TODO removing this generates errors at runtime :'(
    luarocks_binary = nix_deps.luarocks_executable,
    -- /home/teto/.local/share/nvim/rocks/luarocks-config.lua
    luarocks_config = luarocks_config_fn(),
    _log_level = vim.log.levels.TRACE,

    -- checkout constants.DEFAULT_DEV_SERVERS
    servers = { 'https://luarocks.org/manifests/neorocks/' },

    lazy = true, -- for cleaner logs
    -- rocks.nvim config
    treesitter = {
        auto_highlight = {},
        auto_install = 'prompt',
        parser_map = {},
        ---@type string[] | fun(lang: string, bufnr: integer):boolean

        -- filetypes or a function
        disable = {
            'lhaskell',
        },
    },
}

-- local has_avante, avante_mod = pcall(require, 'avante')
-- if has_avante then
--     require('avante_lib').load()
--     avante_mod.setup({
--         -- Your config here!
--     })
-- end

-- TODO prefix with gp_defaults.
-- local defaults = require('gp.defaults')
--
-- local chat_system_prompt = defaults.chat_system_prompt

vim.g.loaded_matchit = 1

vim.opt.shortmess:append('I')
vim.opt.foldlevel = 99
vim.opt.mousemoveevent = true

vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- this in nightly
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    },
    root_markers = { '.git' },
})

-- workaround slow neovim https://github.com/neovim/neovim/issues/23725
local ok, wf = pcall(require, 'vim.lsp._watchfiles')
if ok then
    -- disable lsp watcher. Too slow on linux
    wf._watchfunc = function()
        return function() end
    end
end

--
vim.filetype.add({
    extension = {
        http = 'http',
        env = 'env',
        kbd = 'kbd',
        v = 'coq',
        -- ignore some big files from nixpkgs like all-packages.nix ? seems to already be done somewhere else
        -- nix = function(path, bufnr)
        --     return true
        -- end
    },
    filename = {
        ['wscript'] = 'python',
        ['.env'] = 'env',
        -- todo add for my ssh configs as well
        -- ['.http'] = 'http'
    },
    pattern = {
        ['.*/.env.*'] = 'env',
    },
})

-- undocumented like --luamod-dev
-- vim.g.__ts_debug = 10

-- vim.cmd([[packloadall ]])
-- HOW TO TEST our fork of plenary
-- vim.opt.rtp:prepend(os.getenv("HOME").."/neovim/plenary.nvim")
-- local reload = require'plenary.reload'
-- reload.reload_module('plenary')
-- require'plenary'
vim.g.matchparen = 1
vim.g.mousemoveevent = 1 -- must be setup before calling lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.colorcolumn = { 100 }

-- that's where treesitter installs grammars
vim.opt.rtp:prepend('/home/teto/parsers')

-- lazy/config.lua sets vim.go.loadplugins = false so I used to run packloadall to restore those plugins
-- but there seems to be a bug somewhere as overriding VIMRUNTIME would then be dismissed and it would used
-- whatever VIMRUNTIME, even an old one ? so there is some cache invalidation issue somewhere ?
-- this is a quickfix that works around lazyplugins issue but I need to find the rootcause
-- vim.go.loadplugins = true

-- main config {{{
-- vim.opt.splitbelow = true	-- on horizontal splits
vim.opt.splitright = true -- on vertical split

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

]]
--

-- vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua open_contextual_menu()<CR>', { noremap = true, silent = false })
require('teto.context_menu').setup_rclick_menu_autocommands()

-- MenuPopup
vim.opt.signcolumn = 'auto:1-3'

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
vim.opt.diffopt:append('linematch:60')

vim.opt.undofile = true
-- let undos persist across open/close
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo/'
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
-- vim.opt.pumborder = "rounded"
-- set wildoptions+=pum

vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache') .. '/hoogle_cache.json'

vim.opt.wildmenu = true
-- vim.opt.omnifunc='v:lua.vim.lsp.omnifunc'
-- navic counts on documentSymbols
-- %=%m %f

-- sh -c "lua -e 'dofile [[%]] print(description.homepage)' | xdg-open"

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Attach lsp_signature on new client',
    callback = function(args)
        -- print("Called matt's on_attach autocmd")
        if not (args.data and args.data.client_id) then
            return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        local on_attach = require('teto.on_attach')

        -- dont attach in diffmode
        if vim.wo.diff then
            vim.schedule(function()
                vim.lsp.stop_client(client.id)
            end)
            return
        end
        on_attach.on_attach(client, bufnr)

        -- if client:supports_method('textDocument/implementation') then
        --   -- Create a keymap for vim.lsp.buf.implementation
        -- end

        if client:supports_method('textDocument/completion') then
            -- Enable auto-completion
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- require'lsp_signature'.on_attach(client, bufnr)
    end,
})

-- vim.api.nvim_create_autocmd('VimLeave', {
--     desc = 'test to fix stacktrace',
--     callback = function(_args) end,
-- })
--
function string:endswith(ending)
    return ending == '' or self:sub(-#ending) == ending
end

-- vim.api.nvim_create_autocmd('BufRead', {
--     desc = 'Disable syntax on big files',
--     callback = function(args)
--         -- print("autocmd BufRead cb", args.file)
--         if args.file:endswith('pkgs/development/haskell-modules/hackage-packages.nix') then
--             -- print("autocmd BufRead cb", args.file)
--             -- print("DISABLING syntax")
--             vim.cmd([[setlocal syntax=off]])
--         end
--     end,
-- })

-- fugitive-gitlab {{{
-- also add our token for private repos
-- }}}
-- set guicursor="n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor"
vim.opt.guicursor =
    'n-v-c:block-blinkon250-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-blinkon250-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- highl Cursor ctermfg=16 ctermbg=253 guifg=#000000 guibg=#00FF00
-- vim.api.nvim_set_hl(0, 'Cursor', { ctermfg = 16, ctermbg = 253, fg = '#000000', bg = '#00FF00' })
-- vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'None', bg = '#293739' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'grey' })

-- local my_image = require('hologram.image'):new({
--	   source = '/home/teto/doctor.png',
--	   row = 11,
--	   col = 0,
-- })
-- my_image:transmit() -- send image data to terminal

-- f3 to show tree
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>')

-- customizations for rest
-- require('teto.rest')

-- Snippets are separated from the engine. Add this if you want them:

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

-- TODO this should depend on theme ! computed via lush
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Set italic codelens on new colorschemes',
    callback = function()
        local bgcol = vim.api.nvim_get_hl(0, { name = 'Normal' })
        local c = require('colortils')
        local utils = require('colortils.utils.colors')
        local hl_normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
        -- local
        -- TODO use teto.colors
        -- utils.get_grey(hl_normal.bg)

        vim.api.nvim_set_hl(0, 'LspCodeLens', { italic = true, bg = 'blue' })
        vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'red' })
        vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextDebug', { fg = 'green' })

        -- autocmd ColorScheme *
        --       \ highlight Comment gui=italic
        --       \ | highlight Search gui=underline
        --       \ | highlight MatchParen guibg=NONE guifg=NONE gui=underline
        vim.cmd.packadd('gitsigns.nvim')
    end,
})

-- http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>', { desc = 'Focus alternate buffer' })

vim.keymap.set('n', '<Leader>ev', '<Cmd>e $MYVIMRC<CR>', { desc = "Edit home-manager's generated neovim config" })
vim.keymap.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>', { desc = 'Reload my neovim config' })
vim.keymap.set('n', '<Leader>el', '<Cmd>e ~/.config/nvim/lua/init-manual.lua<CR>')
vim.keymap.set('n', '<F6>', '<Cmd>ASToggle<CR>', { desc = 'Toggle autosave' })

vim.g.autosave_disable_inside_paths = { vim.fn.stdpath('config') }

--  when launching term
--   tnoremap <Esc> <C-\><C-n>

-- This is the default extra key bindings
-- vim.g.fzf_action = { ['ctrl-t']: 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

-- Default fzf layout - down / up / left / right - window (nvim only)
vim.g.fzf_layout = { ['down'] = '~40%' }

-- For Commits and BCommits to customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- " auto reload vim config on save
-- " Watch for changes to vimrc
-- " augroup myvimrc
-- "   au!
-- "   au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
-- " augroup END

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
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*.jsonzlib',
    callback = function()
        -- " autocmd BufReadPre *.jsonzlib %!pigz -dc "%" - | jq '.'
        print('MATCHED JSONZLIB PATTERN')
    end,
})

vim.api.nvim_create_user_command('ViewChunk', function()
    vim.cmd('!view_json %')
end, {
    desc = 'View nova chunk file',
})

-- local verbose_output = false
-- require("tealmaker").build_all(verbose_output)

local has_sniprun, sniprun = pcall(require, 'sniprun')

if has_sniprun then
    require('plugins.sniprun')
end

-- add description
-- vim.api.nvim_set_keymap('n', '<f5>', '<cmd>!make build', { desc = 'Run make build' })

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'

-- ✓
vim.g.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

if use_fzf_lua then
    require('plugins.fzf-lua')
    -- else frecency doesnt appear
    local has_fzf_lua_frecency, fzf_lua_frecency = pcall(require, 'fzf-lua-frecency')

    if has_fzf_lua_frecency then
        fzf_lua_frecency.setup({
            cwd_only = true,
            -- all_files = nil,
            stat_file = true,
            display_score = true,
            fzf_opts = {
                ['--multi'] = true,
                -- ,begin
                ['--tiebreak'] = 'length,chunk',

                -- ["--scheme"] = "path",
                -- ["--no-sort"] = true,
            },
        })
    end
    require('teto.fzf-lua').register_keymaps()
end

if use_telescope then
    local tts = require('teto.telescope')
    -- if we want to use telescope
    tts.setup()
    tts.telescope_create_keymaps()
end

-- since it was not merge yet
-- inoremap <C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("i")<CR>
-- nnoremap { "n", "r<C-k><C-k>" , function () require'betterdigraphs'.digraphs("r") end}
-- vnoremap r<C-k><C-k> <ESC><Cmd>lua require'betterdigraphs'.digraphs("gvr")<CR>

-- local has_bufferline, bufferline = pcall(require, 'bufferline')
-- if has_bufferline then
-- 	-- check :h bufferline-configuration
-- end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.gitlab-ci*.{yml,yaml}',
    callback = function()
        vim.bo.filetype = 'yaml.gitlab'
    end,
})

vim.g.tex_flavor = 'latex'

-- should not be required anymore since plugins/nvim-treesitter.lua is called
-- require('teto.treesitter')
-- vim.lsp.set_log_level('DEBUG')
vim.lsp.log.set_level(vim.lsp.log_levels.INFO)
-- setup haskell-tools
vim.g.haskell_tools = require('teto.haskell-tools').generate_settings()

-- vim.opt.background = 'light' -- or "light" for light mode
vim.opt.showbreak = '↳ ' -- displayed in front of wrapped lines

-- TODO add a command to select a ref  and call Gitsigns change_base afterwards

-- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

vim.opt.listchars = 'tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×'
-- set listchars+=conceal:X
-- conceal is used by deefault if cchar does not exit
vim.opt.listchars:append('conceal:❯')

-- "set shada=!,'50,<1000,s100,:0,n$XDG_CACHE_HOME/nvim/shada
-- vim.g.netrw_home = vim.fn.stdpath('data') .. '/nvim'

vim.keymap.set(
    'n',
    '<F11>',
    '<Plug>(ToggleListchars)',
    { desc = 'Change between different flavors of space/tab characters' }
)

-- nvim will load any .nvimrc in the cwd; useful for per-project settings
vim.opt.exrc = true

-- hi CustomLineWarn guifg=#FD971F
-- command! JsonPretty %!jq '.'
vim.api.nvim_create_user_command('Htags', '!hasktags .', { desc = 'Regenerate tags' })
vim.api.nvim_create_user_command('JsonPretty', "%!jq '.'", { desc = 'Prettify json' })

-- taken from justinmk's config
vim.api.nvim_create_user_command(
    'Tags',
    [[
	!ctags -R --exclude='build*' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='*.json' --exclude='qgis/**' *]],
    {}
)

-- " Bye bye ex mode
-- noremap Q <NOP>

map('n', 'H', '^', {})
map('n', 'L', '$', {})

vim.api.nvim_set_keymap('n', ',a', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('v', ',,', '<Plug>(Luadev-Run)', { noremap = false, silent = false })
vim.api.nvim_set_keymap('n', ',,', '<Plug>(Luadev-RunLine)', { noremap = false, silent = false })

vim.keymap.set('n', '<leader>rg', '<Cmd>Grepper -tool git -open -switch<CR>', { remap = true })
vim.keymap.set('n', '<leader>rgb', '<Cmd>Grepper -tool rg -open -switch -buffer<CR>', { remap = true })
vim.keymap.set('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>', { remap = true })

-- vim.keymap.set("n", "<Plug>HelloWorld", function() print("Hello World!") end)
-- vim.keymap.set("n", "gs", "<Plug>HelloWorld")

-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )

local has_secrets, secrets = pcall(require, 'teto.secrets')

-- if has_gitsigns then
--     local tgitsigns = require('plugins.gitsigns')
--     tgitsigns.setup()
-- end

-- commented out till https://github.com/ErikReider/SwayNotificationCenter/issues/323 gets implemented
local teto_notify = require('teto.notify')
if teto_notify.should_use_provider() then
    teto_notify.override_vim_notify()
end

-- same for e ?
-- vim.keymap.set('n', '[w', function()
--     vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN })
-- end, {})
-- vim.keymap.set('n', ']w', function()
--     vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.WARN })
-- end, {})

-- TODO add a set E for across buffers moved to on_attach
-- vim.keymap.set('n', '[e', function()
--     vim.diagnostic.jump({ count = -1, float = true, wrap = true, severity = vim.diagnostic.severity.ERROR })
-- end, { buffer = true })
-- vim.keymap.set('n', ']e', function()
--     vim.diagnostic.jump({ count = 1, wrap = true, severity = vim.diagnostic.severity.ERROR })
-- end, { buffer = true })

-- vim.opt.runtimepath:prepend('/home/teto/neovim/nvim-dbee')
-- local has_dbee, dbee = pcall(require, 'dbee')
-- if has_dbee then
--     dbee.setup({})
-- end

vim.opt.completeopt = 'preview,menu,menuone,noselect'
-- wait:5000, wrong idea
vim.opt.messagesopt = 'hit-enter,history:500'

-- pasted from :help terminal-scrollback-pager
vim.api.nvim_create_user_command('TermHl', function()
    local b = vim.api.nvim_create_buf(false, true)
    local chan = vim.api.nvim_open_term(b, {})
    vim.api.nvim_chan_send(chan, table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
    vim.api.nvim_win_set_buf(0, b)
end, { desc = 'Highlights ANSI termcodes in curbuf' })

-- because it's installed via nix due to its rust dependencies, we have to call it manually
require('plugins.blink-cmp')

local b64 = require('teto.b64')

vim.keymap.set('v', '<leader>b', function() end)
vim.keymap.set('v', '<leader>B', '<Plug>(ToBase64)')

-- vim.keymap.set('c', '<c-a>', '<c-y>', { })

-- used to avoid ftetect on those
-- :let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\)$'

-- Key mapping to apply Base64 encoding to selected text
vim.api.nvim_set_keymap(
    'v',
    '<leader>be',
    [[:lua apply_function_to_selection(base64_encode)<CR>]],
    { noremap = true, silent = true }
)

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, 'LspReferenceTarget', {})
    end,
})

-- 0 is kinda buggy with confirm and so on
vim.opt.cmdheight = 1

-- for indentblankline
require('plugins.nvim-treesitter-textobjects')
-- autoloaded
-- require('plugins.nvim-treesitter')

-- one can pass a list as well
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('yamlls')
vim.lsp.enable('just')

-- testing packadd
vim.pack.add({
    -- my real neovim package manager (with nix)
    'https://github.com/nvim-neorocks/rocks.nvim',

    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/teto/vim-listchars',
	'https://github.com/yutkat/git-rebase-auto-diff.nvim',

    -- themes
    'https://github.com/adlawson/vim-sorcerer',
    'https://github.com/Matsuuu/pinkmare',
    'https://github.com/rose-pine/neovim',
	'https://github.com/marko-cerovac/material.nvim',
	'https://github.com/NLKNguyen/papercolor-theme',
	'https://github.com/vim-scripts/Solarized',

    -- filetypes
    'https://github.com/PotatoesMaster/i3-vim-syntax',
	'https://github.com/overleaf/vim-env-syntax',

	-- fennel testing
	-- 'https://github.com/aileot/nvim-thyme'
	'https://github.com/calvinchengx/vim-aftercolors',
	'https://github.com/raddari/last-color.nvim',
})

-- wont work if last-color is not installed
local theme = require('last-color').recall() or 'sonokai'
-- print("Setting colorscheme ", theme )
vim.cmd(('colorscheme %s'):format(theme))

-- Autoload from everything lsp/ in rtp
-- local configs = {}
--
-- for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
--   local name = vim.fn.fnamemodify(v, ':t:r')
--   configs[name] = true
-- end
--
-- vim.lsp.enable(vim.tbl_keys(configs))

-- vim.lsp.enable('llm-ls')
-- done via plugin for now
-- vim.lsp.enable("llm")
-- disable diagnostics when entering diffmode ?
-- vim.api.nvim_create_autocmd("WinEnter", {
--   callback = function()
--     if vim.wo.diff then
--       vim.diagnostic.disable(0) -- Disable diagnostics for the buffer
--     else
--       vim.diagnostic.enable(0)  -- Re-enable diagnostics when leaving diff mode
--     end
--   end,
-- })

require('plugins.avante')

-- HACK around sway-scratchpad limitation where one can't esapce quotes so alleviate the need for that via a proxy command
vim.api.nvim_create_user_command('LlmChat', function()
    -- vim.cmd([[GpChatToggle tab]])
    require('avante.api').ask({ without_selection = true })
end, { desc = 'Ask without selecting anything' })

require('plugins.diffview')
require('lsp-progress').setup()
require('teto.cursorline')

local mclipboard = require('teto.clipboard')

vim.keymap.set('n', '<F7>', function()
    mclipboard.copy_filename(false)
end, { desc = 'Copy buffer filename' })

-- Set highlight for GitSignsAdd with green background
-- setting those in gitsigns.lua, they got erased
vim.api.nvim_set_hl(0, 'GitSignsAdd', {
    bg = '#00FF00', -- Green background
})
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', {
    bg = '#00FF00', -- Green background
})

-- vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/hurl.nvim')
-- useless, I need to tweak the lua path ?
-- vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/lual')
vim.g.mcphub = {
    config = vim.fn.expand('~/.config/mcphub/servers.json'), -- Absolute path to MCP Servers config file (will create if not exists)
    port = 37373, -- The port `mcp-hub` server listens to
    -- looks odd ?
    -- use_bundled_binary = true,  -- Use local `mcp-hub` binary

    -- we could point at the nix executable with:
    -- cmd = "node",
    -- cmdArgs = {"/path/to/mcp-hub/src/utils/cli.js"},
    log = {
        to_file = true,
        file_path = vim.fn.expand('~/mcphub.log'),
        level = vim.log.levels.DEBUG,
        prefix = 'MCPHub',
    },
}

vim.keymap.set('n', '[[', function()
    vim.diagnostic.jump({
        count = -1,
        wrap = true,
        -- severity
        -- on_jump
    })
end, { buffer = false })
vim.keymap.set('n', ']]', function()
    vim.diagnostic.jump({ count = 1, wrap = true })
end, { buffer = false })

vim.keymap.set('n', ',jl', function()
    -- vim.diagnostic.goto_next({ wrap = true})
    vim.cmd([[ Rikai lookup ]])
end, { buffer = false, desc = 'Japanese lookup' })

vim.keymap.set('n', '<D-j>', function()
    vim.cmd([[ Rikai lookup ]])
end, { buffer = false, desc = 'Japanese lookup' })

vim.keymap.set('n', '<leader>d', function()
    vim.cmd([[ FzfLua diagnostics_document ]])
end, { buffer = false, desc = 'Diagnostics' })

-- Autocommand to highlight the word under the cursor when the cursor moves
-- vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
--     group = highlight_group,
--     pattern = "*",
--     callback = highlight_current_word,
-- })

require('teto.lsp').ignore_simwork_extended_warnings()
-- vim.g.tidal_ghci = "ghci"
vim.g.tidal_target = 'terminal'
vim.g.tidal_sc_enable = 1

-- tidal_default_config
-- ghci -ghci-script /nix/store/f0ks6kcn0qch268ykcxnzp0fn5d24m4m-tidal-1.10.1-data/share/ghc-9.10.3/x86_64-linux-ghc-9.10.3-2c56/tidal-1.10.1/BootTidal.hs
vim.g.tidal_boot = nix_deps.tidal_boot .. 'BootTidal.hs'

-- require("jj").setup({})

  vim.keymap.set('n', 'gF', function()
    local file = vim.fn.expand('<cfile>')
    if file == '' then
      print('No file under cursor')
      return
    end

    -- Create parent directories if they don't exist
    local dir = vim.fn.fnamemodify(file, ':h')
    if dir ~= '' and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end

    -- Edit the file (creates it if it doesn't exist)
    vim.cmd('edit ' .. vim.fn.fnameescape(file))
  end, { desc = 'Go to file, create if missing' })

-- Wrapping the `require` in `function-end` is important for lazy-load.
-- table.insert(package.loaders, function(...)
--   return require("thyme").loader(...) -- Make sure to `return` the result!
-- end)

-- Note: Add a cache path to &rtp. The path MUST include the literal substring "/thyme/compile".
local thyme_cache_prefix = vim.fn.stdpath("cache") .. "/thyme/compiled"
vim.opt.rtp:prepend(thyme_cache_prefix)
-- Note: `vim.loader` internally cache &rtp, and recache it if modified.
-- Please test the best place to `vim.loader.enable()` by yourself.
-- vim.loader.enable() -- (optional) before the `bootstrap`s above, it could increase startuptime.

-- rag_service.launch_rag_service(function()
--   -- Callback when service is ready
--   print("RAG service is running!")
-- end)
function rag_add()
	local rag_service = require('avante.rag_service')

	rag_service.add_resource("/home/teto/blog")
end
