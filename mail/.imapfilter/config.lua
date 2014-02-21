require('os')                                                                          
get_netrc_pwd = function (machine, login)
f = io.open(os.getenv('HOME') .. '/.netrc', 'r')


    l = f:read("*all") 
    pattern = 'machine '..machine..' login '..login..' password (%w+)'
	print("pattern", pattern)
    pwd = l:match(pattern)
    print("result:", pwd)
    return pwd
end 


-- dofile('./load.lua')
options.timeout = 120
options.cache = 0
options.subscribe = true

-- TODO load password from .netrc 
myaccount = IMAP {
	server = 'imap.gmail.com',
	username = 'mattator',
	password = get_netrc_pwd('imap.gmail.com','mattator@gmail.com'),
	ssl = "tls1"
}




myaccount.INBOX:check_status()


myaddresses = {
}

-- format mailing list, dst folder, subscription state
ml = {
	
	{"trill@ietf.org", "trill",true},
	{"lisp@ietf.org", "lisp",true},
	{"mptcp@ietf.org", "mptcp",true},
	{"mptcp-dev@listes.uclouvain.be", "mptcp", true},
	{ "debian-security-announce@lists.debian.org", "debian", false},
	{"boost-users@lists.boost.org","boost", false},
	{"lua-l@lists.lua.org","lua",true},
	{"luabind-user@lists.sourceforge.net","lua",true},
	{"@lispmob.org","lispmob",true},
	{"libnl@lists.infradead.org","libnl",true},
	{"@frnog.org","frnog",true}

}


generate_mutt_file = function (list,filename)
	-- list mailing list I've subscribed to
	local subscribe = "subscribe "
	-- lists identify mailing lists, even if I don't subscribe to them
	local lists = "lists "
	--local alternates = ""
	for _,entry in pairs(list) do
		local email = entry[1]
		local dst = entry[2]
		local subscribed = entry [3]

		print(email, dst, subscribe)
		if subscribed  then
			subscribe = subscribe.." "..email
		else
			lists = lists.." "..email
		end
		results = myaccount.INBOX:contain_to( email ) + myaccount.INBOX:contain_cc( email)
		results:move_messages(myaccount[dst])

	end
	
	--p
	--subscribe = subscribe + "\n"
	--lists = lists + "\n"
	f = io.open(filename,"w")
	f:write(subscribe.."\n"..lists.."\n" )
	f:close()
end


generate_mutt_file(ml, os.getenv("MUTT").."/mailing_lists.mutt")
messages = myaccount.INBOX:select_all()
ml_filters = {
	

}


function parseRule(account, field,value,dst)
    subresults = res:contain_field(field,value)
    if subresults:move_messages( account[dst] ) == false then
      print("Cannot move messages to !"..dst)
    end
end

-- @param res         the table of messages to filter
-- @param ruleTable   the table of rules to match messages against
function parseRules( res, ruleTable )
local subresults = {}
  for _,entry in pairs(ruleTable) do
	--print(entry[1], entry [2] , entry[3])
    -- don't use match_field, it downloads part of the msg (slow)
	parseRule( entry[1], entry[2] )
	
  end
end


--parseRules( messages, ml_filters)

--results = myaccount.INBOX:contain_to("trill@ietf.org")
--results:move_messages(myaccount['lists/trill'])

