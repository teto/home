require('statuscol').setup({
    -- configuration goes here, for example:
    -- relculright = true,
    -- segments = {
    --   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    --   {
    --     sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
    --     click = "v:lua.ScSa"
    --   },
    --   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
    --   {
    --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
    --     click = "v:lua.ScSa"
    --   },
    -- }
})
local builtin = require('statuscol.builtin')
local cfg = {
    setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
    -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
    -- Although I recommend just using the segments field below to build your
    -- statuscolumn to benefit from the performance optimizations in this plugin.
    -- builtin.lnumfunc number string options
    thousands = false, -- or line number thousands separator string ("." / ",")
    relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
    -- Builtin 'statuscolumn' options
    ft_ignore = nil, -- Lua table with 'filetype' values for which 'statuscolumn' will be unset
    bt_ignore = nil, -- Lua table with 'buftype' values for which 'statuscolumn' will be unset
    -- Default segments (fold -> sign -> line number + separator), explained below
    --  segments = {
    --    -- { text = { "%C" }, click = "v:lua.ScFa" },
    --    -- { text = { "%s" }, click = "v:lua.ScSa" },
    -- builtin.foldfunc
    --    {
    --      text = { builtin.lnumfunc, " " },
    --      condition = { true, builtin.not_empty },
    --      click = "v:lua.ScLa",
    --    }
    --  },
    segments = {
        {
            sign = {
                name = { '.*' },
                text = { '.*' },
            },
            click = 'v:lua.ScSa',
        },
        {
            text = { builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            -- lnum_click
            -- line action
            click = 'v:lua.ScLa',
        },
        {
            sign = { namespace = { 'gitsigns' }, colwidth = 1, wrap = true },
            -- Sign action
            click = 'v:lua.ScSa',
        },
        {
            text = {
                function(args)
                    args.fold.close = ''
                    args.fold.open = ''
                    args.fold.sep = '▕'
                    return builtin.foldfunc(args)
                end,
            },
            -- Fa => Fold action
            click = 'v:lua.ScFa',
        },
    },
    clickmod = 'c', -- modifier used for certain actions in the builtin clickhandlers:
    -- "a" for Alt, "c" for Ctrl and "m" for Meta.
    clickhandlers = { -- builtin click handlers, keys are pattern matched
        -- lnum_click adds breakpoints with sign "B"
        -- :lua require'dap'.list_breakpoints()  lists breakpoints in quickfix
        Lnum = builtin.lnum_click,
        -- Lnum = function ()
        -- 	  vim.notify("line click")
        -- 	 end,

        FoldClose = builtin.foldclose_click,
        FoldOpen = builtin.foldopen_click,
        FoldOther = builtin.foldother_click,
        DapBreakpointRejected = builtin.toggle_breakpoint,
        DapBreakpoint = builtin.toggle_breakpoint,
        DapBreakpointCondition = builtin.toggle_breakpoint,
        ['diagnostic/signs'] = builtin.diagnostic_click,
        gitsigns = builtin.gitsigns_click,
    },
}
require('statuscol').setup(cfg)
