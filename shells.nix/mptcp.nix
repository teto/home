with import <nixpkgs> {};

# alias kernel_makeconfig="nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command 'make menuconfig KCONFIG_CONFIG=build/.config"
# alias kernel_xconfig="nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})'"
# alias kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"

