{ pkgs }:
{
	permittedInsecurePackages = [
		"webkitgtk-2.4.11"
	];
	allowBroken = true;
	allowUnfree = true;

    nvimEnv = with pkgs; buildEnv {
      name = "nvim";
      paths = [
        neovim
        neovim-remote
        python3Packages.neovim
        python3Packages.neovim-remote
        universal-ctags
        zeal
        # or xclip
      ];
    };

    mainEnv = with pkgs;buildEnv {
      name = "dev";
      paths = [
        dropbox
        fzf
        greenclip # todo get from haskell
        libreoffice
        mendeley
        nautilus
        xev
        qtpass
        #

        xclip
        zathura
        zotero
        # offlineimap # python 2 only
        # alot # python 2 only
      ];
    };
    devEnv = with pkgs;buildEnv {
      name = "dev";
      paths = [

        wireshark
        # offlineimap # python 2 only
        # alot # python 2 only
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
      ];
    };
    imEnv = pkgs.buildEnv {
      name = "im";
      paths = with pkgs.python27Packages; [
        astroid
        offlineimap # python 2 only
        alot # python 2 only
        python3Packages.khal
        python3Packages.khard
        msmtp
        newsbeuter
        notmuch
        weechat
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
      ];
    };
    # # qutebrowser
    # internetEnv = pkgs.buildEnv {
    #   name = "internet";
    #   paths = [
    #     # qutebrowser
    #     # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    #     # mairix mutt msmtp lbdb contacts spamassassin
    #   ];
    # };
}
