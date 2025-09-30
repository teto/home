local core = require('fzf-lua.core')
local path = require('fzf-lua.path')
local libuv = require('fzf-lua.libuv')
local utils = require('fzf-lua.utils')
local config = require('fzf-lua.config')
local shell = require('fzf-lua.shell')
local make_entry = require('fzf-lua.make_entry')
local defaults = require('fzf-lua.defaults')

local M = {}

-- should fzf-lua expose lazyloaded_modules ?
function M.jj_cwd(cmd, opts)
    -- local git_args = {
    --   { "cwd",          "-C" },
    --   { "git_dir",      "--git-dir" },
    --   { "git_worktree", "--work-tree" },
    --   { "git_config",   "-c",         noexpand = true },
    -- }
    -- -- NOTE: we copy the opts due to a bug with Windows network drives starting with "\\"
    -- -- as `vim.fn.expand` would reduce the double slash to a single slash modifying the
    -- -- original `opts.cwd` ref (#1429)
    -- local o = {}
    -- for _, a in ipairs(git_args) do o[a[1]] = opts[a[1]] end
    -- if type(cmd) == "string" then
    --   local args = ""
    --   for _, a in ipairs(git_args) do
    --     if o[a[1]] then
    --       o[a[1]] = a.noexpand and o[a[1]] or libuv.expand(o[a[1]])
    --       args = args .. ("%s %s "):format(a[2], libuv.shellescape(o[a[1]]))
    --     end
    --   end
    --   cmd = cmd:gsub("^git ", "git " .. args)
    -- else
    --   local idx = 2
    --   cmd = utils.tbl_deep_clone(cmd)
    --   for _, a in ipairs(git_args) do
    --     if o[a[1]] then
    --       o[a[1]] = a.noexpand and o[a[1]] or libuv.expand(o[a[1]])
    --       table.insert(cmd, idx, a[2])
    --       table.insert(cmd, idx + 1, o[a[1]])
    --       idx = idx + 2
    --     end
    --   end
    -- end
    return cmd
end

function M.is_jj_repo(opts, noerr)
    return not not M.jj_root(opts, noerr)
end

function M.jj_root(opts, noerr)
    local cmd = M.jj_cwd({ 'jj', 'root', '--ignore-working-copy' }, opts)
    local output, err = utils.io_systemlist(cmd)
    if err ~= 0 then
        if not noerr then
            -- dont propagate message
            -- utils.info("MATT custom jj_root message")
            -- utils.info(unpack(output))
        end
        return nil
    end
    return output[1]
end

local function set_jj_cwd_args(opts)
    -- verify cwd is a jj repo, override user supplied
    -- cwd if cwd isn't a jj repo, error was already
    -- printed to `:messages` by 'path.jj_root'
    local jj_root = M.jj_root(opts, true)
    if not opts.cwd or not jj_root then
        opts.cwd = jj_root
    end
    -- leave it for now
    -- if opts.jj_dir or opts.jj_worktree then
    --   opts.cmd = path.jj_cwd(opts.cmd, opts)
    -- end
    return opts
end

local jj_defaults = vim.tbl_extend('force', defaults.defaults.git, {
    -- previewer         = M._default_previewer_fn,
    cmd = 'jj file --color=never list',
    -- multiprocess      = true,
    -- file_icons        = 1,
    -- color_icons       = true,
    -- git_icons         = true,
    -- fzf_opts          = { ["--multi"] = true, ["--scheme"] = "path" },
    -- _fzf_nth_devicons = true,
    _actions = function()
        return config.globals.actions.files
    end,
    -- winopts           = { preview = { winopts = { cursorline = false } } },
})

M.jj_files = function(opts)
    -- fzf-lua uses "git.files" to reference the defaults
    opts = config.normalize_opts(opts, jj_defaults)
    if not opts then
        return
    end
    opts = set_jj_cwd_args(opts)
    if not opts.cwd then
        return
    end
    -- local contents = core.mt_cmd_wrapper(opts)
    opts = core.set_header(opts, opts.headers or { 'cwd' })
    local result = core.fzf_exec(opts.cmd, opts)
    return result
end

-- M.status = function(opts)
--   opts = config.normalize_opts(opts, "jj.status")
--   if not opts then return end
--   opts = set_jj_cwd_args(opts)
--   if not opts.cwd then return end
--   if opts.preview then
--     opts.preview = path.jj_cwd(opts.preview, opts)
--   end
--   -- we don't need jj icons since we get them
--   -- as part of our `jj status -s`
--   opts.jj_icons = false
--
--   -- we always require processing (can't send the raw command to fzf)
--   opts.requires_processing = true
--
--   local contents, id
--   if opts.multiprocess then
--     -- jj status does not require preprocessing if not loading devicons
--     -- opts.__mt_preprocess = opts.file_icons
--     --     and [[return require("fzf-lua.devicons").load()]]
--     --     or [[return true]]
--     --
--     -- preprocess is required since the addition of `path.filename_first`
--     -- will be set by `core.mt_cmd_wrapper` by commenting out the above
--     opts.__mt_transform = [[return require("fzf-lua.make_entry").jj_status]]
--     contents = core.mt_cmd_wrapper(opts)
--   else
--     opts.__fn_transform = opts.__fn_transform or
--         function(x)
--           return make_entry.jj_status(x, opts)
--         end
--
--     -- we are reusing the "live" reload action, this gets called once
--     -- on init and every reload and should return the command we wish
--     -- to execute, i.e. `jj status -sb`
--     opts.__fn_reload = function(_)
--       return opts.cmd
--     end
--
--     -- build the "reload" cmd and remove '-- {+}' from the initial cmd
--     contents, id = shell.reload_action_cmd(opts, "")
--     opts.__reload_cmd = contents
--
--     -- when the action resumes the preview re-attaches which registers
--     -- a new shell function id, done enough times it will overwrite the
--     -- regisered function assigned to the reload action and the headless
--     -- cmd will err with "sh: 0: -c requires an argument"
--     -- gets cleared when resume data recycles
--     opts._fn_pre_fzf = function()
--       shell.set_protected(id)
--     end
--   end
--
--   opts.header_prefix = opts.header_prefix or "+ -  "
--   opts.header_separator = opts.header_separator or "|"
--   opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
--
--   return core.fzf_exec(contents, opts)
-- end

-- local function jj_cmd(opts)
--   opts = set_jj_cwd_args(opts)
--   if not opts.cwd then return end
--   opts = core.set_header(opts, opts.headers or { "cwd" })
--   core.fzf_exec(opts.cmd, opts)
-- end

-- M.commits = function(opts)
--   opts = config.normalize_opts(opts, "jj.commits")
--   if not opts then return end
--   if opts.preview then
--     opts.preview = path.jj_cwd(opts.preview, opts)
--     if type(opts.preview_pager) == "function" then
--       opts.preview_pager = opts.preview_pager()
--     end
--     if opts.preview_pager then
--       opts.preview = string.format("%s | %s", opts.preview,
--         utils._if_win_normalize_vars(opts.preview_pager))
--     end
--     if vim.o.shell and vim.o.shell:match("fish$") then
--       -- TODO: why does fish shell refuse to pass along $COLUMNS
--       -- to delta while the same exact commands works with bcommits?
--       opts.preview = "sh -c " .. libuv.shellescape(opts.preview)
--     end
--   end
--   opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
--   return jj_cmd(opts)
-- end

-- M.bcommits = function(opts)
--   opts = config.normalize_opts(opts, "jj.bcommits")
--   if not opts then return end
--   local bufname = vim.api.nvim_buf_get_name(0)
--   if #bufname == 0 then
--     utils.info("'bcommits' is not available for unnamed buffers.")
--     return
--   end
--   -- if caller did not specify cwd, we attempt to auto detect the
--   -- file's jj repo from its parent folder. Could be further
--   -- optimized to prevent the duplicate call to `jj rev-parse`
--   -- but overall it's not a big deal as it's a pretty cheap call
--   -- first 'jj_root' call won't print a warning to ':messages'
--   if not opts.cwd and not opts.jj_dir then
--     opts.cwd = path.jj_root({ cwd = vim.fn.expand("%:p:h") }, true)
--   end
--   local jj_root = path.jj_root(opts)
--   if not jj_root then return end
--   local file = libuv.shellescape(path.relative_to(vim.fn.expand("%:p"), jj_root))
--   local range
--   if utils.mode_is_visual() then
--     local _, sel = utils.get_visual_selection()
--     range = string.format("-L %d,%d:%s --no-patch", sel.start.line, sel["end"].line, file)
--   end
--   if opts.cmd:match("[<{]file") then
--     opts.cmd = opts.cmd:gsub("[<{]file[}>]", range or file)
--   else
--     opts.cmd = opts.cmd .. " " .. (range or file)
--   end
--   if type(opts.preview) == "string" then
--     opts.preview = opts.preview:gsub("[<{]file[}>]", file)
--     opts.preview = path.jj_cwd(opts.preview, opts)
--     if type(opts.preview_pager) == "function" then
--       opts.preview_pager = opts.preview_pager()
--     end
--     if opts.preview_pager then
--       opts.preview = string.format("%s | %s", opts.preview,
--         utils._if_win_normalize_vars(opts.preview_pager))
--     end
--   end
--   opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
--   return jj_cmd(opts)
-- end
--
-- M.blame = function(opts)
--   opts = config.normalize_opts(opts, "jj.blame")
--   if not opts then return end
--   local bufname = vim.api.nvim_buf_get_name(0)
--   if #bufname == 0 then
--     utils.info("'blame' is not available for unnamed buffers.")
--     return
--   end
--   -- See "bcommits" for comment
--   if not opts.cwd and not opts.jj_dir then
--     opts.cwd = path.jj_root({ cwd = vim.fn.expand("%:p:h") }, true)
--   end
--   local jj_root = path.jj_root(opts)
--   if not jj_root then return end
--   local file = libuv.shellescape(path.relative_to(vim.fn.expand("%:p"), jj_root))
--   local range
--   if utils.mode_is_visual() then
--     local _, sel = utils.get_visual_selection()
--     range = string.format("-L %d,%d %s", sel.start.line, sel["end"].line, file)
--   end
--   if opts.cmd:match("[<{]file") then
--     opts.cmd = opts.cmd:gsub("[<{]file[}>]", range or file)
--   else
--     opts.cmd = opts.cmd .. " " .. (range or file)
--   end
--   if type(opts.preview) == "string" then
--     opts.preview = opts.preview:gsub("[<{]file[}>]", file)
--     opts.preview = path.jj_cwd(opts.preview, opts)
--     if type(opts.preview_pager) == "function" then
--       opts.preview_pager = opts.preview_pager()
--     end
--     if opts.preview_pager then
--       opts.preview = string.format("%s | %s", opts.preview,
--         utils._if_win_normalize_vars(opts.preview_pager))
--     end
--   end
--   opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
--   return jj_cmd(opts)
-- end
--
-- M.branches = function(opts)
--   opts = config.normalize_opts(opts, "jj.branches")
--   if not opts then return end
--   if opts.preview then
--     opts.__preview = path.jj_cwd(opts.preview, opts)
--     opts.preview = shell.raw_preview_action_cmd(function(items)
--       -- all possible options:
--       --   branch
--       -- * branch
--       --   remotes/origin/branch
--       --   (HEAD detached at origin/branch)
--       local branch = items[1]:match("[^%s%*]*$"):gsub("%)$", "")
--       return opts.__preview:gsub("{.*}", branch)
--     end, nil, opts.debug)
--   end
--   opts.headers = opts.headers or { "cwd", "actions" }
--   return jj_cmd(opts)
-- end
--
-- M.tags = function(opts)
--   opts = config.normalize_opts(opts, "jj.tags")
--   if not opts then return end
--   return jj_cmd(opts)
-- end
--
-- M.stash = function(opts)
--   opts = config.normalize_opts(opts, "jj.stash")
--   if not opts then return end
--   opts = set_jj_cwd_args(opts)
--   if not opts.cwd then return end
--
--   if opts.preview then
--     opts.preview = path.jj_cwd(opts.preview, opts)
--     if type(opts.preview_pager) == "function" then
--       opts.preview_pager = opts.preview_pager()
--     end
--     if opts.preview_pager then
--       opts.preview = string.format("%s | %s", opts.preview,
--         utils._if_win_normalize_vars(opts.preview_pager))
--     end
--   end
--   if opts.search and opts.search ~= "" then
--     -- search by stash content, jj stash -G<regex>
--     assert(type(opts.search) == "string")
--     opts.cmd = opts.cmd .. " -G " .. libuv.shellescape(opts.search)
--   end
--
--   opts.__fn_transform = opts.__fn_transform or
--       function(x)
--         local stash, rest = x:match("([^:]+)(.*)")
--         if stash then
--           stash = utils.ansi_codes.yellow(stash)
--           stash = stash:gsub("{%d+}", function(s)
--             return ("%s"):format(utils.ansi_codes.green(tostring(s)))
--           end)
--         end
--         return (not stash or not rest) and x or stash .. rest
--       end
--
--   opts.__fn_reload = function(_)
--     return opts.cmd
--   end
--
--   -- build the "reload" cmd and remove '-- {+}' from the initial cmd
--   local contents, id = shell.reload_action_cmd(opts, "")
--   opts.__reload_cmd = contents
--
--   opts._fn_pre_fzf = function()
--     shell.set_protected(id)
--   end
--
--   opts = core.set_header(opts, opts.headers or { "actions", "cwd", "search" })
--   return core.fzf_exec(contents, opts)
-- end

return M
