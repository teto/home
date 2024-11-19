{ pkgs, ... }:
let

in
[
  pkgs.ntfsprogs
  pkgs.nvidia-system-monitor-qt # executable is called qnvsm
  pkgs.nvitop
  pkgs.vulkan-tools # for vkcude for instance
  # pkgs.vkmark # vkmark to test

    pkgs.nerdfonts
    pkgs.ubuntu_font_family
    pkgs.inconsolata # monospace
    pkgs.noto-fonts-cjk-sans # asiatic
    pkgs.font-awesome_5
    pkgs.source-code-pro
    pkgs.dejavu_fonts
    pkgs.source-han-sans # sourceHanSansPackages.japanese
    pkgs.fira-code-symbols # for ligatures
    pkgs.iosevka
]
