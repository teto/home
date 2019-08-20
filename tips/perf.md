

don't forget to run into sudo mode

 perf --debug verbose probe -k /nix/store/5am9gvlr7wkcwy48kibhvq16l624iw6h-linux-5.1.0-mptcp_v0.96.0-dev/vmlinux -s /home/teto/mptcp 'tcp_sendmsg size'


On nixos
Failed to find 'acked' in this function

machine__create_modules
Use vmlinux: /nix/store/5am9gvlr7wkcwy48kibhvq16l624iw6h-linux-5.1.0-mptcp_v0.96.0-dev/vmlinux
map_groups__set_modules_path_dir: cannot open /lib/modules/5.1.0 dir
Problems setting modules path maps, continuing anyway...
