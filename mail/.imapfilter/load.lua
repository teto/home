require('os')
get_netrc_pwd = function (machine, login)
f = io.open(os.getenv('HOME') .. '/.netrc', 'r')


	l = f:read("*all") 
	print(l)
	pwd = l:match('machine '..machine..' login '..login..' password (.+)')
	print("result:", pwd)
	return pwd
end 

