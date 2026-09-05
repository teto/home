{
  config,
  pkgs,
  lib,
  dotfilesPath,
  ...
}:
let
  inherit (lib.sway) mod mad;
  # sharedConfig = pkgs.callPackage ./wm-config.nix { inherit config; };

  notify-send = "${pkgs.libnotify}/bin/notify-send";

  startNvimNotes = "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark neorg-notes --command 'kitty nvim +Notes'  ";

  brightnessScript = pkgs.tetos-brightness;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  mpc = "${pkgs.mpc}/bin/mpc";

  # pkgs.writeShellApplication
  getIntegerVolume = pkgs.writeShellScript "get-volume-as-integer" ''
    volume=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -f2 -d' ')
    ${pkgs.perl}/bin/perl -e "print 100 * $volume"
  '';

  audioKeybindings = {
    # wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+
    # wpctl get-volume @DEFAULT_AUDIO_SINK@
    # -l to limit max volume
    # -t is timeout in ms
    # -e to avoid keeping notif in history
    # TODO move to script like for brightness
    XF86AudioRaiseVolume =
      "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2;"
      # we disable when noctalias is enabled else we get double notifications
      +
        lib.optionalString (config.programs.noctalia.enable == false)
          "exec ${notify-send} -a Audio --icon=audio-volume-high -u low -t 1000 -h int:value:$(${getIntegerVolume}) -e -h string:synchronous:audio-volume 'Audio volume' 'Audio Raised volume'";
    XF86AudioLowerVolume =
      "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-;"
      +
        lib.optionalString (config.programs.noctalia.enable == false)
          "exec ${notify-send} -a Audio --icon=audio-volume-low-symbolic -u low -t 1000 -h int:value:$(${getIntegerVolume}) -e -h string:synchronous:audio-volume 'Audio volume' 'Lower audio volume'";

    XF86AudioMute = "exec --no-startup-id ${pkgs.tetos.muteAudio}";
    # XF86AudioLowerVolume = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%;exec ${notify-send} --icon=audio-volume-low-symbolic -u low 'Audio lowered'";
    # XF86AudioMute = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";

    # TODO reference brightnessctl
    XF86MonBrightnessUp = "exec ${brightnessScript}/bin/brightness-mgr up 10%";
    XF86MonBrightnessDown = "exec ${brightnessScript}/bin/brightness-mgr down 10%-";

    # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

    Mod4 = "exec anyrun";

    XF86AudioNext = "exec ${mpc} next; exec notify-send --icon=forward -h string:synchronous:mpd 'Audio next'";
    XF86AudioPrev = "exec ${mpc} next; exec notify-send --icon=backward -h string:synchronous:mpd 'Audio previous'";
    XF86AudioPlay = "exec ${mpc} toggle; exec notify-send --icon=play-pause -h string:synchronous:mpd 'mpd' 'Audio Pause' -e ";
    # XF86AudioPlay = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=media-playback-stop-symbolic -u low 'test'";

    XF86AudioStop = "exec ${mpc} stop; exec notify-send --icon=stop -h string:synchronous:mpd 'Stopped Audio' -e";
  };

in
{
  enable = true;
  xwayland = false;

  systemd.enable = true;
  # SWAYSOCK/WAYLAND etc
  # systemd.variables =  [ "PATH" ];

  config = {
    output = {
      # todo put a better path
      # example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };
      #  Some outputs may have different names when disconnecting and reconnecting. To identify these, the name can be substituted for a string consisting of the make, model and serial which you can get from swaymsg -t get_outputs. Each value must be  sepa‐ rated by one space. For example:
      #     output "Some Company ABC123 0x00000000" pos 1920 0
      # "*" = {
      #   adaptive_sync = "off";
      #   bg = "${dotfilesPath}/data/wallpapers/nebula.jpg fill";
      # };

    };

    keybindings = {
      "${mad}+m" = ''exec "${dotfilesPath}/rofi-scripts/monitor_layout.sh"; mode default;'';
      # use sway-easyfocus
      "${mad}+f" = "exec ${pkgs.sway-easyfocus}/bin/sway-easyfocus";
      # ideally we shouldn't care if it's firefox or not ?
      "${mad}+a" = ''exec "${dotfilesPath}/bin/focus-firefox-media"'';

      # TODO copy result and send notif
      "${mad}+c" = ''exec "${dotfilesPath}/bin/ocr-jap" && ${notify-send} 'Finished ocr' '';

      "${mod}+Shift+1" = "exec qutebrowser";

      # kitty nvim -c ":Neorg workspace notes"
      # Notes is a custom command
      "${mod}+F1" = startNvimNotes;

      "${mad}+n" = startNvimNotes;
      "${mad}+o" = startNvimNotes;

          "${mod}+F2" =
            "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark audio --command 'kitty ${lib.getExe' pkgs.rmpc "rmpc"}' ";

          # replace with 'avante' alias ?
          # "${mod}+F3" =
          #   ''exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 60 --height 50 --mark gp_nvim --command "kitty nvim -cLlmChat" '';

          # "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark neorg-notes --command 'kitty nvim +Notes'  ";

          "${mod}+a" =
            "exec ${pkgs.sway-scratchpad}/bin/sway-scratchpad --width 70 --height 60 --mark audio --command 'kitty ${lib.getExe' pkgs.rmpc "rmpc"}' ";

    }
        // lib.optionalAttrs config.programs.vicinae.enable {
          # vicinae://launch/clipboard/history
          # https://docs.vicinae.com/deeplinks
          # "${mod}+p" = "exec ${pkgs.tessen}/bin/tessen --dmenu=rofi";

          "${mod}+p" = "exec ${pkgs.vicinae}/bin/vicinae deeplink vicinae://launch/@tinkerbells/pass/pass";

          "${mod}+Ctrl+h" = "exec ${pkgs.vicinae}/bin/vicinae vicinae://launch/clipboard/history";
          "${mad}+w" = "exec ${pkgs.vicinae}/bin/vicinae deeplink vicinae://launch/wm/switch-windows";
        }
        # // lib.optionalAttrs config.services.clipcat.enable {
        #   "${mod}+Ctrl+h" =
        #     "exec ${pkgs.clipcat}/bin/clipcat-menu -f rofi  | ${sharedConfig.notify-send} 'Failed running clipcat' ";
        # }
    
    // audioKeybindings;
  };

  # disabling swayfx until  those get merged
  # https://github.com/nix-community/home-manager/pull/4039
  # https://github.com/NixOS/nixpkgs/pull/237044
  # be careful as this can override default options
  # package = pkgs.swayfx;
  # package = pkgs.sway-unwrapped;

  checkConfig = false;

  #  # useful for electron based apps: slack / vscode
  # export NIXOS_OZONE_WL=1
  extraSessionCommands = ''
    # needs qt5.qtwayland in systemPackages
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export SDL_VIDEODRIVER=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # select first igpu then nvidia
  '';
  # see https://github.com/swaywm/sway/wiki#i-have-a-multi-gpu-setup-like-intelnvidia-or-intelamd-and-sway-does-not-start--some-video-cards-cannot-display--full-screen-images-etc-will-be-corrupted
  # for multigpu setups
  # The first card is used for actual rendering, and display buffers are copied to the secondary cards for any displays connected to them.
  # export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1

}
