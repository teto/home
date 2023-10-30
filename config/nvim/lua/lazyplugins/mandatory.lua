return {
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
   none_ls.setup({
    sources = {
     -- method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
     -- needs a luacheck in PATH
     none_ls.builtins.diagnostics.luacheck.with({
      extra_args = { '--ignore 21/_.*' }
     }),
     none_ls.builtins.code_actions.shellcheck,
     -- none_ls.builtins.diagnostics.editorconfig_checker, -- too noisy
     -- none_ls.builtins.diagnostics.teal,
     -- none_ls.builtins.diagnostics.tsc
     -- none_ls.builtins.diagnostics.yamllint,
     none_ls.builtins.diagnostics.flake8,
     none_ls.builtins.diagnostics.zsh,
     none_ls.builtins.formatting.just,
     none_ls.builtins.formatting.markdown_toc,
     -- none_ls.builtins.formatting.nixpkgs_fmt,
     none_ls.builtins.formatting.treefmt.with({
      -- treefmt requires a config file
      condition = function(utils)
       return utils.root_has_file("treefmt.toml")
      end,
     }),
    },
   })
  end,
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
 -- <leader>ml to setup buffer modeline
 -- 'teto/Modeliner', -- not needed with editorconfig ?
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
  "okuuva/auto-save.nvim",
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "FocusLost" }, -- optional for lazy loading on trigger events
  opts = {
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
