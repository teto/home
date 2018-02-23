# home-manager specific config from
{ pkgs, lib,  ... }:

# nix-shell -p 'python3.withPackages( ps : [ ps.scikitlearn ] )' ~/nixpkgs

let
  stable = import <nixos> {}; # https://nixos.org/channels/nixos
  unstable = import <nixos-unstable> {}; # https://nixos.org/channels/nixos-unstable
  includeFzf= let fzfContrib="${pkgs.fzf}/share/fzf"; in ''
    . "${fzfContrib}/completion.bash"
    . "${fzfContrib}/key-bindings.bash"
    '';

  i3extraConfig = lib.concatStrings [
    (builtins.readFile ../config/i3/config.header)
    (builtins.readFile ../config/i3/config.main)
    # (builtins.readFile ../i3/config.mediakeys)
    (builtins.readFile ../config/i3/config.xp)
    (builtins.readFile ../config/i3/config.audio)
    (builtins.readFile ../config/i3/config.colors)
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
    # anki          # spaced repetition system
    unstable.libreoffice
    unstable.qutebrowser  # keyboard driven fantastic browser
    unstable.gnome3.nautilus # demande webkit/todo replace by nemo ?
    mcomix # manga reader
    unstable.mendeley # requiert qtwebengine
    unstable.pinta    # photo editing
    unstable.qtcreator  # for wireshark
    unstable.zeal       # doc for developers
    # zotero     # doc software
    # wavemon
    # astroid # always compiles webkit so needs 1 full day
  ];
  networksPkgs = with pkgs; [
    aircrack-ng
    bind # for dig
    gnome3.networkmanagerapplet
    netcat-gnu # plain 'netcat' is the bsd one
    iperf3
    # wireshark # may cause pb because of Qt
  ];
  desktopPkgs = with pkgs; [
    buku
    unstable.dropbox
    # feh
    unstable.evince # succeed where zathura/mupdf fail
    unstable.gnome3.file-roller # for GUI archive handling
    ffmpegthumbnailer # to preview videos in ranger
    haskellPackages.greenclip # todo get from haskell
    moc
    mupdf # evince does better too
    # mdp # markdown CLI presenter
    nox # helps with reviewing and to install files
    # gnome3.gnome_control_center
    unstable.qtpass
    sublime3
    scrot
    sxiv
    unstable.system_config_printer
    shared_mime_info # temporary fix for nautilus to find the correct files
    # taiginijisho # japanse dict; like zkanji Qt based
    unstable.transmission_gtk
    translate-shell
    w3m # for preview in ranger w3mimgdisplay
    xorg.xev
    xclip
    xcwd
    # zathura
  ];
  devPkgs = with pkgs; [
    ccache
    gitAndTools.diff-so-fancy
    gitAndTools.git-recent
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
  news.display = "silent";
  home.packages = desktopPkgs ++ devPkgs ++ imPkgs ++ networksPkgs ++ [
    pkgs.ranger
    pkgs.vifm
  ];


  # you can switch from cli with xkb-switch
  # or xkblayout-state
  home.keyboard = {
    # layout = "fr,us";
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    options = [ "add Mod1 Alt_R" ];
  };

  # symlink machine specific config there
  # imports = [
  #     ./basetools.nix
  #     ./extraTools.nix
  #     ./desktopPkgs.nix
  #     ];

  programs.feh.enable = true;
  # programs.emacs = {
  #   enable = true;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.termite}/bin/termite";
    # rofi.font: SourceCodePro 9
    # font = 
    extraConfig=''
      !Means it is at center
      rofi.loc: 0
      !rofi.opacity: 90
      !rofi.width: 50
      rofi.columns: 1
      rofi.fuzzy: true
      rofi.modi:       run,DRun,window,ssh,Layouts:/home/teto/.i3/list_layouts.sh
      /* see to integrate teiler */
      rofi.sidebar-mode: true

      rofi.kb-mode-previous: Alt+Left
      rofi.kb-mode-next:	Alt+Right,Alt+Tab
    '';
  };

  # TODO doesn't find ZDOTDIR (yet)
  # TODO maybe we can add to PATH 
  # TODO use xdg.configFile ?
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
    # historyFile = "${xdg.cacheHome}/bash_history";
    historyFile = "$XDG_CACHE_HOME/bash_history";
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


  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    package = stable.firefox;
  #   enableAdobeFlash = false;
  };

  programs.neovim = import ./neovim.nix { inherit pkgs lib; };

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

  services.gnome-keyring = {
    enable=true;
  };

  services.network-manager-applet.enable = true;

  services.dunst = {
    enable=true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # i3 now available !
  xsession.enable = true;
  # xsession.windowManager.command = "…";
    # ${pkgs.networkmanagerapplet}/bin/nm-applet &

  # as long as there is no better way to configure i3
  # xsession.windowManager.command = "${pkgs.i3}/bin/i3";
  xsession.windowManager.i3 =
  let
    bind_ws = workspace_id: fr: us:
    let ws = builtins.toString workspace_id;
    in
      {
        "$GroupFr+$mod+${fr}"="workspace \"$w${ws}";
        "$GroupUs+$mod+${us}"="workspace \"$w${ws}";
        "$GroupFr+Shift+$mod+${fr}"="move container to workspace \"$w${ws}";
        "$GroupUs+Shift+$mod+${us}"="move container to workspace \"$w${ws}";
      };
    in
  {
    enable = true;
    extraConfig = i3extraConfig;
    config = {
      bars = let
        i3pystatus-custom = pkgs.i3pystatus.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = with pkgs.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});
    in [
        {
          position="top";
          workspaceButtons=true;
          workspaceNumbers=false;
          id="0";

          # command="";
          statusCommand="${i3pystatus-custom}/bin/i3pystatus-python-interpreter $XDG_CONFIG_HOME/i3/myStatus.py";
        }
      ];
      keycodebindings= { };
      startup=[
        # TODO improve config/config specific
        # { command= "xkblayout-state set +1"; always = false; notification = false; }
        # todo convert to a HM stuff
        { command= "greenclip daemon"; always = false; notification = false; }
        ];

# bindsym $mod+m  mode "monitors"
# mode "monitors" {

# 	# todo should work with hjkl too
# 	bindsym $mod+Left move workspace to output left
# 	bindsym $mod+Right move workspace to output right
# 	bindsym $mod+Up move workspace to output top
# 	bindsym $mod+Down move workspace to output down

# 	bindsym $mod+Shift+Left workspace prev_on_output
# 	bindsym $mod+Shift+Right workspace next_on_output

# 	bindsym Return mode "default"
# 	bindsym Escape mode "default"
# }

      modes = {
        monitors =
        let
          move_to_output = dir: fr: us:
          {
            "$GroupFr+$mod+${fr}"="move workspace to output \"${dir}";
            "$GroupUs+$mod+${us}"="move workspace to output \"${dir}";
          };
        in
        {
          "Return"= "mode default";
        }
        // move_to_output "left" "Left" "Left"
        // move_to_output "left" "j" "j"
        // move_to_output "right" "Right" "Right"
        // move_to_output "right" "m" "semicolumn"
        // move_to_output "top" "Up" "Up"
        // move_to_output "top" "k" "k"
        // move_to_output "down" "down" "down"
        // move_to_output "down" "l" "l"
        ;
        # mouse= {
	# bindsym $mod+Left exec	$(xdotool mousemove_relative --sync -- -15 0)
	# bindsym $mod+Right exec $(xdotool mousemove_relative --sync -- 15 0)
	# bindsym $mod+Down exec  $(xdotool mousemove_relative --sync -- 0 15)
	# bindsym $mod+Up   exec  $(xdotool mousemove_relative --sync -- 0 -15)
  # }

          # resize ..." 
      };

      window = {
        hideEdgeBorders = "smart";
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
keybindings = let mad="Mod4"; mod="Mod1"; 
    in {
        # todo use i3lock-fancy instead
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock";
        "${mad}+h"="rofi -modi 'clipboard:greenclip print' -show clipboard";
        "${mod}+shift+n"="exec ${pkgs.gnome3.nautilus}/bin/nautilus";
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
      "$GroupFr+$mod+apostrophe"="kill";
      "$GroupUs+$mod+4"="kill";
        "XF86AudioRaiseVolume"="exec --no-startup-id pactl set-sink-volume 0 +5%;exec notify-send 'Audio Raised volume'";
        "XF86AudioLowerVolume"="exec --no-startup-id pactl set-sink-volume 0 -5%;exec notify-send 'Audio lowered'";
        "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;";
      }
      // bind_ws 1 "a" "q"
      // bind_ws 2 "z" "w"
      // bind_ws 3 "e" "e"
      // bind_ws 4 "q" "a"
      // bind_ws 5 "s" "s"
      // bind_ws 6 "d" "d"
      // bind_ws 7 "w" "z"
      // bind_ws 8 "x" "x"
      // bind_ws 9 "c" "c"
      ;
    };

# Media player controls
# bindsym XF86AudioPlay exec playerctl play
# bindsym XF86AudioPause exec playerctl pause
# bindsym XF86AudioNext exec playerctl next
# bindsym XF86AudioPrev exec playerctl previous
  };
  xsession.initExtra = ''
    ${pkgs.feh}/bin/feh --bg-fill /home/teto/dotfiles/wallpapers/nebula.jpg
  '';
}
