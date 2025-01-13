local b = require('blink.cmp')
b.setup({
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
	fuzzy = {
	 implementation = "rust"
	 -- ~/.local/share/nvim/lazy/blink.cmp/target/release/libblink_cmp_fuzzy.so
	 --
      -- sorts = {
      --   function(a, b)
      --     if a.client_name == nil or b.client_name == nil then return end
      --     return b.client_name == 'emmet_ls'
      --   end,
      --   -- default sorts
      --   'score',
      --   'sort_text',
	  -- },

	},
    -- your own keymap.
    keymap = {
        preset = 'default',
    },
	cmdline = {
	 -- disable in cmdline
	  -- sources = {},

	  keymap = {
		 -- preset = 'super-tab',
	  },
	},

    completion = {
        trigger = {
            show_on_trigger_character = true,
        },
        list = {
            selection = {
                preselect = true,

                -- When `true`, inserts the completion item automatically when selecting it
                -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
                -- which will both undo the selection and hide the completion menu
                auto_insert = true,
                -- auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
            },
            -- autoselect = true,
            -- selection = "auto_insert";
        },
        documentation = {
            -- Controls whether the documentation window will automatically show when selecting a completion item
            auto_show = true,
        },
        menu = {
            enabled = true,
            min_width = 15,
            max_height = 10,
            border = 'none',
            -- winblend = 0,
            -- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
            -- Keep the cursor X lines away from the top/bottom of the window
            scrolloff = 2,
            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = true,
            -- Which directions to show the window,
            -- falling back to the next direction when there's not enough space
            direction_priority = { 's', 'n' },

            -- Whether to automatically show the window when new completion items are available
            auto_show = true,

            -- Screen coordinates of the command line
            --   cmdline_position = function()
            -- if vim.g.ui_cmdline_pos ~= nil then
            --  local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            --  return { pos[1] - 1, pos[2] }
            -- end
            -- local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            -- return { vim.o.lines - height, 0 }
            --   end,
            draw = {
                -- Aligns the keyword you've typed to a component in the menu
                align_to = 'cursor', -- or 'none' to disable, or 'cursor' to align to the cursor
                -- Left and right padding, optionally { left, right } for different padding on each side
                padding = 1,
                -- Gap between columns
                gap = 1,
                -- Use treesitter to highlight the label text for the given list of sources
                treesitter = {},
                -- treesitter = { 'lsp' }

                -- Components to render, grouped by column
                columns = {
                    -- { 'kind_icon' },
                    { 'label', 'label_description', gap = 1 },
                    { 'source_name' },
                },

                -- Definitions for possible components to render. Each defines:
                --   ellipsis: whether to add an ellipsis when truncating the text
                --   width: control the min, max and fill behavior of the component
                --   text function: will be called for each item
                --   highlight function: will be called only when the line appears on screen
                components = {
                    -- kind_icon = {
                    --   ellipsis = false,
                    --   text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
                    --   highlight = function(ctx)
                    -- 	return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
                    --   end,
                    -- },

                    -- kind = {
                    --   ellipsis = false,
                    --   width = { fill = true },
                    --   text = function(ctx) return ctx.kind end,
                    --   highlight = function(ctx)
                    -- 	return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
                    --   end,
                    -- },

                    -- label = {
                    --   width = { fill = true, max = 60 },
                    --   text = function(ctx) return ctx.label .. ctx.label_detail end,
                    --   highlight = function(ctx)
                    -- 	-- label and label details
                    -- 	local highlights = {
                    -- 	  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                    -- 	}
                    -- 	if ctx.label_detail then
                    -- 	  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                    -- 	end
                    --
                    -- 	-- characters matched on the label by the fuzzy matcher
                    -- 	for _, idx in ipairs(ctx.label_matched_indices) do
                    -- 	  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                    -- 	end
                    --
                    -- 	return highlights
                    --   end,
                    -- },

                    -- label_description = {
                    --   width = { max = 30 },
                    --   text = function(ctx) return ctx.label_description end,
                    --   highlight = 'BlinkCmpLabelDescription',
                    -- },
                    --
                    -- source_name = {
                    --   width = { max = 30 },
                    --   text = function(ctx) return ctx.source_name end,
                    --   highlight = 'BlinkCmpSource',
                    -- },
                },
            },
        },
    },

    -- highlight = {
    --     -- sets the fallback highlight groups to nvim-cmp's highlight groups
    --     -- useful for when your theme doesn't support blink.cmp
    --     -- will be removed in a future release, assuming themes add support
    --     use_nvim_cmp_as_default = true,
    -- },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    -- nerd_font_variant = 'mono',

    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }

    -- experimental signature help support
    -- trigger = { signature_help = { enabled = true } }
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    -- opts_extend = { "sources.completion.enabled_providers" }
    snippets = { 
	 -- preset = 'luasnip' 
	},
    -- ensure you have the `snippets` source (enabled by default)
    sources = {
        default = {
		  'lsp', 'path', 'snippets', 'buffer' ,
		  'git'
		 },
		providers = {
			git = {
				module = 'blink-cmp-git',
				name = 'Git',
				opts = {
					-- options for the blink-cmp-git
				},

			},
			snippets = {
			 opts = {
			  search_path = "";
			 }
			}
		}
    },
    --    menu = {
    --      -- Don't automatically show the completion menu
    --      auto_show = false,
    -- }
})

-- example calling setup directly for each LSP
config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    lspconfig['lua-ls'].setup({ capabilities = capabilities })
end
