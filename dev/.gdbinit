# as a reminder
# to export a backtrace to a file
# set logging on
# set logging file <myfile>
#
# Some useful commands:
# List loaded sources: info sources
# list libraries: info sharedlibrary
# library related configs are of the form set solib-search-path
# symbol-file
# to display the TUI, either launch gdb via 'gdbtui' or type CTRL-X CTRL-A once gdb launched


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

define hook-quit
    set confirm off
end

# enters python mode
python
import os
gdb.execute('directory ' + '/home/teto/iperf3/src')

gdb.execute("set history filename " + os.environ['XDG_CACHE_HOME'] + "gdb_history")

gdb.execute("show directories")
end 
# returend to normal mode
