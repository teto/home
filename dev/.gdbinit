add-auto-load-safe-path /home/teto/

source ~/.gdb/printers.py


# When debugging lispmob, ignore those signals
handle SIG34 nostop noprint pass

set history filename ~/.gdb_history
set history save
#symbol-file /home/teto/mptcp_src/vmlinux
#set architecture i386:x86-64
#target remote :1234

# enable pretty
enable pretty-printers
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off



define hook-quit
    set confirm off
end
