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

}

