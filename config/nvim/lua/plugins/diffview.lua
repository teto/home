require("diffview").setup({
  view = {
    default = {
      layout = "diff2_horizontal", -- or "diff2_vertical" for vertical split
      winbar_info = false,          -- optional: hide file info in the window bar
    },
    merge_tool = {
      layout = "diff3_mixed",       -- for merge conflicts
      disable_diagnostics = true,   -- easier view
    },
    file_history = {
      layout = "diff2_horizontal",
    },
  },
  hooks = {
    diff_buf_read = function(bufnr)
      vim.cmd("setlocal wrap")
    end,
  },
})

