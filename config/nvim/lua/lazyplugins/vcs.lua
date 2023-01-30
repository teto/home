return {
 { 'pwntester/octo.nvim', config = function ()
        require 'octo'.setup({
            default_remote = { 'up', 'upstream', 'origin' }, -- order to try remotes
    --         reaction_viewer_hint_icon = '', -- marker for user reactions
    --         user_icon = ' ', -- user icon
    --         timeline_marker = '', -- timeline marker
    --         timeline_indent = '2', -- timeline indentation
    --         right_bubble_delimiter = '', -- Bubble delimiter
    --         left_bubble_delimiter = '', -- Bubble delimiter
    --         github_hostname = '', -- GitHub Enterprise host
          })
         end
}
-- 'mhinz/vim-signify'
-- vim.api.nvim_set_hl(0, 'SignifySignChange', {
-- 	cterm = { bold = true },
-- 	ctermbg = 237,
-- 	ctermfg = 227,
-- 	bg = 'NONE',
-- 	fg = '#F08A1F',
-- })
-- vim.api.nvim_set_hl(
-- 	0,
-- 	'SignifySignAdd',
-- 	{ cterm = { bold = true }, ctermbg = 237, ctermfg = 227, bg = 'NONE', fg = 'green' }
-- )
-- vim.api.nvim_set_hl(
-- 	0,
-- 	'SignifySignDelete',
-- 	{ cterm = { bold = true }, ctermbg = 237, ctermfg = 227, bg = 'NONE', fg = 'red' }
-- )


}

