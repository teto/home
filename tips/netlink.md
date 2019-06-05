

# to list families
genl ctrl list

# to identify a family
genl ctrl get id 0x1F
genl ctrl get name mptcp

ip tcp_metrics show

https://jvns.ca/blog/2017/09/03/debugging-netlink-requests/
sudo ip link add  nlmon0 type nlmon
sudo ip link set dev nlmon0 up

then start wireshark
