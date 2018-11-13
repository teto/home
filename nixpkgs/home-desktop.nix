{ config, pkgs, lib,  ... }:
let
  stable = import <nixos> {}; # https://nixos.org/channels/nixos
  unstable = import <nixos-unstable> {}; # https://nixos.org/channels/nixos-unstable

  texliveEnv = pkgs.texlive.combine {
    # tabularx is not available
    inherit (pkgs.texlive) scheme-small cleveref latexmk bibtex algorithms cm-super
    csvsimple subfigure  glossaries biblatex logreq xstring biblatex-ieee subfiles mfirstuc;
   };

  i3extraConfig = lib.concatStrings [
    (builtins.readFile ../config/i3/config.main)
    (builtins.readFile ../config/i3/config.xp)
    (builtins.readFile ../config/i3/config.colors)
  ];

  devPkgs = with pkgs; [
    # cabal-install
    # cabal2nix
    editorconfig-core-c
    exa
    gdb
    git-review # to contribute to wireshark
    gitAndTools.diff-so-fancy
    # https://github.com/felipec/git-remote-hg
    gitAndTools.git-remote-hg
    gitAndTools.git-recent
    # gitAndTools.git-annex # fails on unstable
    gitAndTools.git-extras
    gitAndTools.git-crypt
    # mypy # TODO move it to neovim dependency (but need to fetch the pythonEnv path then)
    nox # helps with reviewing and to install files
    # ccache # breaks some builds ?
    ncurses.dev # for infocmp
    neovim-remote
    nix-prefetch-scripts
    nix-index
    pcalc
    rpl # to replace strings across files
    universal-ctags  # there are many different ctags, be careful !
  ];

  imPkgs = with pkgs; [
    # gnome3.california # fails
    khal # => vdirsyncer !
    khard
    libsecret
    newsboat
    slack
    vdirsyncer
    weechat

    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ];

  desktopPkgs = with pkgs; [
    apvlv
    buku # generates error
    # gcalc
    unstable.dropbox
    # gnome3.eog # eye of gnome = image viewer / creates a collision
    gnome3.networkmanagerapplet # should 
    gnome3.defaultIconTheme # else nothing appears
    mpv
    libnotify
    # feh
    unstable.evince # succeed where zathura/mupdf fail
    # conflicts with nautilus
    # unstable.gnome3.file-roller # for GUI archive handling
    ffmpegthumbnailer # to preview videos in ranger
    # todo try sthg else
    # requires xdmcp https://github.com/freedesktop/libXdmcp
    # haskellPackages.greenclip # todo get from haskell
    unstable.gnome3.eog
    moc
    mupdf.bin # evince does better too
    # mdp # markdown CLI presenter
    # gnome3.gnome_control_center
    unstable.gnome3.gnome-calculator
    pass
    qtpass
    sublime3
    scrot # screenshot app
    sxiv # simple image viewer
    unstable.system_config_printer
    # shared_mime_info # temporary fix for nautilus to find the correct files
    tagainijisho # japanse dict; like zkanji Qt based
    translate-shell
    unstable.transmission_gtk
    xdotool # needed for vimtex + zathura
    xarchiver # to unpack/pack files
    xorg.xev
    xorg.xbacklight
    xclip
    xcwd
    # zathura
  ];

  home.sessionVariables = {
    # JUPYTER_CONFIG_DIR= 
  };

  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with unstable.pkgs;[
    # anki          # spaced repetition system
    # hopefully we can remove this from the environment
    # it's just that I can't setup latex correctly
    unstable.libreoffice
    qutebrowser  # keyboard driven fantastic browser
    gnome3.nautilus # demande webkit/todo replace by nemo ?
    shutter # screenshot utility
    mcomix # manga reader
    # mendeley # requiert qtwebengine
    pinta    # photo editing
    stable.qtcreator  # for wireshark
    zeal       # doc for developers
    vifm
    # zotero     # doc software
    # wavemon
    # astroid # always compiles webkit so needs 1 full day
  ];
in
{

  imports = [
    ./home-common.nix
  ];

  home.packages = desktopPkgs ++ devPkgs ++ heavyPackages
  ++ imPkgs ++ [
    pkgs.cachix
    ]
   ;

  programs.neovim = import ./neovim.nix {
    inherit pkgs lib 
    # texliveEnv
    ; 
  };

  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
  };

  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    # package = unstable.firefox;
  #   enableAdobeFlash = false;

    # Not accepted. we should find another way to enable it
    # pass package for instance
    # enableBukubrow = true;
  };

  programs.browserpass = {
    enable=true;
    browsers = ["firefox" "chromium" ];
  };

  services.gnome-keyring = {
    enable=true;
  };

  services.network-manager-applet.enable = true;

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.termite}/bin/termite";
    borderWidth = 1;
    theme = "solarized_alternate";
    # lines= ;
    location = "center";

    # rofi.font: SourceCodePro 9
    # font = 
    extraConfig=''
      !rofi.opacity: 90
      !rofi.width: 50
      rofi.columns: 1
      rofi.fuzzy: true
      ! cd window
      rofi.modi:       run,drun,window,ssh,Layouts:${../bin/i3-list-layouts}
      /* see to integrate teiler */
      rofi.sidebar-mode: true

      rofi.kb-mode-previous: Alt+Left
      rofi.kb-mode-next:	Alt+Right,Alt+Tab
    '';
  };

  services.dunst = {
    enable=true;
    settings = {
      global={
        markup="full";
        sticky_history = true;
    # # Maximum amount of notifications kept in history
    # history_length = 20

    # # Display indicators for URLs (U) and actions (A).
        show_indicators = true;
        # TODO move it to module
        # browser = "";
        # dmenu = /usr/local/bin/rofi -dmenu -p dunst:
        alignment = "right";

      };
    };
  };


  services.random-background = {
    enable = false;
    # imageDirectory = 
    # interval = 
  };

  # services.screen-locker.enable = true;

  # while waiting to fix greenclip related problems
  services.parcellite.enable = true;

  # might trigger nm-applet crash ?
  services.gpg-agent = {
    enable = false;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    # grabKeyboardAndMouse= false;
    verbose = true;
  };

  # i3 now available !
  xsession = {
    enable = true;
    # export ZDOTDIR
    profileExtra = ''
      # export ZDOTDIR=
    '';

    initExtra = ''
      ${pkgs.feh}/bin/feh --bg-fill /home/teto/dotfiles/wallpapers/nebula.jpg
    '';
  };
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
        "$GroupFr+$mod+${fr}"="workspace \"$w${ws}\"";
        "$GroupUs+$mod+${us}"="workspace \"$w${ws}\"";
        "$GroupFr+Shift+$mod+${fr}"=''move container to workspace "$w${ws}"'';
        "$GroupUs+Shift+$mod+${us}"=''move container to workspace "$w${ws}"'';
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
        { command= "setxkbmap -layout us"; always = true; notification = false; }
        # { command= "xkblayout-state set +1"; always = false; notification = false; }
        # todo convert to a HM stuff
        # { command= "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon"; always = false; notification = false; }
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
            "$GroupFr+$mod+${fr}"="move workspace to output ${dir}";
            "$GroupUs+$mod+${us}"="move workspace to output ${dir}";
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

  # consider using lib.mkOptionDefault according to help
    keybindings = 
    let 
      mad="Mod4"; mod="Mod1"; 
      notify-send = "${pkgs.libnotify}/bin/notify-send";

      move_focused_wnd = dir: fr: us:
      {
        "$GroupFr+$mod+Shift+${fr}"="move ${dir}";
        "$GroupUs+$mod+Shift+${us}"="move ${dir}";
      };
    in 
    {
        # todo use i3lock-fancy instead
        # alternative is "light"
        # set $greenclip "rofi -modi 'clipboard:greenclip print' -show clipboard"
        "${mod}+ctrl+v" = "exec ${pkgs.bash}/bin/bash ~/vim-anywhere/bin/run";
        "${mod}+Tab"="exec \"${pkgs.rofi}/bin/rofi -modi 'run,drun,window,ssh' -show run\"";
        "${mod}+Ctrl+L"="exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy";
        # "${mod}+Ctrl+h" = ''exec "${pkgs.rofi}/bin/rofi -modi 'clipboard:greenclip print' -show clipboard"'';
        "${mod}+ctrl+b" = "exec " + ../buku_run/buku_run;
        "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        "${mod}+2" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        "${mod}+3" = "exec ${pkgs.buku_run}/bin/buku_run";
        "${mod}+b" = "exec ${pkgs.buku_run}/bin/buku_run";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
        # "${mod}+shift+p" = "focus parent";

        # "${mod}+shift+n" = "exec ${unstable.gnome3.nautilus}/bin/nautilus";
        # "${mod}+quotedbl" =  "exec ${unstable.qutebrowser}/bin/qutebrowser";

      # "${mod}+Shift+Return" = "exec --no-startup-id ${pkgs.termite -d "$(xcwd)"
# bindsym $GroupFr+$mod+eacute i3-list-windows
# bindsym $GroupUs+$mod+2 i3-list-windows

        # "${mod}+shift+q"="exec ${pkgs.gnome3.nautilus}/bin/nautilus";
        "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
        "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";

        # TODO use i3
        # test rofi-randr
        "XF86Display" = "exec " + ../rofi-scripts/monitor_layout.sh ;

# bindsym $mod+ctrl+h exec $greenclip
# bindsym $mod+ctrl+v exec ~/.vim-anywhere/bin/run"

# set $greenclip "rofi -modi 'clipboard:greenclip print' -show clipboard"
#       bindsym $mad+h exec $greenclip
        # TODO let i3dispatch

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
        "XF86AudioRaiseVolume"="exec --no-startup-id pactl set-sink-volume 0 +5%;exec ${notify-send} 'Audio Raised volume'";
        "XF86AudioLowerVolume"="exec --no-startup-id pactl set-sink-volume 0 -5%;exec ${notify-send} 'Audio lowered'";
        "XF86AudioMute"="exec --no-startup-id pactl set-sink-mute 0 toggle;";
        "XF86AudioPlay" = "exec ${pkgs.vlc}/bin/vlc";
        "--release Print" = "exec ${pkgs.scrot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";
        # bindsym --release Print exec "scrot -m '/home/user/Pictures/screenshots/%s_%H%M_%d.%m.%Y_$wx$h.png'"
        # bindsym --release Shift+Print exec "scrot -s '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"
        # bindsym --release $mod+Shift+Print exec "scrot -u -d 4 '/home/user/Pictures/screenshots/%s_%H%M_%d%m%Y_$wx$h.png'"

# Media player controls
# bindsym XF86AudioPlay exec playerctl play
# bindsym XF86AudioPause exec playerctl pause
# bindsym XF86AudioNext exec playerctl next
# bindsym XF86AudioPrev exec playerctl previous
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
      // move_focused_wnd "left" "h" "h"
      // move_focused_wnd "down" "j" "j"
      // move_focused_wnd "up" "k" "k"
      # semicolumn
      // move_focused_wnd "right" "l" "l" 
      # just trying to overwrite previous bindings with i3dispatch
      // lib.optionalAttrs true {
      "${mod}+Left" = "exec ${pkgs.i3dispatch}/bin/i3dispatch left";
      "${mod}+Right" = "exec ${pkgs.i3dispatch}/bin/i3dispatch right";
      "${mod}+Down" = "exec ${pkgs.i3dispatch}/bin/i3dispatch down";
      "${mod}+Up" = "exec ${pkgs.i3dispatch}/bin/i3dispatch up";
      }
    ;
    };

  };

    systemd.user.services.vdirsyncer = {
      Unit = {
        After = [ "network.target" ];
        Description = "Vdirsyncer Daemon";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Environment = "PATH=${config.home.profileDirectory}/bin";
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
        Type = "notify";
        # ExecStartPre = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${cfg.dataDir}' '${cfg.playlistDirectory}'"'';
      };
    };
}
