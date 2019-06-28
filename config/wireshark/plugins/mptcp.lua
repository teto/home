-- taken from my own project
--
-- trivial postdissector example
-- declare some Fields to be read
-- ip_src_f = Field.new("ip.src")
-- ip_dst_f = Field.new("ip.dst")
-- tcp_src_f = Field.new("tcp.srcport")
-- tcp_dst_f = Field.new("tcp.dstport")
-- declare our (pseudo) protocol


-- data MptcpGenlEvent = MPTCP_CMD_UNSPEC
--                     | MPTCP_EVENT_CREATED
--                     | MPTCP_EVENT_ESTABLISHED
--                     | MPTCP_EVENT_CLOSED
--                     | MPTCP_CMD_ANNOUNCE
--                     | MPTCP_CMD_REMOVE
--                     | MPTCP_EVENT_ANNOUNCED
--                     | MPTCP_EVENT_REMOVED
--                     | MPTCP_CMD_SUB_CREATE
--                     | MPTCP_CMD_SUB_DESTROY
--                     | MPTCP_EVENT_SUB_ESTABLISHED
--                     | MPTCP_EVENT_SUB_CLOSED
--                     | MPTCP_CMD_SUB_PRIORITY
--                     | MPTCP_EVENT_SUB_PRIORITY
--                     | MPTCP_CMD_SET_FILTER
--                     | MPTCP_CMD_EXIST
--                     | MPTCP_CMD_SND_CLAMP_WINDOW
--                     | MPTCP_CMD_AFTER_LAST

local genl_cmd_f = Field.new("genl.cmd")
local genl_family_f = Field.new("genl.family_id")


mptcp_proto = Proto("genl.mptcp","MPTCP genl dissector")
-- create the fields for our "protocol"
cmd_f = ProtoField.string("genl.mptcp.cmd","Command")
-- dst_F = ProtoField.string("trivial.dst","Destination")
-- conv_F = ProtoField.string("trivial.conv","Conversation","A Conversation")

-- add the field to the protocol
mptcp_proto.fields = {src_F, dst_F, conv_F}
-- create a function to "postdissect" each frame
function mptcp_proto.dissector(buffer,pinfo,tree)
    -- obtain the current values the protocol fields
    local genl_cmd = genl_cmd_f()
    -- local tcp_dst = tcp_dst_f()
    -- local ip_src = ip_src_f()
    -- local ip_dst = ip_dst_f()
    if genl_cmd then
       local subtree = tree:add(mptcp_proto, "MPTCP netlink")
       -- local src = tostring(ip_src) .. ":" .. tostring(tcp_src)
       -- local dst = tostring(ip_dst) .. ":" .. tostring(tcp_dst)
       -- local conv = src  .. "->" .. dst
       subtree:add(genl_cmd, "test matt")
       -- subtree:add(dst_F,dst)
       -- subtree:add(conv_F,conv)
    end
end
-- register our protocol as a postdissector
-- register_postdissector(mptcp_proto)
-- load the udp.port table
-- genl.family ("string" table)
-- ou bien netlink.protocol
udp_table = DissectorTable.get("genl.family")
-- en general c 31
udp_table:add(31, mptcp_proto)

