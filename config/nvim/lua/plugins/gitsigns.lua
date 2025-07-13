local M = {}

M.setup = function()
    require('gitsigns').setup({
        -- '│' passe mais '▎' non :s
        signs = {},
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        signs_staged_enable = false,
		-- it doesn't work properly, sometimes it takes only
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            follow_files = true,
        },

        attach_to_untracked = false,

        on_attach = function(bufnr)
            local function map(mode, lhs, rhs, opts)
                opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
                vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
            end

            -- Navigation
            map(
                'n',
                ']c',
                "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
                { expr = true, desc = 'Git: go to next hunk' }
            )
            map(
                'n',
                '[c',
                "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
                { expr = true, desc = 'Git: go to previous hunk' }
            )

            -- Actions
            map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
            map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
            map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
            map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
            map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', { desc = 'Stage buffer' })
            map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
            map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
            map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { desc = 'Blame line' })
            map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
            map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')

            -- disabled to avoid
            -- map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
            -- map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

            -- Text object
            map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        -- how to disable
        -- watch_gitdir = {
        --   interval = 1000,
        --   follow_files = true
        -- },
        sign_priority = 6,
        current_line_blame = false,
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        max_file_length = 20000, -- Disable if file is longer than this (in lines)
        update_debounce = 300,
        status_formatter = nil, -- nil => Use default
        diff_opts = {
            internal = false,
        }, -- If luajit is present
    })

    -- vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'GitSignsDeleteLn' })
    vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { link = 'GitSignsChangeLn' })
    vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
	-- GitSignsChangeLn links DiffChange by default
    -- vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'GitSignsChangeLn' })
    -- vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'GitSignsAddNr' })
end


M.setup()
return M
