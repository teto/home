
# Linux namespaces

ip netns list

$ lsns
lists all of them

nsenter
journalctl -M
nsenter -t 4026531840 journalctl -b0
