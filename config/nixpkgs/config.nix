{ pkgs }:
{
	permittedInsecurePackages = [
		"webkitgtk-2.4.11"
	];
	allowBroken = true;
	allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {
      desktopEnv =  buildEnv {
        name = "desktop-env";
        paths = [
          # or xclip
          buku
          dropbox
          haskellPackages.greenclip # todo get from haskell
          libreoffice
          mendeley
          gnome3.nautilus
          gnome3.gnome_control_center
          transmission_gtk
          qtpass
          qutebrowser
          xorg.xev
          xclip
          zathura
          zotero
        ];
      };

      devEnv = with pkgs;buildEnv {
        name = "dev-env";
        paths = [
          gdb
          gitAndTools.git-extras
          mypy
          neovim
          neovim-remote
          nix-prefetch-scripts
          nix-index
          python3Packages.neovim
          python3Packages.pycodestyle
          qtcreator
          pstree
          slack
          universal-ctags
          zeal
        ];
      };
    imEnv = pkgs.buildEnv {
      name = "im-env";
      paths = with pkgs; [
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
    };
    # internetEnv = pkgs.buildEnv {
    #   name = "internet";
    #   paths = [
    #     # qutebrowser
    #     # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    #     # mairix mutt msmtp lbdb contacts spamassassin
    #   ];
    # };
  };
}
