man tic (compiles terminfo source)
man terminfo 
Use `tic` to compile (-o to set output dir)
`tic -D` shows databases.

`infocmp xterm-termite ` to see where config is loaded 


Pour compiler a partir des sources
`tic -v10 -x termite.terminfo -o /usr/local/share/terminfo`


Add this
Se=\E[2 q, Ss=\E[%p1%d q,


A priori a program should look first at (according to man tic):
- TERMINFO
	- $HOME/.terminfo
	 -
