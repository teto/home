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

messages = myaccount.INBOX:select_all()
ml_filters = {
	{"to","trill@ietf.org", myaccount["trill"]},
	{"to","lisp@ietf.org", myaccount["lisp"]},
	{"to","mptcp@ietf.org", myaccount["mptcp"]},
	{"to","mptcp-dev@listes.uclouvain.be", myaccount["mptcp"]}
	
}
-- @param res         the table of messages to filter
-- @param ruleTable   the table of rules to match messages against
parseRules = function ( res, ruleTable )
local subresults = {}
  for _,entry in pairs(ruleTable) do
	--print(entry[1], entry [2] , entry[3])
    -- don't use match_field, it downloads part of the msg (slow)
    subresults = res:contain_field(entry[1], entry[2])
    if subresults:move_messages( entry[3] ) == false then
      print("Cannot move messages!")
    end
  end
end


parseRules( messages, ml_filters)

--results = myaccount.INBOX:contain_to("trill@ietf.org")
--results:move_messages(myaccount['lists/trill'])

