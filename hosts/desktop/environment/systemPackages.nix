{ pkgs, ... }:
let

in
[
  pkgs.ntfsprogs
  pkgs.nvidia-system-monitor-qt # executable is called qnvsm
  pkgs.nvitop
  pkgs.vulkan-tools # for vkcude for instance
  # pkgs.vkmark # vkmark to test
]
