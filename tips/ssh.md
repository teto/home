To remove a key
ssh-keygen -R 192.168.1.100

https://superuser.com/questions/467398/how-do-i-exit-an-ssh-connection

how t ochange passphrase ?
ssh-keygen -p [-P old_passphrase] [-N new_passphrase] [-f keyfile]
