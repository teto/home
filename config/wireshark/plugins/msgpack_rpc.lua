--
-- The MIT License (MIT)
-- Copyright 2015 Sony Corporation
--

do
    if set_plugin_info then
        local my_info = {
            version     = "1.1.0",                                               -- required
            description = "MessagePack-RPC Dissector",                           -- optional
            author      = "Sony Corporation",                                    -- optional
            repository  = "https://github.com/linear-rpc/msgpack-rpc-dissector", -- optional
        }
        set_plugin_info(my_info)
    end

    local current_settings = {
        tcp_ports = "9003-9004,37800",
        ws_ports  = "9005-9009",
    }

    msgpack_rpc_proto = Proto("msgpack-rpc", "MessagePack-RPC")
    local f = msgpack_rpc_proto.fields
    f.type_field = ProtoField.uint8("msgpack-rpc.type", "Type")
    f.msgid_field = ProtoField.uint32("msgpack-rpc.msgid", "Msgid")
    f.method_field = ProtoField.string("msgpack-rpc.method", "Method")
    f.params_field = ProtoField.string("msgpack-rpc.params", "Params")
    f.error_field = ProtoField.string("msgpack-rpc.error", "Error")
    f.result_field = ProtoField.string("msgpack-rpc.result", "Result")
    msgpack_rpc_proto.prefs.tcp_ports = Pref.range(
        "TCP Port numbers",
        current_settings.tcp_ports,
        "The TCP port numbers for MessagePack-RPC",
        65535
    )
    msgpack_rpc_proto.prefs.ws_ports = Pref.range(
        "WebSocket Port numbers",
        current_settings.ws_ports,
        "The WebSocket port numbers for MessagePack-RPC",
        65535
    )

    function msgpack_rpc_proto.prefs_changed()
        if current_settings.tcp_ports ~= msgpack_rpc_proto.prefs.tcp_ports then
            -- remove old one
            DissectorTable.get("tcp.port"):remove(current_settings.tcp_ports, msgpack_rpc_proto)
            -- set our new default
            current_settings.tcp_ports = msgpack_rpc_proto.prefs.tcp_ports
            -- add new one
            DissectorTable.get("tcp.port"):add(current_settings.tcp_ports, msgpack_rpc_proto)
        end
        if current_settings.ws_ports ~= msgpack_rpc_proto.prefs.ws_ports then
            -- remove old one
            DissectorTable.get("ws.port"):remove(current_settings.ws_ports, msgpack_rpc_proto)
            -- set our new default
            current_settings.ws_ports = msgpack_rpc_proto.prefs.ws_ports
            -- add new one
            DissectorTable.get("ws.port"):add(current_settings.ws_ports, msgpack_rpc_proto)
        end
    end

    local mp = require "MessagePack"

    function table_print(tt)
        local len = 0
        local is_array = true
        for key, value in pairs(tt) do
            if "number" ~= type(key) then
                is_array = false
            end
            len = len + 1
        end

        local sb = {}
        if is_array then
            table.insert(sb, "[")
        else
            table.insert(sb, "{")
        end
        local i = 1
        for key, value in pairs(tt) do
            if is_array then
                table.insert(sb, stringify(value))
            else
                table.insert(sb, stringify(key) .. ": " .. stringify(value))
            end
            if i < len then
                table.insert(sb, ", ")
            end
            i = i + 1
        end
        if is_array then
            table.insert(sb, "]")
        else
            table.insert(sb, "}")
        end
        return table.concat(sb)
    end

    function stringify(obj)
        if "nil" == type(obj) then
            return tostring(nil)
        elseif "table" == type(obj) then
            return table_print(obj)
        elseif "string" == type(obj) then
            return "\'" .. obj .. "\'"
        else
            return tostring(obj)
        end
    end

    function is_array(ar)
        local is_array = true
        if "table" == type(ar) then
            for key, value in pairs(ar) do
                if "number" ~= type(key) then
                    is_array = false
                end
            end
        else
            is_array = false
        end
        return is_array
    end

    function is_number(num)
        if "number" == type(num) then
            return true
        end
        return false
    end

    function is_string(str)
        if "string" == type(str) then
            return true
        end
        return false
    end

    local str
    local substr

    function msgpack_rpc_proto.dissector(tvb, pinfo, tree)
        local proto_name = "MessagePack-RPC"
        local b = tvb():bytes()

        str = ""
        for i = 0, b:len() - 1 do
            str = str .. string.char(b:get_index(i))
        end

        substr = str:sub(1, 1)
        if substr ~= string.char(0x94) and substr ~= string.char(0x93) then
            return
        end

        local flag, ret = pcall(mp.unpack, str)
        if not flag then
            if ret:find("missing bytes$") then
                pinfo.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
                return
            else
                error(ret)
            end
        end

        substr = str:sub(2, str:len())

        local n = 1
        local pair = {}
        for csr, val in mp.unpacker(substr) do
            pair[n] = {csr, val}
            n = n + 1
        end

        local subtree = tree:add(msgpack_rpc_proto, tvb(), "MessagePack-RPC Protocol")
        -- type
        if pair[1][2] == 0 then            -- requiest
            subtree:add(f.type_field, tvb(pair[1][1], pair[2][1] - pair[1][1]), pair[1][2]):append_text(" (Request)")
            -- msgid
            if not is_number(pair[2][2]) then
                return
            end
            subtree:add(f.msgid_field, tvb(pair[2][1], pair[3][1] - pair[2][1]), pair[2][2])
            -- method
            if not is_string(pair[3][2]) then
                return
            end
            subtree:add(f.method_field, tvb(pair[3][1], pair[4][1] - pair[3][1]), pair[3][2], "Method: " .. stringify(pair[3][2]))
            -- params
            if not is_array(pair[4][2]) then
                proto_name = proto_name .. " (dirty)"
            end
            subtree:add(f.params_field, tvb(pair[4][1], tvb:len() - pair[4][1]), stringify(pair[4][2]))
        elseif pair[1][2] == 1 then    -- response
            subtree:add(f.type_field, tvb(pair[1][1], pair[2][1] - pair[1][1]), pair[1][2]):append_text(" (Response)")
            -- msgid
            if not is_number(pair[2][2]) then
                return
            end
            subtree:add(f.msgid_field, tvb(pair[2][1], pair[3][1] - pair[2][1]), pair[2][2])
            -- error
            subtree:add(f.error_field, tvb(pair[3][1], pair[4][1] - pair[3][1]), stringify(pair[3][2]))
            -- result
            subtree:add(f.result_field, tvb(pair[4][1], tvb:len() - pair[4][1]), stringify(pair[4][2]))
        elseif pair[1][2] == 2 then    -- notify
            subtree:add(f.type_field, tvb(pair[1][1], pair[2][1] - pair[1][1]), pair[1][2]):append_text(" (Notify)")
            -- method
            if not is_string(pair[2][2]) then
                return
            end
            subtree:add(f.method_field, tvb(pair[2][1], pair[3][1] - pair[2][1]), pair[2][2], "Method: " .. stringify(pair[2][2]))
            -- params
            if not is_array(pair[3][2]) then
                proto_name = proto_name .. " (dirty)"
            end
            subtree:add(f.params_field, tvb(pair[3][1], tvb:len() - pair[3][1]), stringify(pair[3][2]))
        else
            return
        end
        pinfo.cols.protocol = proto_name
    end

    DissectorTable.get("tcp.port"):add(current_settings.tcp_ports, msgpack_rpc_proto)
    DissectorTable.get("ws.port"):add(current_settings.ws_ports, msgpack_rpc_proto)
end
