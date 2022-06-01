local M = {}
-- " use emenu ("execute menu") to launch the command
-- " disable all menus
-- unmenu *
-- " menu Spell.EN_US :setlocal spell spelllang=en_us \| call histadd('cmd', 'setlocal spell spelllang=en_us')<CR>
-- menu Spell.&FR :setlocal spell spelllang=fr_fr<CR>
-- " menu Spell.EN_US :setlocal spell spelllang=en_us<CR>
-- menu <script> Spell.&EN_US :setlocal spell spelllang=en_us<CR>
-- menu ]Spell.hidden should be hidden

-- menu Trans.FR :te trans :fr <cword><CR>
-- " defines a tip
-- tmenu Trans.FR Traduire vers le francais
tabMenu = {
["Tabs.S2"]= ":set  tabstop=2 softtabstop=2 sw=2<CR>",
["Tabs.S4"]= ":set ts=4 sts=4 sw=4<CR>",
["Tabs.S6"]= ":set ts=6 sts=6 sw=6<CR>",
["Tabs.S8"]= ":set ts=8 sts=8 sw=8<CR>",
["Tabs.SwitchExpandTabs"] = ":set expandtab!"
}

M.menu_add = function(name, command)

   res = vim.cmd ([[menu ]]..name..[[ ]]..command)
   -- print(res)
end



return M
