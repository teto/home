dumpkeys > temp 
will show your current keycode <-> symbols

For instance do
$ showkey
on the key you are interested in, write down the keycode and launch
$dumpkeys > temp
look for the previous keycode  and you will see what it matches (format is
		keycode = keysym, see `man keymaps`).

(also compose can let you enter some specific characters, vim plugin UnicodeTable
 can be helpful in such cases)

might be interesting to install package "console-data" ("unicode-data")
or dpkg-reconfigure it

`loadkeys` can 


NOTE:
localectl 
