return {
  {
   'harrisoncramer/gitlab.nvim',
   enabled = false,
   build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
   -- one can then run:
   -- require("gitlab").summary()
   -- require("gitlab").review()
   -- require("gitlab").pipeline()
   -- dependencies = {

   -- },
   config = function()
     require("gitlab").setup() -- Uses delta reviewer by default
   end,
  },
  {
   'lewis6991/gitsigns.nvim',
   config = function()
        require 'gitsigns'.setup {
        -- '│' passe mais '▎' non :s
        signs = {
            add          = {hl = 'GitSignsAdd'   , text ='▎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
            change       = {hl = 'GitSignsChange', text ='▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
            delete       = {hl = 'GitSignsDelete', text ='▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            topdelete    = {hl = 'GitSignsDelete', text ='▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text ='▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          },
          signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
          numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
          linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
          word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
          on_attach = function(bufnr)
              local function map(mode, lhs, rhs, opts)
                  opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
              end

              -- Navigation
              map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true, desc ="Git: go to next hunk"})
              map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true, desc ="Git: go to previous hunk"})

              -- Actions
              map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', {desc = "Stage hunk" })
              map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', {desc = "Stage hunk" })
              map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', {desc = "Reset hunk" })
              map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', {desc = "Reset hunk" })
              map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', {desc = "Stage buffer" })
              map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
              map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
              map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
              map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', {desc= "Blame line"})
              map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
              map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')

              -- disabled to avoid
              -- map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
              -- map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

              -- Text object
              map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
              map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end,
          watch_gitdir = {
            interval = 1000,
            follow_files = true
          },
          sign_priority = 6,
          current_line_blame = false,
          current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
          current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
          },
          max_file_length = 40000, -- Disable if file is longer than this (in lines)
          update_debounce = 300,
          status_formatter = nil, -- Use default
          diff_opts = {
              internal = false
          }  -- If luajit is present
        }
     end

  },
  {
   'sindrets/diffview.nvim' -- :DiffviewOpen
  }

    -- review locally github PRs
    -- local has_octo, octo = pcall(require, 'octo')
    -- if has_octo then
    --     octo.setup({
    --         default_remote = { 'upstream', 'origin' }, -- order to try remotes
    --         reaction_viewer_hint_icon = '', -- marker for user reactions
    --         user_icon = ' ', -- user icon
    --         timeline_marker = '', -- timeline marker
    --         timeline_indent = '2', -- timeline indentation
    --         right_bubble_delimiter = '', -- Bubble delimiter
    --         left_bubble_delimiter = '', -- Bubble delimiter
    --         github_hostname = '', -- GitHub Enterprise host
    --         snippet_context_lines = 4, -- number or lines around commented lines
    --         file_panel = {
    --             size = 10, -- changed files panel rows
    --             use_icons = true,					   -- use web-devicons in file panel
    --         },
    --         mappings = { --{{{
    --             issue = { --{{{
    --                 close_issue = '<space>ic', -- close issue
    --                 reopen_issue = '<space>io', -- reopen issue
    --                 list_issues = '<space>il', -- list open issues on same repo
    --                 reload = '<C-r>', -- reload issue
    --                 open_in_browser = '<C-b>', -- open issue in browser
    --                 copy_url = '<C-y>', -- copy url to system clipboard
    --                 add_assignee = '<space>aa', -- add assignee
    --                 remove_assignee = '<space>ad', -- remove assignee
    --                 create_label = '<space>lc', -- create label
    --                 add_label = '<space>la', -- add label
    --                 remove_label = '<space>ld', -- remove label
    --                 goto_issue = '<space>gi', -- navigate to a local repo issue
    --                 add_comment = '<space>ca', -- add comment
    --                 delete_comment = '<space>cd', -- delete comment
    --                 next_comment = ']c', -- go to next comment
    --                 prev_comment = '[c', -- go to previous comment
    --                 react_hooray = '<space>rp', -- add/remove 🎉 reaction
    --                 react_heart = '<space>rh', -- add/remove ❤️ reaction
    --                 react_eyes = '<space>re', -- add/remove 👀 reaction
    --                 react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
    --                 react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
    --                 react_rocket = '<space>rr', -- add/remove 🚀 reaction
    --                 react_laugh = '<space>rl', -- add/remove 😄 reaction
    --                 react_confused = '<space>rc', -- add/remove 😕 reaction
    --             }, --}}}
    --             pull_request = { --{{{
    --                 checkout_pr = '<space>po', -- checkout PR
    --                 merge_pr = '<space>pm', -- merge PR
    --                 list_commits = '<space>pc', -- list PR commits
    --                 list_changed_files = '<space>pf', -- list PR changed files
    --                 show_pr_diff = '<space>pd', -- show PR diff
    --                 add_reviewer = '<space>va', -- add reviewer
    --                 remove_reviewer = '<space>vd', -- remove reviewer request
    --                 close_issue = '<space>ic', -- close PR
    --                 reopen_issue = '<space>io', -- reopen PR
    --                 list_issues = '<space>il', -- list open issues on same repo
    --                 reload = '<C-r>', -- reload PR
    --                 open_in_browser = '<C-b>', -- open PR in browser
    --                 copy_url = '<C-y>', -- copy url to system clipboard
    --                 add_assignee = '<space>aa', -- add assignee
    --                 remove_assignee = '<space>ad', -- remove assignee
    --                 create_label = '<space>lc', -- create label
    --                 add_label = '<space>la', -- add label
    --                 remove_label = '<space>ld', -- remove label
    --                 goto_issue = '<space>gi', -- navigate to a local repo issue
    --                 add_comment = '<space>ca', -- add comment
    --                 delete_comment = '<space>cd', -- delete comment
    --                 next_comment = ']c', -- go to next comment
    --                 prev_comment = '[c', -- go to previous comment
    --                 react_hooray = '<space>rp', -- add/remove 🎉 reaction
    --                 react_heart = '<space>rh', -- add/remove ❤️ reaction
    --                 react_eyes = '<space>re', -- add/remove 👀 reaction
    --                 react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
    --                 react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
    --                 react_rocket = '<space>rr', -- add/remove 🚀 reaction
    --                 react_laugh = '<space>rl', -- add/remove 😄 reaction
    --                 react_confused = '<space>rc', -- add/remove 😕 reaction
    --             }, --}}}
    --             review_thread = { --{{{
    --                 goto_issue = '<space>gi', -- navigate to a local repo issue
    --                 add_comment = '<space>ca', -- add comment
    --                 add_suggestion = '<space>sa', -- add suggestion
    --                 delete_comment = '<space>cd', -- delete comment
    --                 next_comment = ']c', -- go to next comment
    --                 prev_comment = '[c', -- go to previous comment
    --                 select_next_entry = ']q', -- move to previous changed file
    --                 select_prev_entry = '[q', -- move to next changed file
    --                 close_review_tab = '<C-c>', -- close review tab
    --                 react_hooray = '<space>rp', -- add/remove 🎉 reaction
    --                 react_heart = '<space>rh', -- add/remove ❤️ reaction
    --                 react_eyes = '<space>re', -- add/remove 👀 reaction
    --                 react_thumbs_up = '<space>r+', -- add/remove 👍 reaction
    --                 react_thumbs_down = '<space>r-', -- add/remove 👎 reaction
    --                 react_rocket = '<space>rr', -- add/remove 🚀 reaction
    --                 react_laugh = '<space>rl', -- add/remove 😄 reaction
    --                 react_confused = '<space>rc', -- add/remove 😕 reaction
    --             }, --}}}
    --             submit_win = { --{{{
    --                 approve_review = '<C-a>', -- approve review
    --                 comment_review = '<C-m>', -- comment review
    --                 request_changes = '<C-r>', -- request changes review
    --                 close_review_tab = '<C-c>', -- close review tab
    --             }, --}}}
    --             review_diff = { --{{{
    --                 add_review_comment = '<space>ca', -- add a new review comment
    --                 add_review_suggestion = '<space>sa', -- add a new review suggestion
    --                 focus_files = '<leader>e', -- move focus to changed file panel
    --                 toggle_files = '<leader>b', -- hide/show changed files panel
    --                 next_thread = ']t', -- move to next thread
    --                 prev_thread = '[t', -- move to previous thread
    --                 select_next_entry = ']q', -- move to previous changed file
    --                 select_prev_entry = '[q', -- move to next changed file
    --                 close_review_tab = '<C-c>', -- close review tab
    --                 toggle_viewed = '<leader><space>', -- toggle viewer viewed state
    --             }, --}}}
    --             file_panel = { --{{{
    --                 next_entry = 'j', -- move to next changed file
    --                 prev_entry = 'k', -- move to previous changed file
    --                 select_entry = '<cr>', -- show selected changed file diffs
    --                 refresh_files = 'R', -- refresh changed files panel
    --                 focus_files = '<leader>e', -- move focus to changed file panel
    --                 toggle_files = '<leader>b', -- hide/show changed files panel
    --                 select_next_entry = ']q', -- move to previous changed file
    --                 select_prev_entry = '[q', -- move to next changed file
    --                 close_review_tab = '<C-c>', -- close review tab
    --                 toggle_viewed = '<leader><space>', -- toggle viewer viewed state
    --             },--}}}
    --         },--}}}
    --     })
    -- end


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
}
