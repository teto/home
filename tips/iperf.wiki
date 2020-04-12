
nix run nixpkgs.iperf -c iperf -s

nix run nixpkgs.iperf -c "iperf -c localhost -b 1KiB"
