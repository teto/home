local ls = require('luasnip')

local snip = ls.snippet
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local func = ls.function_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node

local function uuid()
    local id, _ = vim.fn.system('uuidgen'):gsub('\n', '')
    return id
end

ls.add_snippets('global', {
    s({
        trig = 'uuid',
        name = 'UUID',
        dscr = 'Generate a unique UUID',
    }, {
        d(1, function()
            return sn(nil, i(1, uuid()))
        end),
    }),
})

-- |"warn"|"info"|"debug")
ls.log.set_loglevel('debug')
-- ls.log.ping()

vim.keymap.set({ 'i', 's' }, '<C-E>', function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

-- ls.add_snippets(filetype, snippets)
-- require("luasnip-snippets").load_snippets()
-- require("luasnip.loaders").edit_snippet_files(opts:table|nil)
--
-- require("luasnip.loaders.from_lua").load()

-- loads lua files
require('luasnip.loaders.from_lua').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })

-- loads json(c) files if there is a package.json
require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets-vs' } })

-- require("luasnip.loaders.from_vscode").lazy_load()
ls.config.setup({})

-- see also :h haskell-snippets
-- needs a treesitter grammar
-- local haskell_snippets = require('haskell-snippets').all
-- ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })

local date = function()
    return { os.date('%Y-%m-%d') }
end
ls.add_snippets(nil, {
    all = {
        snip({
            trig = 'date',
            namr = 'Date',
            dscr = 'Date in the form of YYYY-MM-DD',
        }, {
            func(date, {}),
        }),
    },
    sh = {
        snip('shebang', {
            t({ '#!/bin/sh', '' }),
            i(0),
        }),
    },
    -- python = {
    --     snip("shebang", {
    --         t { "#!/usr/bin/env python", "" },
    --         i(0),
    --     }),
    -- },
})

-- ls.add_snippets("lua", {
-- 	-- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
-- 	s("fn", {
-- 		-- Simple static text.
-- 		t("//Parameters: "),
-- 		-- function, first parameter is the function, second the Placeholders
-- 		-- whose text it gets as input.
-- 		-- f(copy, 2),
-- 		t({ "", "function " }),
-- 		-- Placeholder/Insert.
-- 		i(1),
-- 		t("("),
-- 		-- Placeholder with initial text.
-- 		i(2, "int foo"),
-- 		-- Linebreak
-- 		t({ ") {", "\t" }),
-- 		-- Last Placeholder, exit Point of the snippet.
-- 		i(0),
-- 		t({ "", "}" }),
-- 	}),
-- })

require('luasnip.loaders.from_lua').load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
