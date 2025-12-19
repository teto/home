-- wiki is pretty dope https://github.com/ibhagwan/fzf-lua/wiki/Advanced#fzf-exec-api
local _, fzf_lua = pcall(require, 'fzf-lua')

local M = {}

local fzf_jj = require('teto.fzf-lua.providers.jj')

FzfLua.register_extension('jj_files', fzf_jj.jj_files, vim.tbl_deep_extend('keep', {}, {}))

-- FzfLua is a global from fzf_lua
-- FzfLua.register_extension("jj_files", M.frecency, vim.tbl_deep_extend("keep", opts, {

-- local git_files_opts = {
--
--     entry_maker = function(entry)
--         -- Here you can add prioritized sorting or influence entries
--         return {
--             valid = true,
--             value = entry,
--             ordinal = entry, -- What's used for filtering/sorting matches
--             display = 'EZTRY ' .. entry, -- How the display is rendered
--         }
--     end,
-- }

-- https://github.com/ibhagwan/fzf-lua/issues/860
-- _G.myfiles = function(opts)
--   opts = opts or {}
--   opts.debug = true -- use this to debug print the underlying command in the first line
--   -- les --hidden vont regarder les .git --sortr=modified"
--   opts.cmd = opts.cmd or "rg --files --hidden --ignore --glob='!.git' --sortr=modified"
--   -- opts.cmd = opts.cmd or "fd --color=never --type f --follow -X ls -t"
--   opts.actions = {
--     ["ctrl-g"] = function(_, o)
--       _G.myfiles(o)
--     end
--   }
--   if opts.cmd:match("%s+%-%-no%-ignore$") then
--     opts.cmd = opts.cmd:gsub("%s+%-%-no%-ignore$", "")
--   else
--     opts.cmd = opts.cmd .. " --no-ignore"
--   end
--   fzf_lua.files(opts)
-- end

function M.register_keymaps()
    -- autocomplete :FzfLua to see what's available
    vim.keymap.set('n', '<Leader>g', function()
        -- global picker accepts various prefixes such as $ for buffers , @ for lsp
        fzf_lua.global()
    end)
    -- local file_dir = vim.fn.expand('%:p:h')

    --   vim.keymap.set('n', '<Leader>G', function()
    --       -- fzf_lua.files()
    -- fzf_lua_enchanted.files({
    --  -- cwd =false ,
    --  -- prompt = "LOL > "
    -- }
    -- )
    --   end)

    vim.keymap.set('n', '<Leader>o', function()
        -- first check if we are
        local files_picker_name = 'files'
        if fzf_jj.is_jj_repo() then
            files_picker_name = 'jj_files'
            -- fzf_jj.jj_files({
            --     -- fzf_lua.git_files({
            --     --     -- entry_maker = entry_maker
            --     fzf_opts = { ['--scheme'] = 'path' },
            -- })
        end

        -- TODO combine or use global
        -- (currently the first picker options apply to all).
        fzf_lua.combine({

            -- can be a table as well
            -- order matters
            -- files can appear several times
            -- uses options from the first picker
            pickers = {
                'frecency',
                files_picker_name,
                -- "files"
            },
        })
    end)

    vim.keymap.set('n', '<Leader>F', function()
        fzf_lua.filetypes()
    end, { desc = 'Select filetype' })

    vim.keymap.set('n', '<Leader>h', function()
        fzf_lua.oldfiles()
    end)

    vim.keymap.set('n', '<Leader>t', function()
        fzf_lua.tags()
    end, { desc = 'Fuzzysearch tags' })

    vim.keymap.set('n', '<Leader>T', function()
        fzf_lua.tags()
    end, { desc = 'Fuzzysearch tags' })

    vim.keymap.set('n', '<Leader>b', function()
        fzf_lua.buffers()
    end, { desc = 'Fuzzysearch buffers' })

    vim.keymap.set('n', '<Leader>C', function()
        -- awesome_colorschemes can download and install colorschemes
        fzf_lua.colorschemes()
    end, { desc = 'Select a colorscheme' })

    vim.keymap.set('n', '<Leader>l', function()
        fzf_lua.live_grep()
    end)

    vim.keymap.set('n', '<Leader>m', function()
        fzf_lua.menus()
    end, { desc = 'Fuzzy search menu entries' })

    -- nnoremap ( "n", "<Leader>ca", function () vim.lsp.buf.code_action{} end )
    vim.keymap.set('n', '<Leader>ca', function()
        vim.cmd([[FzfLua lsp_code_actions]])
    end)

    -- MRU
    vim.api.nvim_create_user_command('FzfMru', M.fzf_mru, {})
    -- vim.keymap.set("n","<C-p>", M.fzf_mru, {desc="Open Files"})
end

-- copy/pasted from
-- https://www.reddit.com/r/neovim/comments/17dn1be/implementing_mru_sorting_with_minipick_and_fzflua/
local function get_hash()
    -- The get_hash() is utilised to create an independent "store"
    -- By default `fre --add` adds to global history, in order to restrict this to
    -- current directory we can create a hash which will keep history separate.
    -- With this in mind, we can also append git branch to make sorting based on
    -- Current dir + git branch
    local str = 'echo "dir:' .. vim.fn.getcwd()
    if vim.b.gitsigns_head then
        str = str .. ';git:' .. vim.b.gitsigns_head .. '"'
    end
    vim.print(str)
    local hash = vim.fn.system(str .. " | md5sum | awk '{print $1}'")
    return hash
end

function M.fzf_mru(opts)
    local fzf = require('fzf-lua')
    opts = fzf.config.normalize_opts(opts, fzf.config.globals.files)
    local hash = get_hash()
    opts.cmd = 'command cat <(fre --sorted --store_name ' .. hash .. ") <(fd -t f) | awk '!x[$0]++'" -- | the awk command is used to filter out duplicates.
    opts.fzf_opts = vim.tbl_extend('force', opts.fzf_opts, {
        -- ['--tiebreak'] = 'index', -- make sure that items towards top are from history
        ['--scheme'] = 'path',
    })
    opts.actions = vim.tbl_extend('force', opts.actions or {}, {
        ['ctrl-d'] = {
            -- Ctrl-d to remove from history
            function(sel)
                if #sel < 1 then
                    return
                end
                vim.fn.system('fre --delete ' .. sel[1] .. ' --store_name ' .. hash)
            end,
            -- This will refresh the list
            fzf.actions.resume,
        },
        -- TODO: Don't know why this didn't work
        -- ["default"] = {
        --   fn = function(selected)
        --     if #selected < 2 then
        --       return
        --     end
        --     print('exec:', selected[2])
        --     vim.cmd('!fre --add ' .. selected[2])
        --     fzf.actions.file_edit_or_qf(selected)
        --   end,
        --   exec_silent = true,
        -- },
    })

    fzf.core.fzf_wrap(opts, opts.cmd, function(selected)
        if not selected or #selected < 2 then
            return
        end
        vim.fn.system('fre --add ' .. selected[2] .. ' --store_name ' .. hash)
        fzf.actions.act(opts.actions, selected, opts)
    end)()
end

---@param opts {cwd?:string} | table
function M.files(opts)
    opts = opts or {}

    local fzflua = require('fzf-lua')

    if not opts.cwd then
        -- vim.uv.cwd()
        -- safe_cwd(vim.t.Cwd)
        opts.cwd = vim.uv.cwd()
    end
    local cmd = nil
    if vim.fn.executable('fd') == 1 then
        local fzfutils = require('fzf-lua.utils')
        -- fzf-lua.defaults#defaults.files.fd_opts
        cmd = string.format(
            [[fd --color=never --type f --hidden --follow --exclude .git -x printf "{}: {/} %s\n"]],
            fzfutils.ansi_codes.grey('{//}')
        )
        opts.fzf_opts = {
            -- process ansi colors
            ['--ansi'] = '',
            ['--with-nth'] = '2..',
            ['--delimiter'] = '\\s',
            ['--tiebreak'] = 'begin,index',
        }
        -- opts._fmt = opts._fmt or {}
        -- opts._fmt.from = function(entry, _opts)
        --   local s = fzfutils.strsplit(entry, ' ')
        --   return s[3]
        -- end
    end
    opts.cmd = cmd

    opts.winopts = {
        fullscreen = false,
        height = 0.90,
        width = 1,
    }
    opts.ignore_current_file = true

    return fzflua.files(opts)
end

-- fzf_lua.config.set_action_helpstr(fn_ptr, “help string”)

return M
