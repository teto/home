return {
  -- { 'max397574/better-escape.nvim' },
  { 'TheBlob42/houdini.nvim',
    config = function()
        require('houdini').setup()
    end
  },
  {
   -- to help with preloading fennel for instance
   -- 'gpanders/nvim-moonwalk',
  'kevinhwang91/nvim-bqf',
  opts = {
   -- auto_enable = true;
   auto_resize_height = false;
    preview = {
     auto_preview = false,
     delay_syntax = 0
    }
    , func_map = { }
   }
  },
  {
  "folke/trouble.nvim",
  opts =  {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = false, -- use devicons for filenames
    -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    mode = "workspace_diagnostics", 
    severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
    fold_open = "▾", -- icon used for open folds
    fold_closed = "▸", -- icon used for closed folds
    group = true, -- group results by file
    padding = false, -- add an extra new line on top of the list
    cycle_results = true, -- cycle item list when reaching beginning or end of list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- previous item
        next = "j", -- next item
        help = "?" -- help menu
    },
    auto_open = false,
    auto_close = true
    },
 },
 -- { 'mhartington/formatter.nvim',
 -- config = function ()
-- -- Utilities for creating configurations
-- local util = require "formatter.util"

-- -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
-- require("formatter").setup {
 --  -- Enable or disable logging
 --  logging = true,
 --  -- Set the log level
 --  log_level = vim.log.levels.WARN,
 --  -- All formatter configurations are opt-in
 --  filetype = {
 --   nix = {
 --    require("formatter.filetypes.nix").nixpkgs_fmt,
 --   },
 --   ts = {

 --    require("formatter.filetypes.typescript").prettier,
 --   },
 --   py = {
 --      require("formatter.filetypes.python").black,
 --   },
 --    -- Formatter configurations for filetype "lua" go here
 --    -- and will be executed in order
 --    lua = {
 --      -- "formatter.filetypes.lua" defines default configurations for the
 --      -- "lua" filetype
 --      require("formatter.filetypes.lua").stylua,

 --    },

 --    -- Use the special "*" filetype for defining formatter configurations on
 --    -- any filetype
 --    -- ["*"] = {
 --      -- "formatter.filetypes.any" defines default configurations for any
 --      -- filetype
 --      -- require("formatter.filetypes.any").remove_trailing_whitespace
 --    -- }
 --  }
-- }
-- end
 -- },



 -- not as good as null-ls but a recourse
 -- {
 --  'mfussenegger/nvim-lint',
 --  config = function ()
 --    require('lint').linters_by_ft = {
 --      -- markdown = {'vale',}
 --      -- --ignore E501,E265,E402 update.py
 --      python = {'flake8'}
 --    }
 --    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
 --      callback = function()
 --        require("lint").try_lint()
 --      end,
 --    })
 --  end
 -- },
 

 -- {
 --  'stevearc/conform.nvim',
 --  config = function ()
 --    require("conform").setup({
 --        formatters_by_ft = {
 --            lua = { "stylua" },
 --            -- Conform will run multiple formatters sequentially
 --            python = { "isort", "black" },
 --            -- Use a sub-list to run only the first available formatter
 --            javascript = { { "prettierd", "prettier" } },
 --        },
 --    })
 --   end
 -- },
 {
  -- :NullLsLog / NullLsInfo
  'nvimtools/none-ls.nvim',
  config = function()
   local none_ls = require('null-ls')

   -- none_ls.register(require("none-ls-luacheck.diagnostics.luacheck"))
   -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
   -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
   -- none_ls.builtins.diagnostics.shellcheck.with({
   -- For diagnostics sources, you can change the format of diagnostic messages by setting diagnostics_format:
   -- diagnostic_config = {
   -- -- see :help vim.diagnostic.config()
   -- underline = true,
   -- virtual_text = false,
   -- signs = true,
   -- update_in_insert = false,
   -- severity_sort = true,
   -- },
   -- }),

   -- `:NullLsLog`
   none_ls.setup({
    debug = true,

    sources = {
     -- method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
     -- needs a luacheck in PATH
     -- none_ls.none-ls-luacheck.diagnostics.luacheck.with({
     require("none-ls-luacheck.diagnostics.luacheck").with({
      extra_args = { '--ignore 21/_.*' }
     }),
     none_ls.builtins.code_actions.shellcheck,
     -- none_ls.builtins.diagnostics.editorconfig_checker, -- too noisy
     none_ls.builtins.diagnostics.tsc,
     -- doc at https://yamllint.readthedocs.io/en/stable/configuration.html#default-configuration
     none_ls.builtins.diagnostics.yamllint,
     -- .with({
     --  extra_args = { }
     -- }),
     none_ls.builtins.diagnostics.flake8,
     none_ls.builtins.diagnostics.zsh,

     -- use with vim.lsp.buf.format()
     none_ls.builtins.formatting.black,
     none_ls.builtins.formatting.just,
     none_ls.builtins.formatting.yamlfmt, -- from google
     none_ls.builtins.formatting.prettier,
     none_ls.builtins.formatting.markdown_toc,
     none_ls.builtins.formatting.nixpkgs_fmt,
     none_ls.builtins.formatting.treefmt.with({
      -- treefmt requires a config file
      condition = function(utils)
       return utils.root_has_file("treefmt.toml")
      end,
     }),

    },
   })
  end,
   dependencies = {
       "gbprod/none-ls-luacheck.nvim",
   },
 },
 {
  'folke/neodev.nvim',
  config = function()
   -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
   require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
   })
  end
 },

 -- to cycle between different list/listchars configurations
 'teto/vim-listchars',
 {
  "chrishrb/gx.nvim",
  event = { "BufEnter" },
  -- dependencies = { "nvim-lua/plenary.nvim" },
  -- config = true, -- default settings
  -- you can specify also another config if you want
  config = function()
   require("gx").setup {
    open_browser_app = "os_specific",   -- specify your browser app; default for macos is "open" and for linux "xdg-open"
    handlers = {
     plugin = true,                     -- open plugin links in lua (e.g. packer, lazy, ..)
     github = true,                     -- open github issues
     package_json = true,               -- open dependencies from package.json
    },
   }
  end,
 },
 { 'chrisbra/csv.vim',        lazy = true },
 -- { 'rhysd/committia.vim', lazy = true},
 -- {
 --  'lukas-reineke/indent-blankline.nvim',
 --  -- main = "ibl",
 --  -- opts = 
 --  config = function()
 --   require("ibl").setup({
 --    -- debounce = 200,
 --       whitespace = { highlight = { "Whitespace", "NonText" } },
 --       scope = { exclude = { language = { "lua" } } },
 --   -- require('indent_blankline').setup({
 --    -- exclude = { 'terminal' },
 --    -- blankline_use_treesitter,
 --    enabled = false,
 --   })
 --  end,
 -- },
 { 'akinsho/bufferline.nvim'
  -- , dependencies = 'nvim-tree/nvim-web-devicons' 
 },

 {
  'nvim-lualine/lualine.nvim',       -- fork of hoob3rt/lualine
  -- dependencies = { 'arkav/lualine-lsp-progress' },
  config = function()
   require('teto.lualine')
  end,
 },
 {
      -- display function signature in insert mode
  'ray-x/lsp_signature.nvim'
  ,
  config = function()
   -- local has_signature, signature = pcall(require, 'lsp_signature')
   vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Attach lsp_signature on new client",
    callback = function(args)
     if not (args.data and args.data.client_id) then
      return
     end
     local client = vim.lsp.get_client_by_id(args.data.client_id)
     local bufnr = args.buf
     require 'lsp_signature'.on_attach(client, bufnr)
    end
   })
  end
 },
{
  "okuuva/auto-save.nvim", -- fork of pocco81/auto-save.nvim
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "FocusLost" }, -- optional for lazy loading on trigger events
  opts = {
    execution_message = {
      enabled = true,
      message = function() -- message to print on save
        return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
      end,
      dim = 0.18, -- dim the color of `message`
      cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    trigger_events = { -- See :h events
      immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
      defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
      cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
    },
    -- function that takes the buffer handle and determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    -- if set to `nil` then no specific condition is applied
    condition = nil,
    write_all_buffers = false, -- write all buffers when the current one meets `condition`
    noautocmd = false, -- do not execute autocmds when saving
    debounce_delay = 1000, -- delay after which a pending save is executed
   -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
    debug = false,
      -- your config goes here
      -- or just leave it empty :)
    },
  },
 -- {
 --  'Pocco81/AutoSave.nvim',       -- :ASToggle /AsOn / AsOff
 --  config = function()
 --   local autosave = require('auto-save')
 --   autosave.setup({
 --    enabled = true,
 --    -- execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
 --    events = { 'FocusLost' },             -- "InsertLeave"
 --    -- conditions = {
 --    -- 	exists = true,
 --    -- 	filetype_is_not = {},
 --    -- 	modifiable = true
 --    -- },
 --    write_all_buffers = false,
 --    -- on_off_commands = true,
 --    -- clean_command_line_interval = 2500
 --   })
 --  end,
 -- },
 'tpope/vim-rhubarb',
 -- competition to potamides/pantran.nvim which uses just AI backends it seems
 {
  'uga-rosa/translate.nvim',
  lazy = true,
  config = function()
   require('translate').setup({
    default = {
     command = 'translate-shell',
    },
    preset = {
     output = {
      split = {
       append = true,
      },
     },
    },
   })
  end,
 },
}
