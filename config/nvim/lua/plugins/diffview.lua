require("diffview").setup({
  view = {
    default = {
      layout = "diff2_horizontal", -- or "diff2_vertical" for vertical split
      winbar_info = false,          -- optional: hide file info in the window bar
      disable_diagnostics = false,  -- Temporarily disable diagnostics for diff buffers while in the view.
    },
    merge_tool = {
      layout = "diff3_mixed",       -- for merge conflicts
      disable_diagnostics = true,   -- easier view
    },
	file_panel = {
	  listing_style = "tree",             -- One of 'list' or 'tree'
	  tree_options = {                    -- Only applies when listing_style is 'tree'
		flatten_dirs = true,              -- Flatten dirs that only contain one single dir
		folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
	  },
	  win_config = {                      -- See |diffview-config-win_config|
		position = "left",
		width = 35,
		win_opts = {},
	  },
	},
    -- file_history = {
    --   layout = "diff2_horizontal",
    -- },
  },
  hooks = {
    diff_buf_read = function(bufnr)
      vim.cmd("setlocal wrap")
    end,
	-- test my fork to see if it can disable the panel 
	-- view_opened = function()
	-- 	require("diffview.actions").toggle_files()
	-- end,
  },
})

