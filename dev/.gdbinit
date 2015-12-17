# as a reminder
# to export a backtrace to a file
# set logging file <myfile>
# set logging on
# 
# Set lang c++
# Some useful commands:
# List loaded sources: info sources
# list libraries: info sharedlibrary
# library related configs are of the form set solib-search-path
# symbol-file
# to display the TUI, either launch gdb via 'gdbtui' or type CTRL-X CTRL-A once gdb launched
#
# Conditional breakpoints:
# 1/ install breakpoint, note its number
# 2/ then put the condition
# (gdb) br test.cpp:2
# (gdb) cond 1 i==2147483648
# for strings 
#(gdb) set $secret_code = "MyUberSecretivePassword"
#(gdb) cond 1 strcmp ( $secret_code, c ) == 0
#(gdb) run

# autoload .gdbinit in subfolders of
add-auto-load-safe-path /home/teto/

source ~/.gdb/printers.py


# When debugging lispmob, ignore those signals
handle SIG34 nostop noprint pass

set print vtbl on 
# move it to $XDG_CACHE_HOME ?
set history save
#symbol-file /home/teto/mptcp_src/vmlinux
#set architecture i386:x86-64
#target remote :1234
set directories $
# enable pretty
enable pretty-printers
set print pretty on
set print array on
set print object on
set print static-members on
set print symbol on 
set print vtbl on
set print demangle on
set demangle-style auto
#set demangle-style gnu-v3
set print sevenbit-strings off
#set scheduler-locking on
set verbose on 
#set complaints 1000 
#set language c++ 

#On Unix systems, by default, if a shell is available on your target, gdb) uses it to start your program. Arguments of the run command are passed to the shell, which does variable substitution, expands wildcard characters and performs redirection of I/O
#https://github.com/direct-code-execution/ns-3-dce/issues/18
set startup-with-shell off


# set disable-randomization on

define hook-quit
    set confirm off
end

# enters python mode
python
import os
dirs = [
"/home/teto/iperf3/src",
"/home/teto/ns3off/src",
"/home/teto/iperf2/src"
]


gdb.execute('directory ' + ' '.join(dirs))

gdb.execute("set history filename " + os.environ['XDG_CACHE_HOME'] + "gdb_history")

gdb.execute("show directories")
end 
# returend to normal mode
