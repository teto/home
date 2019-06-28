-- print("user init.lua loaded")

-- copied from https://www.wireshark.org/docs/wsdg_html_chunked/wslua_menu_example.html
-- if gui_enabled() then
--    local splash = TextWindow.new("Hello!");
--    splash:set("This time wireshark has been enhanced with a useless feature.\n")
--    splash:append("Go to 'Tools->Lua Dialog Test' and check it out!")
-- end

-- local function dialog_menu()
--     local function dialog_func(person,eyes,hair)
--         local window = TextWindow.new("Person Info");
--         local message = string.format("Person %s with %s eyes and %s hair.", person, eyes, hair);
--         window:set(message);
--     end

--     new_dialog("Dialog Test",dialog_func,"A Person","Eyes","Hair")
-- end

-- register_menu("Lua Dialog Test",dialog_menu,MENU_TOOLS_UNSORTED)
