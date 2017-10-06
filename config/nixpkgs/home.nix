{ pkgs, ... }:

let
  desktopPkgs = with pkgs; [
          buku
          dropbox
          haskellPackages.greenclip # todo get from haskell
          libreoffice
          mendeley
          gnome3.nautilus
          # gnome3.gnome_control_center
          transmission_gtk
          qtpass
          qutebrowser
          xorg.xev
          xclip
          zathura
          zotero
          qtcreator
          zeal
  ];
  devPkgs = with pkgs; [
          gdb
          gitAndTools.git-extras
          mypy
          neovim
          neovim-remote
          nix-prefetch-scripts
          nix-index
          python3Packages.neovim
          python3Packages.pycodestyle
          pstree
          slack
          universal-ctags
          ];
    imPkgs = with pkgs; [
        astroid
        offlineimap # python 2 only
        python27Packages.alot # python 2 only
        khal
        khard
        msmtp
        newsbeuter
        notmuch
        weechat
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
      ];
in
{
  home.packages = desktopPkgs ++ devPkgs ++ imPkgs;

  # programs.emacs = {
  #   enable = true;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };
  # programs.rofi = {
  #   enable = true;
  # };

  # TODO doesn't find ZDOTDIR (yet)
  # programs.zsh = {
  #   enable = true;
  # };
  # programs.git = {
  #   enable = true;
  #   userName = "Jane Doe";
  #   userEmail = "jane.doe@example.org";
  # };

  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
  };
  programs.firefox = {
    enable = true;
    enableAdobeFlash = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
