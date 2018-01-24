{ pkgs, lib,  ... }:


let
  includeFzf= let fzfContrib="${pkgs.fzf}/share/fzf"; in ''
    . "${fzfContrib}/completion.bash"
    . "${fzfContrib}/key-bindings.bash"
    '';

  i3extraConfig = lib.concatStrings [
    (builtins.readFile ../i3/config.header)
    (builtins.readFile ../i3/config.main)
    # (builtins.readFile ../i3/config.mediakeys)
    (builtins.readFile ../i3/config.xp)
    (builtins.readFile ../i3/config.audio)
    (builtins.readFile ../i3/config.colors)
  ]
  # TODO check depending on if pulseaudio or alsa is enabled
  # + lib.optional false ''
  # # Pulse Audio controls
  # bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
  # bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
  # bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound
  # ''
  ;

  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with pkgs;[
    anki          # spaced repetition system
    libreoffice
    qutebrowser  # keyboard driven fantastic browser
    gnome3.nautilus # demande webkit/todo replace by nemo ?
    mendeley # requiert qtwebengine
    pinta    # photo editing
    qtcreator  # for wireshark
    zeal       # doc for developers
    # zotero     # doc software
    # astroid # always compiles webkit so needs 1 full day
    taiginijisho # japanse dict; like zkanji Qt based
  ];
  desktopPkgs = with pkgs; [
    buku
    dropbox
    feh
    ffmpegthumbnailer # to preview videos in ranger
    haskellPackages.greenclip # todo get from haskell
    nox
    # gnome3.gnome_control_center
    qtpass
    sublime3
    scrot
    system_config_printer
    transmission_gtk
    translate-shell
    w3m # for preview in ranger w3mimgdisplay
    xorg.xev
    xclip
    zathura
  ];
  devPkgs = with pkgs; [
    ccache
    editorconfig-core-c
    exa
    gdb
    gitAndTools.git-extras
    mypy
    # neovim
    neovim-remote
    nix-prefetch-scripts
    nix-repl
    nix-index
    # python3Packages.neovim it s included
    python3Packages.pycodestyle
    rpl
    universal-ctags
  ];
  imPkgs = with pkgs; [
    offlineimap # python 2 only
    # python27Packages.alot # python 2 only
    khal
    khard
    msmtp
    newsboat
    notmuch
    slack
    vdirsyncer
    weechat
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ];
  # TODO add heavyPackages only if available ?
  # or set binary-cache
  # nixos= import '<nixos-unstable>' 
in
rec {
  home.packages = desktopPkgs ++ devPkgs ++ imPkgs;

  home.mailAccounts = [
    {
      userName = "mattator@gmail.com";
      realname = "Like skywalker";
      address = "mattator@gmail.com";
      store = home.folder."Maildir/gmail";
      # sendHost = "smtp.gmail.com";
    }
    ];

  # you can switch from cli with xkb-switch
  # or xkblayout-state
  home.keyboard = {
    layout = "fr,us";
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
  };

  # symlink machine specific config there
  imports = lib.optionals (builtins.pathExists ./machine-specific.nix) [ ./machine-specific.nix ];

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
  # TODO maybe we can add to PATH 
  # - https://github.com/carnager/rofi-scripts.git
  # https://github.com/carnager/buku_run
  home.sessionVariables = {

    WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
    TIGRC_USER="$XDG_CONFIG_HOME/tig/tigrc";
    LESSHISTFILE="$XDG_CACHE_HOME/less/history";
    NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc";
    INPUTRC="$XDG_CONFIG_HOME/inputrc";
    IPYTHONDIR="$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter";
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    XDG_CONFIG_DIRS="$XDG_CONFIG_HOME:$HOME/dotfiles";
    # PATH+=":$HOME/rofi-scripts";
    MUTT="$XDG_CONFIG_HOME/mutt";
    MAILDIR="$HOME/Maildir";

    # TODO add symlinks instead towards $XDG_DATA_HOME/bin ?
    # now these are submoudles of dotfiles To re;ove
    PATH="$HOME/rofi-scripts:$HOME/buku_run:$PATH";

  };

  # source file name can't start with .
  # home.file.".wgetrc".source = dotfiles/home/.wgetrc;

  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    path =  "/home/teto/dotfiles/home-manager";
  };

  # programs.termite

  xdg = {
    enable = true;
    configFile."nvim/toto".text = ''
      hello world
    '';
  };
  # xdg.configFile.".config/mpv/input.conf".source = dotfiles/mpv-input.conf;
  # xdg.configFile.".config/mpv/mpv.conf".source = dotfiles/mpv-mpv.conf;

  programs.bash = {
    enable = true;
    enableAutojump = true;

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT="%d.%m.%y %T ";
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
    # historyControl=["erasedups", "ignoredups", "ignorespace"]
    historyIgnore=["ls"];
    historyFile = "${xdg.cacheHome}/bash_history";
    # HISTFILE="$XDG_CACHE_HOME/bash_history";
    initExtra=''
      ${includeFzf}
      '';
      # profileExtra=''
      #   '';
      # shellOptions=
    shellAliases = {
      hm="home-manager";
      #mostly for testin
      dfh="df --human-readable";
      duh="du --human-readable";
    };

    # extra
    # ${ranger}/share/doc/ranger/examples/bash_automatic_cd.sh
  };

  # programs.zsh = {
  #   enable = true;
  #   dotDir = 
  #   sessionVariables = {
  #     HISTFILE="$XDG_CACHE_HOME/zsh_history";
  #   };
  #   shellAliases = {
  #   nixpaste="curl -F 'text=<-' http://nixpaste.lbr.uno";
  #   };
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

  programs.notmuch = {
    enable = true;
  };

  programs.alot = {
    enable = true;
  };

  # 
  # programs.offlineimap = {
  #   enable = true;
  # };


  # TODO prefix with stable
  programs.firefox = {
    enable = true;
  #   package = ; # set ff57
  #   enableAdobeFlash = false;
  };

  programs.neovim = {
    enable = true;
    withPython3 = true;
    withPython = false;
    withRuby = false;
    extraPython3Packages = with pkgs.python3Packages;[ pandas jedi ]
      ++ lib.optionals ( pkgs ? python-language-server) [ pkgs.python-language-server ]
      ;
    # extraConfig = ''
    #   " TODO set different paths accordingly, to language server especially
    #   let g:clangd_binary = '${pkgs.clang}'
    #   # let g:pyls = '${pkgs.clang}'
    #   '' ;
  };

# home.activation.setXDGbrowser = dagEntryBefore [ "linkGeneration" ] ''
# xdg-settings set default-web-browser firefox.desktop
#       '';

  programs.vim = {
    enable = true;
    settings = {
      number = true;
    };
    extraConfig = ''
      " TODO set different paths accordingly, to language server especially
      '';
  };

  programs.browserpass = {
    enable=true;
    browsers = ["firefox" "chromium" ];
  };

  # todo configure mocp
  # todo configure neovim
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # services.xserver.enable = true;
  # i3 now available !
  xsession.enable = true;
  # xsession.windowManager.command = "…";
    # ${pkgs.networkmanagerapplet}/bin/nm-applet &

  # as long as there is no better way to configure i3
  # xsession.windowManager.command = "${pkgs.i3}/bin/i3";
  xsession.windowManager.i3 = {
    enable = true;
    extraConfig = i3extraConfig;
    # config = null;
    config = {
      bars = [];
      keycodebindings= {
      };
      startup=[
        # TODO improve config/config specific
        { command= "xkblayout-state set +1"; always = false; notification = false; }
        # todo convert to a HM stuff
        { command= "greenclip daemon"; always = false; notification = false; }
        ];
      modes = {
        # resize = { Down="resize ..." }
      };

      window = {
        hideEdgeBorders = true;
      };
      # colors = {
      #   focused = {
      #     border = "#03a9f4";
      #     background = "#03a9f4";
      #     text = "#eceff1";
      #     indicator = "#ff9800";
      #     childBorder = "#03a9f4";
      #   };
        # };
        #
# set $mod Mod1
# il ne comprend pas Super_L
      keybindings = let mad="Mod4"; mod="Mod1"; in {
        # todo use i3lock-fancy instead
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock";
        "${mad}+h"="rofi -modi 'clipboard:greenclip print' -show clipboard";

# set $greenclip "rofi -modi 'clipboard:greenclip print' -show clipboard"
#       bindsym $mad+h exec $greenclip
        # TODO let i3dispatch
# bindsym $mod+Left  exec /home/teto/bin/i3dispatch left
# bindsym $mod+Down  exec /home/teto/bin/i3dispatch down
# bindsym $mod+Up    exec /home/teto/bin/i3dispatch up
# bindsym $mod+Right exec /home/teto/bin/i3dispatch right


  # XF86AudioNext="exec ${mpc} next; exec notify-send 'Audio next'";
  # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
  # XF86AudioPause exec mpc toggle; exec notify-send "Audio Pause"


      # } // {
        # alsa version
  # XF86AudioRaiseVolume=if home.packages ?  exec amixer -q set Master 2dB+ unmute; exec notify-send "Audio Raised volume"
  # XF86AudioLowerVolume exec amixer -q set Master 2dB- unmute; exec notify-send Audio lowered
  # XF86AudioMute exec amixer -q set Master toggle; exec notify-send "Mute toggle"
        "XF86AudioRaiseVolume"="exec --no-startup-id pactl set-sink-volume 0 +5%;exec notify-send 'Audio Raised volume'";
        "XF86AudioLowerVolume"="exec --no-startup-id pactl set-sink-volume 0 -5%;exec notify-send 'Audio lowered'";
        "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;";
      };
    };

# Media player controls
# bindsym XF86AudioPlay exec playerctl play
# bindsym XF86AudioPause exec playerctl pause
# bindsym XF86AudioNext exec playerctl next
# bindsym XF86AudioPrev exec playerctl previous
  };
  xsession.initExtra = ''
    ${pkgs.feh} --bg-fill ~/dotfiles/wallpapers/nebula.jpg
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
  '';
}
