add-auto-load-safe-path /home/teto/

# When debugging lispmob, ignore those signals
handle SIG34 nostop noprint pass

set history filename ~/.gdb_history
set history save
#symbol-file /home/teto/mptcp_src/vmlinux
#set architecture i386:x86-64
#target remote :1234
