{ pkgs, ... }:
let

in
[
  pkgs.gpu-viewer
  pkgs.ntfsprogs
  pkgs.nvidia-system-monitor-qt # executable is called qnvsm
  pkgs.nvitop
  pkgs.vulkan-tools # for vkcude for instance
  # pkgs.vkmark # vkmark to test

  # pkgs.nerd-fonts.fira-code # otherwise no characters
  # pkgs.nerd-fonts.droid-sans-mono # otherwise no characters
  #
  # pkgs.ubuntu-classic
  # pkgs.inconsolata # monospace
  # pkgs.noto-fonts-cjk-sans # asiatic
  # pkgs.font-awesome_5
  # pkgs.source-code-pro
  # pkgs.dejavu_fonts
  # pkgs.source-han-sans # sourceHanSansPackages.japanese
  # pkgs.fira-code-symbols # for ligatures
  # pkgs.iosevka
]
