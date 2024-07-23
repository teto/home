-- require('cmp').register_source('month', source)
-- local has_cmp, cmp = pcall(require, 'cmp')
local cmp = require'cmp'
-- if has_cmp then
   -- nvim_cmp should be disabled when 'prompt'

   -- use('michaeladler/cmp-notmuch')
   -- nvim-cmp autocompletion plugin{{{
   cmp_sources = {
	   { name = 'nvim_lsp' },
	   { name = 'buffer' },
	   -- { name = "cmp-dbee" },
   }


   -- TODO auto insert into cmp
   if use_neorg then
	   table.insert(cmp_sources, { name = 'neorg' })
   end
   if use_org then
	   table.insert(cmp_sources, { name = 'orgmode' })
   end
   if use_luasnip then
	   -- For luasnip user.
	   -- " Plug 'saadparwaiz1/cmp_luasnip'
	   table.insert(cmp_sources, { name = 'luasnip' })
   end

   --[[
   :CmpStatus
   ]]
   cmp.setup({

	   -- disable autocompletion in prompt (wasn't playing good with telescope)
	   -- https://github.com/hrsh7th/nvim-cmp/issues/1747
	   enabled = function()
		   -- return vim.g.cmptoggle
		   -- return true
		   buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
		   if buftype == 'prompt' then
			   return false
		   end

		   return true
		   -- local context = require 'cmp.config.context'
		   -- -- disable autocompletion in comments
		   -- return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
	   end,
	   preselect = cmp.PreselectMode.None,
	   completion = {
		   -- autocomplete = true
		   -- local types = require('cmp.types')
		   -- autocomplete is on by default and it should only be a trigger event array or false
		   autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
		  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		  col_offset = -3,
		  side_padding = 0,
	   },
	   view = {
		   -- entries = 'custom', -- can be "custom", "wildmenu" or "native"
		   entries = {
			name = 'custom',
			selection_order = 'near_cursor'
		   } ,
		   docs = {
			auto_open = true
		   }
	   },
	   sorting = {
		   comparators = {
			   cmp.config.compare.offset,
			   cmp.config.compare.exact,
			   cmp.config.compare.score,
			   cmp.config.compare.kind,
			   -- cmp.config.compare.sort_text,
			   cmp.config.compare.length,
			   cmp.config.compare.order,
		   },
	   },
	   -- commented to prevent 'Unknown function: vsnip#anonymous'
	   snippet = {
		   -- SNIPPET SUPPORT MANDATORY in cmp
		   expand = function(args)
			   -- For `vsnip` user. broken
			   -- vim.fn['vsnip#anonymous'](args.body)

			   -- For `luasnip` user.
			   require('luasnip').lsp_expand(args.body)
		   end,
	   },
	   mapping = cmp.mapping.preset.insert({
		   ['<CR>'] = cmp.mapping.confirm({ select = true }),
		   ['<C-n>'] = cmp.mapping.select_next_item(),
		   ['<C-p>'] = cmp.mapping.select_prev_item(),
			['<C-g>'] = function()
			  if cmp.visible_docs() then
				cmp.close_docs()
			  else
				cmp.open_docs()
			  end
			end,

	   }),
	   -- mapping = cmp.mapping.preset.insert({

	   -- 	['<C-d>'] = cmp.mapping.scroll_docs(-4),
	   -- 	['<C-f>'] = cmp.mapping.scroll_docs(4),
	   -- 	--   ['<C-Space>'] = cmp.mapping.complete(),
	   -- 	--   ['<C-e>'] = cmp.mapping.close(),
	   -- 	['<CR>'] = cmp.mapping.confirm({ select = true }),
	   -- }),
	   -- view = {
	   -- 	entries = 'native'
	   -- },
	   sources = cmp_sources,
	   window = {
		   completion = cmp.config.window.bordered(),
		   documentation = cmp.config.window.bordered({ max_width = 300 }),
	   },
	  formatting = {
		-- An array of completion fields to specify their order.
		fields = { "kind", "abbr", "menu" },

		-- see :h complete-items
		format = function(entry, vim_item)
		  local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
		  local strings = vim.split(kind.kind, "%s", { trimempty = true })
		  kind.kind = " " .. (strings[1] or "") .. " "
		  kind.menu = "    (" .. (strings[2] or "") .. ")"
		  kind.menu = "TOTO"
		  -- kind.info = "TATA"

		  return kind
		end,
	  },
   })

   -- Set configuration for specific filetype.
   cmp.setup.filetype('gitcommit', {
	   sources = cmp.config.sources({
		   -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		   { name = 'git' },
	   }, {
		   { name = 'buffer' },
	   }),
   })

   -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
   -- cmp.setup.cmdline({ '/', '?' }, {
   --   mapping = cmp.mapping.preset.cmdline(),
   --   sources = {
   --     { name = 'buffer' }
   --   }
   -- })

   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
   -- cmp.setup.cmdline(':', {
   --   mapping = cmp.mapping.preset.cmdline(),
   --   sources = cmp.config.sources({
   --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
   -- })
   --  }}}

