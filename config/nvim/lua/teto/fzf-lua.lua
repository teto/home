local _, fzf_lua = pcall(require, 'fzf-lua')

local M = {}

function M.register_keymaps()
    -- autocomplete :FzfLua to see what's available
    vim.keymap.set('n', '<Leader>g', function()
        fzf_lua.files()
    end)
    vim.keymap.set('n', '<Leader>o', function()
        fzf_lua.git_files()
    end)
    vim.keymap.set('n', '<Leader>F', function()
        fzf_lua.filetypes()
    end, { desc = 'Select fileype' })
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
  local fzf = require 'fzf-lua'
  opts = fzf.config.normalize_opts(opts, fzf.config.globals.files)
  local hash = get_hash()
  opts.cmd = 'command cat <(fre --sorted --store_name ' .. hash .. ") <(fd -t f) | awk '!x[$0]++'" -- | the awk command is used to filter out duplicates.
  opts.fzf_opts = vim.tbl_extend('force', opts.fzf_opts, {
    ['--tiebreak'] = 'index' -- make sure that items towards top are from history
  })
  opts.actions = vim.tbl_extend('force', opts.actions or {}, {
    ['ctrl-d'] = {
      -- Ctrl-d to remove from history
      function(sel)
        if #sel < 1 then return end
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
    if not selected or #selected < 2 then return end
    vim.fn.system('fre --add ' .. selected[2] .. ' --store_name ' .. hash)
    fzf.actions.act(opts.actions, selected, opts)
  end)()
end

return M
