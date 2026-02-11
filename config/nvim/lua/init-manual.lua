-- vim: set noet fdm=marker fenc=utf-8 ff=unix sts=0 sw=4 ts=4 :
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://www.reddit.com/r/neovim/comments/o8dlwg/how_to_append_to_an_option_in_lua/
-- local configs = require'nvim_lsp/configs'
-- vim.loader.enable(true)
-- showcmdloc
-- require('avante_lib').load()
--
--https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md#-complete-configuration-example
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

-- vim.env.PATH = "/nix/store/wy6pg4liq14r08vbn7cr4ksqdh0ayavn-wl-clipboard-2.2.1/bin:"..vim.env.PATH

local has_fzf_lua, _fzf_lua = pcall(require, 'fzf-lua')

-- set to true to enable it
local use_fzf_lua = has_fzf_lua and true

local map = vim.keymap.set

local valid_file, nix_deps = pcall(require, 'generated-by-nix')
if not valid_file then
    vim.notify('Invalid generated-by-nix')
end
vim.g.rikai = {
    kanjidb = nix_deps.edict_kanjidb,
    jmdictdb = nix_deps.edict_expressiondb,
    log_level = vim.log.levels.DEBUG,
    separator = '===>>>',
    popup = {},
}

vim.o.spelllang = 'en_gb,fr'

-- new option
vim.o.winborder = 'rounded'
vim.opt.guicursor =
    'n-v-c:block-blinkon250-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-blinkon250-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- TODO diagnostics = { virtual_text = false }
diagnostic_default_config = {
    -- disabled because too big in haskell
    virtual_lines = false, -- not needed with tiny-inline-diagnostic
    -- {
    --        current_line = true,
    --        -- Function that can transform the diagnostic
    --        -- format = if
    --    },
    virtual_text = false,
    -- {
    --        source = 'if_many',
    --        -- • {format}?             (`fun(diagnostic:vim.Diagnostic): string?`) If
    --        --                       not nil, the return value is the text used to
    --        --                       display the diagnostic. Example: >lua
    --        --                           function(diagnostic)
    --        --                             if diagnostic.severity == vim.diagnostic.severity.ERROR then
    --        --                               return string.format("E: %s", diagnostic.message)
    --        --                             end
    --        --                             return diagnostic.message
    --        --                           end
    --        --
    --    },
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

--
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

-- -- TODO remove once it's merged upstream
-- vim.api.nvim_create_user_command('RestLog', function()
--   vim.cmd(string.format('tabnew %s', vim.fn.stdpath('cache')..'/rest.nvim.log'))
-- end, {
--   desc = 'Opens the rest.nvim log.',
-- })

-- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- set it before loading vim plugins like autosession
-- ,localoptions
vim.o.sessionoptions = 'buffers,curdir,help,tabpages,winsize,winpos,localoptions'

-- fixing some stuff
vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/avante.nvim')
-- doing jj tests
-- vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/diffview.nvim')
-- vim.opt.rtp:prepend(os.getenv('HOME') .. '/neovim/rocks-dev.nvim')
vim.opt.rtp:prepend(os.getenv('HOME') .. '/rocks-config.nvim')
vim.opt.rtp:prepend(os.getenv('HOME') .. '/rocks.nvim')

-- require("vim.lsp._watchfiles")._watchfunc = require("vim._watch").watch
-- local ffi = require 'ffi'
local custom_luarocks_config_filename = vim.fn.stdpath('config') .. '/luarocks-config-generated.lua'
local luarocks_config_fn, errmsg = loadfile(custom_luarocks_config_filename)

if luarocks_config_fn == nil then
    print('Could not load ' .. errmsg)
end

vim.g.rocks_nvim = {
    -- use nix_deps.luarocks_executable coming from nixpkgs
    -- TODO removing this generates errors at runtime :'(
    luarocks_binary = nix_deps.luarocks_executable,
    -- /home/teto/.local/share/nvim/rocks/luarocks-config.lua
    ---@diagnostic disable-next-line: need-check-nil
    luarocks_config = luarocks_config_fn(),
    -- _log_level = vim.log.levels.TRACE,

    -- checkout constants.DEFAULT_DEV_SERVERS
    servers = { 'https://luarocks.org/manifests/neorocks/' },

    auto_sync = 'disable',
    update_remote_plugins = false,

    lazy = true, -- for cleaner logs
    -- rocks.nvim config
    treesitter = {
        auto_highlight = {},
        auto_install = 'prompt',
        parser_map = {},

        -- filetypes or a function
        disable = {
            'lhaskell',
        },
    },
}

vim.g.loaded_matchit = 1

vim.opt.shortmess:append('I')
vim.opt.foldlevel = 99
vim.opt.mousemoveevent = true

vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

local on_attach = require('teto.on_attach')

-- this in nightly
vim.lsp.config('*', {
    -- https://github.com/neovim/nvim-lspconfig/issues/3827
    on_attach = on_attach.on_attach,
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

vim.g.matchparen = 1
vim.g.mousemoveevent = 1 -- must be setup before calling lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.colorcolumn = { 100 }

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

-- generated from luau via darklua
-- require('teto.context_menu_generated').setup_rclick_menu_autocommands()
-- require('teto.context_menu').setup_rclick_menu_autocommands()
-- vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua open_contextual_menu()<CR>', { noremap = true, silent = false })

-- MenuPopup
vim.opt.signcolumn = 'auto:1-3'

-- vim.g.grug_far = {startInInsertMode = false }

-- --set shada=!,'50,<1000,s100,:0,n/home/teto/.cache/nvim/shada
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

-- https://github.com/neovim/nvim-lspconfig/issues/3827
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Attach lsp_signature on new client',
    callback = function(args)
        -- print("Called matt's on_attach autocmd")
        if not (args.data and args.data.client_id) then
            return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- local bufnr = args.buf
        -- local on_attach = require('teto.on_attach')

        -- dont attach in diffmode
        if vim.wo.diff then
            vim.schedule(function()
                -- vim.lsp.client:stop({id = client.id})
            end)
            return
        end
        -- on_attach.on_attach(client, bufnr)

        if client:supports_method('textDocument/completion') then
            -- Enable auto-completion
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

function string:endswith(ending)
    return ending == '' or self:sub(-#ending) == ending
end

-- TODO this should depend on theme ! computed via lush
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Set italic codelens on new colorschemes',
    callback = function()
        -- local bgcol = vim.api.nvim_get_hl(0, { name = 'Normal' })
        -- local c = require('colortils')
        -- local utils = require('colortils.utils.colors')
        -- local hl_normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
        -- local
        -- TODO use teto.colors
        -- utils.get_grey(hl_normal.bg)

        vim.api.nvim_set_hl(0, 'LspCodeLens', { italic = true, bg = 'blue' })
        vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'red' })
        vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextDebug', { fg = 'green' })

        vim.api.nvim_set_hl(0, 'LspReferenceTarget', {})

        -- autocmd ColorScheme *
        --       \ highlight Comment gui=italic
        --       \ | highlight Search gui=underline
        --       \ | highlight MatchParen guibg=NONE guifg=NONE gui=underline
        -- vim.cmd.packadd('gitsigns.nvim')
    end,
})

-- http://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>', { desc = 'Focus alternate buffer' })

vim.keymap.set('n', '0', '^', { desc = 'Go to first line' })

vim.keymap.set('n', '<Leader>ev', '<Cmd>e $MYVIMRC<CR>', { desc = "Edit home-manager's generated neovim config" })
vim.keymap.set('n', '<Leader>el', '<Cmd>e ' .. vim.fn.stdpath('config') .. '/lua/init-manual.lua<CR>')
vim.keymap.set('n', '<F6>', '<Cmd>ASToggle<CR>', { desc = 'Toggle autosave' })

vim.g.autosave_disable_inside_paths = { vim.fn.stdpath('config') }

-- " auto reload vim config on save
-- " Watch for changes to vimrc
-- " augroup myvimrc
-- "   au!
-- "   au BufWritePost $MYVIMRC,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
-- " augroup END

-- autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
-- " convert all kinds of files (but pdf) to plain text
-- autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*.pdf',
    callback = function()
        vim.cmd([[%!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78]])
    end,
})

-- local has_sniprun, _sniprun = pcall(require, 'sniprun')
--
-- if has_sniprun then
--     require('plugins.sniprun')
-- end

vim.g.indicator_errors = ''
vim.g.indicator_warnings = ''
vim.g.indicator_info = '🛈'
vim.g.indicator_hint = '❗'
vim.g.indicator_ok = '✅'

-- ✓
vim.g.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

if use_fzf_lua then
    require('plugins.fzf-lua')
    require('teto.fzf-lua').register_keymaps()
else
    vim.notify('fzf-lua is MISSING !?')
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
vim.lsp.log.set_level(vim.lsp.log_levels.INFO)

-- setup haskell-tools
vim.g.haskell_tools = require('teto.haskell-tools').generate_settings()

vim.opt.showbreak = '↳ ' -- displayed in front of wrapped lines

-- TODO add a command to select a ref  and call Gitsigns change_base afterwards

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

-- vim.api.nvim_set_keymap(
--	 'n',
--	 '<F1>',
--	 "<Cmd>lua require'stylish'.ui_menu(vim.fn.menu_get(''), {kind=menu, prompt = 'Main Menu', experimental_mouse = true}, function(res) print('### ' ..res) end)<CR>",
--	 { noremap = true, silent = true }
-- )

-- if has_gitsigns then
--     local tgitsigns = require('plugins.gitsigns')
--     tgitsigns.setup()
-- end

-- commented out till https://github.com/ErikReider/SwayNotificationCenter/issues/323 gets implemented
local teto_notify = require('teto.notify')
if teto_notify.should_use_provider() then
    teto_notify.override_vim_notify()
end

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

-- local b64 = require('teto.b64')

vim.keymap.set('v', '<leader>b', function() end)
vim.keymap.set('v', '<leader>B', '<Plug>(ToBase64)')

-- Key mapping to apply Base64 encoding to selected text
vim.api.nvim_set_keymap(
    'v',
    '<leader>be',
    [[:lua apply_function_to_selection(base64_encode)<CR>]],
    { noremap = true, silent = true }
)

-- 0 is kinda buggy with confirm and so on
vim.opt.cmdheight = 1

-- for indentblankline
--
-- require('plugins.nvim-treesitter-textobjects')
-- autoloaded
-- require('plugins.nvim-treesitter')

-- one can pass a list as well
-- vim.lsp.enable('lua_ls')  -- todo remove replaced by emmylua
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('yamlls')
vim.lsp.enable('just')

-- used by `lx check`
vim.lsp.enable('emmylua_ls')

-- todo luau_lsp + luacheck ?
-- vim.lsp.enable('just')

-- testing packadd
vim.pack.add({
    -- my real neovim package manager (with nix)
    'https://github.com/nvim-neorocks/rocks.nvim',
    -- 'https://github.com/elanmed/fzf-lua-frecency.nvim', -- to rocks

    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/teto/vim-listchars',
    'https://github.com/yutkat/git-rebase-auto-diff.nvim',

    'https://github.com/gbprod/none-ls-shellcheck.nvim',

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

-- require('plugins.diffview')
require('lsp-progress').setup()
-- todo restore
-- require('teto.cursorline')

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
    vim.cmd([[ Rikai lookup ]])
end, { buffer = false, desc = 'Japanese lookup' })

vim.keymap.set({ 'n', 'v' }, '<D-j>', function()
    vim.cmd([[ Rikai lookup ]])
end, { buffer = false, desc = 'Japanese lookup' })

vim.keymap.set('n', '<leader>d', function()
    vim.cmd([[ FzfLua diagnostics_document ]])
end, { buffer = false, desc = 'Diagnostics' })

vim.keymap.set('v', '<D-t>j', function()
    -- todo replace with selection
    vim.cmd([[ AvanteAsk what does 見る mean ? ]])
end, { buffer = false, desc = 'Diagnostics' })

-- Autocommand to highlight the word under the cursor when the cursor moves
-- vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
--     group = highlight_group,
--     pattern = "*",
--     callback = highlight_current_word,
-- })

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
    -- local dir = vim.fn.fnamemodify(file, ':h')
    -- todo confirm with user before creating the folder

    local from_dir = vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h')
    print('Selected dir:', from_dir)
    local new_filename = vim.fs.joinpath(from_dir, file)
    print('new_filename:', new_filename)

    local dir = vim.fn.fnamemodify(new_filename, ':h')
    if dir ~= '' and vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
    end
    -- Edit the file (creates it if it doesn't exist)
    vim.cmd('edit ' .. vim.fn.fnameescape(new_filename))
end, { desc = 'Go to file, create if missing' })

-- Wrapping the `require` in `function-end` is important for lazy-load.
-- table.insert(package.loaders, function(...)
--   return require("thyme").loader(...) -- Make sure to `return` the result!
-- end)

-- Note: Add a cache path to &rtp. The path MUST include the literal substring "/thyme/compile".
-- local thyme_cache_prefix = vim.fn.stdpath("cache") .. "/thyme/compiled"
-- vim.opt.rtp:prepend(thyme_cache_prefix)
-- Note: `vim.loader` internally cache &rtp, and recache it if modified.
-- Please test the best place to `vim.loader.enable()` by yourself.
-- vim.loader.enable() -- (optional) before the `bootstrap`s above, it could increase startuptime.

-- valid in my fork, must appear before the setup call
-- if vim.g.avante ~= nil then return end
-- Outside of the fork it kills the plugin so careful
-- normally overriden by setup call
vim.g.avante = {
    log_level = vim.log.levels.DEBUG,
}
require('plugins.avante')

local avante = require('teto.avante')

avante.setup_autocmd()

-- HACK around sway-scratchpad limitation where one can't esapce quotes so alleviate the need for that via a proxy command
vim.api.nvim_create_user_command('LlmChat', function()
    -- vim.cmd([[GpChatToggle tab]])
    require('avante.api').ask({ without_selection = true })
end, { desc = 'Ask without selecting anything' })

-- "module 'nvim-treesitter.parsers' not found:"
-- require('plugins.neorg')
-- todo fix upgraded version
-- require('plugins.image')

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "norg", "neorg" },
--   callback = function()
--     if pcall(vim.treesitter.start) then
--       vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--       vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--     end
--   end,
-- })
--
-- -- https://github.com/nvim-neorg/neorg/issues/1351
-- -- https://github.com/nvim-neorg/neorg/issues/1342

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- todo add api to list remote models
vim.api.nvim_create_user_command('AvanteLogs', ':e ~/.cache/nvim/avante.log', { desc = 'read avante logs' })

-- require('plugins.neorg')
