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
  -- fromEnum MPTCP_ATTR_UNSPEC = 0
  -- fromEnum MPTCP_ATTR_TOKEN = 1
  -- fromEnum MPTCP_ATTR_FAMILY = 2
  -- fromEnum MPTCP_ATTR_LOC_ID = 3
  -- fromEnum MPTCP_ATTR_REM_ID = 4
  -- fromEnum MPTCP_ATTR_SADDR4 = 5
  -- fromEnum MPTCP_ATTR_SADDR6 = 6
  -- fromEnum MPTCP_ATTR_DADDR4 = 7
  -- fromEnum MPTCP_ATTR_DADDR6 = 8
  -- fromEnum MPTCP_ATTR_SPORT = 9
  -- fromEnum MPTCP_ATTR_DPORT = 10
  -- fromEnum MPTCP_ATTR_BACKUP = 11
  -- fromEnum MPTCP_ATTR_ERROR = 12
  -- fromEnum MPTCP_ATTR_FLAGS = 13
  -- fromEnum MPTCP_ATTR_TIMEOUT = 14
  -- fromEnum MPTCP_ATTR_IF_IDX = 15
  -- fromEnum MPTCP_ATTR_CWND = 16

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

local MptcpGenlEvent = {
   	"unspec"
	,"Created master"
	,"Established master"
	,"Closed"
	,"MPTCP_CMD_ANNOUNCE"
	,"MPTCP_CMD_REMOVE"
	,"MPTCP_EVENT_ANNOUNCED"
	,"MPTCP_EVENT_REMOVED"
	,"Create a subflow"
	,"Subflow destroyed"
	,"Subflow established"
	,"Subflow closed"
	,"MPTCP_CMD_SUB_PRIORITY"
	,"MPTCP_EVENT_SUB_PRIORITY"
	,"Set filter"
	,"Exist"
	,"Clamp window"
	,"MPTCP_CMD_AFTER_LAST"
}


-- these Field must already exist !
local netlink_proto_id_f = Field.new("netlink.family")
local genl_family_id_f = Field.new("genl.family_id")
local genl_cmd_f = Field.new("genl.cmd")

-- Our proto
local mptcp_proto = Proto("mptcp_netlink", "test")

-- create the fields for our "protocol"
cmd_f = ProtoField.string("genl.mptcp.cmd","Command")
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
	-- le header netlink commence a partir de l'offset 0x10 apparemment
	local b = tvb:bytes()

	-- local netlink_proto_id = netlink_proto_id_f()
	local genl_family_id = genl_family_id_f()
	-- print ("netlink_proto: ", genl_family_id , " vs ", 0x20)
	if (not genl_family_id) or genl_family_id.value < 0x1f then
		return
	end

    local mptcp_cmd = genl_cmd_f()
	local subtree = tree:add(mptcp_proto, b, "MPTCP netlink")

	-- treeitem:add([protofield], [tvbrange], [value], [label])
	--
	-- local cmd = tvb(0,1):uint()
	local cmd = mptcp_cmd
	print("cmd value=", cmd, type(cmd))
	-- print("cmd in string=", MptcpGenlEvent[cmd + 1])
	-- subtree:add(cmd_f, cmd, "Command"..MptcpGenlEvent[cmd])
	-- ENC_BIG_ENDIAN, ftvbr:string(ENC_UTF_8)

	-- subtree:add_packet_field(cmd_f, tvb(0,1), 0, MptcpGenlEvent[cmd + 1])
	-- subtree:add_packet_field(version_f, tvb(1,1), 0)
	-- subtree:add_packet_field(reserved_f, tvb(2,2), 0)

	cmd_str = MptcpGenlEvent[cmd.value + 1]
	subtree:add(cmd_f, cmd_str)
       -- subtree:add(genl_cmd, "This is a test")
	-- then it's a tlv protocol
end

-- register our protocol as a postdissector
-- register_postdissector(mptcp_proto)
-- load the udp.port table
-- genl.family ("string" table)
-- ou bien netlink.protocol
-- accessible via the GUI: View -> Internals -> Dissector Table
-- run genl ctrl list to get id
local mptcp_id = 0x1d
-- netlink_table = DissectorTable.get("genl.family")
-- local ret = netlink_table:add("mptcp", mptcp_proto)
-- print(netlink_table)
-- en general c 31
-- netlink_table = DissectorTable.get("netlink.protocol")
-- local ret = netlink_table:add("> 0x10", mptcp_proto)
-- print(ret)

-- local function heur_dissect_genl_mptcp (tvb,pinfo,root)
-- 	if netlink
-- 	end
--     -- ok, looks like it's ours, so go dissect it
--     -- note: calling the dissector directly like this is new in 1.11.3
--     -- also note that calling a Dissector object, as this does, means we don't
--     -- get back the return value of the dissector function we created previously
--     -- so it might be better to just call the function directly instead of doing
--     -- this, but this script is used for testing and this tests the call() function
--     mptcp_proto.dissector(tvb,pinfo,root)
-- end

-- now register that heuristic dissector into the udp heuristic list
-- mptcp_proto:register_heuristic("netlink", heur_dissect_genl_mptcp)

register_postdissector(mptcp_proto)


-- or we could do
-- this holds the plain "data" Dissector, in case we can't dissect it as Netlink
-- local data = Dissector.get("data")
