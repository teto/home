{ pkgs, ... }:
let
  monolixInstallerDeps = with pkgs; [
    libxcb-wm.out # for libxcb-icccm.so.4
    fontconfig.lib # for libfontconfig.so.1
    freetype # for libfreetype.so.6
    dbus.lib # libdbus-1.so.3
    libxkbcommon.out # for libxkbcommon.so.0
    libxcb.out # libxcb-xfixes.so.0 / libxcb-render / libxcb-xinerama.so.0
    xorg.xcbutilkeysyms # for libxcb-keysyms.so.1
    xz # for liblzma.so.5
    libx11 # for libX11-xcb.so.1
    xorg.xcbutilimage
    libxcb-render-util # for libxcb-render-util.so.0
    libxext
    krb5.lib

    libGL # libGL.so.1
  ];

  # monolixActualProgramDeps = with pkgs; [
  #   libdrm
  #   libxi
  # ];
in
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      expat
      # ldd Lixoft/MonolixSuite2024R1/lib/monolix
      nss # libsmime3.so
      nspr # libplds4.so (kesako ?)
    ]
    # ++ monolixInstallerDeps
    # ++ monolixActualProgramDeps
    ;
  };

}
