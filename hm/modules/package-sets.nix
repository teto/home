{
  config,
  lib,
  pkgs,
  flakeInputs,
  ...
}:
with lib;

let
  cfg = config.package-sets;

in
{

  options = {
    package-sets = {

      desktop = mkEnableOption "desktop packages";
      server = mkEnableOption "server packages";

      enableOfficePackages = mkEnableOption "office/heavy packages";

      developer = mkEnableOption "Developer packages";
      scientificSoftware = mkEnableOption "Scientific packages";
      enableDesktopGUIPackages = mkEnableOption "Heavy desktop packages";
      # TODO convert into description
      # the kind of packages u don't want to compile
      # TODO les prendres depuis un channel avec des binaires ?
      # with flakeInputs.nixos-stable.legacyPackages.${pkgs.system};

      enableIMPackages = mkEnableOption "IM packages";
      wifi = mkEnableOption "wifi packages";
      energy = mkEnableOption "energy management packages";
      enableGaming = mkEnableOption "Gaming packages";
      waylandPackages = mkEnableOption "Wayland packages";

      # laptop = mkEnableOption "Laptop packages (energy + wifi)";

    };

  };

  config = mkMerge [
    ({
      # INSTALLED whatever the config
      home.packages = with pkgs; [
        btop
        curl
        just # to read justfiles, *replace* Makefile
        gitAndTools.gitFull # to get send-email
        gnumake
        tree
        stow
        systemctl-tui
        pciutils # for lspci
        # zenith  # resources monitor
      ];
    })

    (mkIf cfg.desktop {

      home.packages =
        with pkgs;
        let

          # for 'convert' executable. Can convert PDF too
          myImagemagick = pkgs.imagemagick.override ({ ghostscriptSupport = true; });
        in
        [

          acpi # for acpi -V
          # anki          # spaced repetition system
          # hopefully we can remove this from the environment
          # it's just that I can't setup latex correctly
          pkgs.rofi-rbw-wayland
          pkgs.timg # to display images in terminal, to compare with imgcat ?
          myImagemagick

          # mpd
          pkgs.ncmpcpp
          pkgs.mpc_cli
          pkgs.ymuse # GUI

          # take the version from stable ?
          # qutebrowser # broken keyboard driven fantastic browser
          pkgs.nautilus # demande webkit/todo replace by nemo ?
          # mcomix # manga reader
          pkgs.popcorntime
          # gnome.california # fails
          # khard # see khal.nix instead ?
          # libsecret  # to consult
          # newsboat #
          # mujmap # to sync notmuch tags across jmap 
          pkgs.vlc
          # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
          # mairix mutt msmtp lbdb contacts spamassassin
          # element-desktop # TODO this should go into nix profile install
          # mcomix # manga reader
          # TODO
          # apvlv # broken
          # buku # broken
          # gcalc
          # nomacs # image viewer
          # nyxt      # lisp browser
          # pulseaudioFull # for pactl
          # replace with rust-wormhole
          # requires xdmcp https://github.com/freedesktop/libXdmcp
          smplayer # GUI around mpv
          # sxiv # simple image viewer
          # unstable.transmission_gtk  # bittorrent client
          # vimiv # image viewer
          # ytfzf # broken browse youtube
          # zathura # broken
          usbutils
          bandwhich # to monitor per app bandwidth
          desktop-file-utils # to get desktop
          dogdns # dns solver "dog"
          evince # succeed where zathura/mupdf fail
          font-manager # pretty good font manager
          adwaita-icon-theme # else nothing appears
          eog # eye of gnome = image viewer / creates a collision
          file-roller # for GUI archive handling
          hunspellDicts.fr-any
          imv # image viewer
          jq # to run json queries
          lazygit # kinda like tig
          libnotify
          moc-wrapped # music player
          mupdf.bin # evince does better too

          ## Alternatives to consider:
          # - gdu
          # - pdu
          # - dua
          # ncdu # to see disk usage
          dua
          du-dust # dust binary: rust replacement of du
          duf # better df (rust)

          ncpamixer # pulseaudio TUI mixer
          noti # send notifications when a command finishes
          ouch # to (de)compress files
          # papis # library manager
          pass-teto # pass with extensions
          pavucontrol
          pkgs.networkmanagerapplet # should
          procs # Rust replacement for 'ps'
          qiv # image viewer
          qtpass
          ranger # or joshuto ? see hm configuration
          restic # to backup photos to backblaze
          # rbw # Rust bitwarden unofficial client
          ripgrep
          rofi-pass # rofi-pass it's enabled in the HM module ?
          rsync
          sd # rust cli for search & replace
          shared-mime-info # temporary fix for nautilus to find the correct files
          sublime3
          sysz # fzf for systemd
          translate-shell # call with `trans`
          unzip
          wireshark
          wttrbar # for meteo
          xarchiver # to unpack/pack files
          xdg-utils
          xdg-terminal-exec # necessary for gio launch to launch terminal

        ];

    })

    (mkIf cfg.enableOfficePackages {

      home.packages = [
        # anki          # spaced repetition system
        # hopefully we can remove this from the environment
        # it's just that I can't setup latex correctly
        pkgs.libreoffice
        pkgs.simple-scan

        pkgs.nautilus # demande webkit/todo replace by nemo ?
      ];

    })

    (mkIf cfg.enableIMPackages {
      home.packages = with pkgs; [
        # gnome.california # fails
        # khard # see khal.nix instead ?
        # libsecret  # to consult
        # newsboat #
        mujmap # to sync notmuch tags across jmap
        # memento # broken capable to display 2 subtitles at same time
        vlc
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
        # element-desktop # TODO this should go into nix profile install
        popcorntime

      ];

    })

    (mkIf cfg.enableDesktopGUIPackages {
      home.packages = with pkgs; [
        hakuneko

        memento # broken capable to display 2 subtitles at same time
        vlc
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
        # element-desktop # TODO this should go into nix profile install
        popcorntime

      ];

    })

    (mkIf cfg.wifi {
      home.packages = with pkgs; [
        wirelesstools # to get iwconfig
        iw
        wavemon

        # aircrack-ng # TODO move to hacking package-set
      ];
    })

    (mkIf cfg.developer {
      home.packages = with pkgs; [
        automake
        (backblaze-b2.override ({ execName = "b2"; }))
        dasht # ~ zeal but in terminal
        docker-credential-helpers
        envsubst # replace templated files with variables
        sops # password 'manager'
        glab # gitlab cli
        # TODO pass to vim makeWrapperArgs
        # nodePackages.bash-language-server
        # just in my branch :'(
        # luaPackages.lua-lsp
        # gdb-debug = prev.enableDebgging prev.gdb ;
        # gitAndTools.git-annex # fails on unstable
        # gitAndTools.git-remote-hg
        # nix-prefetch-scripts # broken
        nix-output-monitor # 'nom'

        nix-diff
        nix-prefetch-git
        netcat-gnu # plain 'netcat' is the bsd one
        gitAndTools.diff-so-fancy
        jq

        # editorconfig-core-c
        # for fuser, useful when can't umount a directory
        # https://unix.stackexchange.com/questions/107885/busy-device-on-umount
        lurk # a rust strace
        fswatch # fileevent watcher
        fx # json reader
        gdb
        gnupg
        gnum4 # hum
        # psmisc # ps -a for python ?
        rbw
        util-linux # for lsns (namespace listing)

        # haxe # to test neovim developement
        eza # to list files
        gitAndTools.diff-so-fancy # todo install it via the git config instead
        gitAndTools.gh # github client
        gitAndTools.git-absorb
        gitAndTools.git-crypt
        # gitAndTools.git-extras
        gitAndTools.git-recent # check recently touched branches
        gitAndTools.gitbatch # to fetch form several repos at once
        gitAndTools.lab # to interact with gitlab
        gitu # like lazygit

        haskellPackages.fast-tags # generate TAGS file for vim
        hurl # http tester (broken)

        fre # generate a frequency database

        perf-tools # to interpret

        inotify-info # to debug filewatching issues, very nice
        inotify-tools # for inotify-wait notably
        ncurses.dev # for infocmp
        # neovide
        # neovim-remote # broken for latex etc
        # nix-doc # can generate tags for nix
        nix-update # nix-update <ATTR> to update a software
        nix-index # to list package contents
        # nix-top # (abandoned) to list current builds
        nixfmt # the official one
        # nixfmt
        nixpkgs-review # to help review nix packages
        # nodePackages."@bitwarden/cli" # 'bw' binary # broken
        patchutils # for interdiff
        process-compose # docker-compose - like
        # rpl # to replace strings across files
        strace
        tio # serial console reader
        universal-ctags # there are many different ctags, be careful !
        whois
        zeal # doc for developers

        flakeInputs.rippkgs.packages.${pkgs.system}.rippkgs
        flakeInputs.rippkgs.packages.${pkgs.system}.rippkgs-index
      ];

    })
    (mkIf cfg.scientificSoftware {
      home.packages = with pkgs; [

        eva # calculette in a REPL
        nodePackages.insect # fancy calculator
        fend # rust unit convertor
        pcalc # cool calc, see insect too

        graphviz
      ];

    })

    (mkIf cfg.enableGaming {
      home.packages = with pkgs; [

        lutris

      ];

    })

    (mkIf cfg.waylandPackages {
      home.packages = with pkgs; [
        cliphist
        clipcat # rust

        # TODO test https://github.com/sentriz/cliphist
        foot # terminal
        # use it with $ grim -g "$(slurp)"
        grim # replace scrot/flameshot
        kanshi # autorandr-like
        kickoff # transparent launcher for wlr-root
        fuzzel # rofi-like
        wofi # rofi-like
        slurp # capture tool
        # lavalauncher # TODO a tester
        wf-recorder # for screencasts
        # bemenu as a dmenu replacement
        wl-clipboard # wl-copy / wl-paste
        wdisplays # to show
        swaybg # to set wallpaper
        swayimg # imageviewer
        swaynotificationcenter # top cool
        swaynag-battery # https://github.com/NixOS/nixpkgs/pull/175905
        sway-launcher-desktop # fzf-based launcher
        waypaper # sets wallpapers
        wlprop # like xprop, determines window parameters
        # swappy # e https://github.com/jtheoof/swappy
        # https://github.com/artemsen/swaykbdd # per window keyboard layout
        # wev # event viewer https://git.sr.ht/~sircmpwn/wev/
        wl-gammactl # to control gamma
        wlr-randr # like xrandr

        # wayprompt
        wev # equivalent of xev, to find the name of keys for instance
        wshowkeys
        wlogout

      ];
    })

    (mkIf cfg.energy {
      home.packages = [
        pkgs.powertop # superuseful
        pkgs.pcm
      ];

    })

  ];
}
