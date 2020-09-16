#!/usr/bin/env bash

set -euo pipefail

nix-build --out-link /tmp/netboot - <<'EOF'
let
  bootSystem = import <nixpkgs/nixos> {
    # system = ...;

    configuration = { config, pkgs, lib, ... }: with lib; {
      imports = [
          <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
      ];
      ## Some useful options for setting up a new system
      services.mingetty.autologinUser = mkForce "root";
      # Enable sshd which gets disabled by netboot-minimal.nix
      systemd.services.sshd.wantedBy = mkOverride 0 [ "multi-user.target" ];
      # users.users.root.openssh.authorizedKeys.keys = [ ... ];
      # i18n.consoleKeyMap = "de";
    };
  };

  pkgs = import <nixpkgs> {};
in
  pkgs.symlinkJoin {
    name = "netboot";
    paths = with bootSystem.config.system.build; [
      netbootRamdisk
      kernel
      netbootIpxeScript
    ];
    preferLocalBuild = true;
  }
EOF

n=$(realpath /tmp/netboot)
init=$(grep -ohP 'init=\S+' $n/netboot.ipxe)

# As of May 2020, Pixiecore is only available on nixos-unstable
nix build -o /tmp/pixiecore -f channel:nixos-unstable pixiecore

# Start the PXE server.
# These ports need to be open in your firewall:
# UDP: 67, 69
# TCP: 64172
# --dhcp-no-bind 
sudo /tmp/pixiecore/bin/pixiecore \
  boot $n/bzImage $n/initrd \
  --cmdline "$init loglevel=4" \
  --debug --dhcp-no-bind  \
  --port 64172 --status-port 64172 \
  --listen-addr 192.168.1.13
