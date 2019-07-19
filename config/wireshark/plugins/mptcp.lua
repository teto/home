-- taken from my own project
-- reload via Analyze -> Reload
-- lua api https://www.wireshark.org/docs/wsdg_html_chunked/wsluarm_modules.html

local my_info = {
	version     = "0.0.1",                                               -- required
	description = "MPTCP netlink decoded",                           -- optional
	-- author      = "Matthieu Coudron ",                                    -- optional
	-- repository  = "https://github.com/linear-rpc/msgpack-rpc-dissector", -- optional
}
set_plugin_info(my_info)

local MptcpAttr = {
   	"unspec "
	," MPTCP_ATTR_TOKEN"
	," MPTCP_ATTR_FAMILY"
	," MPTCP_ATTR_LOC_ID"
	," MPTCP_ATTR_REM_ID"
	," MPTCP_ATTR_SADDR4"
	," MPTCP_ATTR_SADDR6"
	," MPTCP_ATTR_DADDR4"
	," MPTCP_ATTR_DADDR6"
	," MPTCP_ATTR_SPORT"
	," MPTCP_ATTR_DPORT"
	," MPTCP_ATTR_BACKUP"
	," MPTCP_ATTR_ERROR"
	," MPTCP_ATTR_FLAGS"
	," MPTCP_ATTR_TIMEOUT"
	," MPTCP_ATTR_IF_IDX"
	," MPTCP_ATTR_CWND"
}

local MptcpGenlEvent = { "unspec"
                    ,"Created"
                    ,"Established"
                    ,"Closed"
                    ,"MPTCP_CMD_ANNOUNCE"
                    ,"MPTCP_CMD_REMOVE"
                    ,"MPTCP_EVENT_ANNOUNCED"
                    ,"MPTCP_EVENT_REMOVED"
                    ,"Subflow Created"
                    ,"Subflow destroyed"
                    ,"Subflow established"
                    ,"Subflow closed"
                    ,"MPTCP_CMD_SUB_PRIORITY"
                    ,"MPTCP_EVENT_SUB_PRIORITY"
                    ,"Set filter"
                    ,"Exist"
                    ,"Clamped window"
                    ,"MPTCP_CMD_AFTER_LAST"
				}

-- these Field must already exist !
local genl_cmd_f = Field.new("genl.cmd")
local mptcp_proto = Proto("matt", "test")

-- create the fields for our "protocol"
cmd_f = ProtoField.uint8("genl.mptcp.cmd","Command", base.DEC)
version_f = ProtoField.uint8("genl.mptcp.version","MPTCP genl version", base.DEC)
reserved_f = ProtoField.uint16("genl.mptcp.reserved","Reserved", base.DEC)

-- add the field to the protocol
-- only accepts ProtoField
mptcp_proto.fields = {
	cmd_f,
	version_f,
	reserved_f
}

function mptcp_proto.dissector(tvb,pinfo,tree)
    -- obtain the current values the protocol fields
    local mptcp_cmd = genl_cmd_f()
	local b = tvb:bytes()
	local subtree = tree:add(mptcp_proto, b, "MPTCP netlink")

	-- treeitem:add([protofield], [tvbrange], [value], [label])
	local cmd = tvb(0,1):uint()
	print("cmd value=", cmd, type(cmd))
	print("cmd in string=", MptcpGenlEvent[cmd + 1])
	-- subtree:add(cmd_f, cmd, "Command"..MptcpGenlEvent[cmd])
	-- ENC_BIG_ENDIAN, ftvbr:string(ENC_UTF_8)
	subtree:add_packet_field(cmd_f, tvb(0,1), 0, MptcpGenlEvent[cmd + 1])
	subtree:add_packet_field(version_f, tvb(1,1), 0)
	subtree:add_packet_field(reserved_f, tvb(2,2), 0)
	-- subtree:add(cmd_f, cmd, "Command"..MptcpGenlEvent[cmd])
       -- subtree:add(genl_cmd, "This is a test")
	-- then it's a tlv protocol
end

-- register our protocol as a postdissector
-- register_postdissector(mptcp_proto)
-- load the udp.port table
-- genl.family ("string" table)
-- ou bien netlink.protocol
-- accessible via the GUI: View -> Internals -> Dissector Table
netlink_table = DissectorTable.get("genl.family")
-- print("toto")
print(netlink_table)
-- en general c 31
local ret = netlink_table:add("mptcp", mptcp_proto)
print(ret)



-- or we could do
-- this holds the plain "data" Dissector, in case we can't dissect it as Netlink
-- local data = Dissector.get("data")
