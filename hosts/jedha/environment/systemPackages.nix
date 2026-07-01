{ pkgs, ... }:
let

in
[
  pkgs.gpu-viewer
  pkgs.grub2 # for grub-reboot, to select entry on next  reboot
  pkgs.ntfsprogs
  pkgs.nvidia-system-monitor-qt # executable is called qnvsm
  pkgs.nvitop
  pkgs.vulkan-tools # for vkcude for instance
]
