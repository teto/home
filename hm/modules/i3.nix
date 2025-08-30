{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.xsession.windowManager.i3;

in
{

  options = {
    xsession.windowManager.i3 = {

      enableAudioKeys = mkEnableOption "Enable audio hot keys";
    };

  };

  config = mkIf cfg.enableAudioKeys {
    # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
    # Volume: 0.35
    # ❯ wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4
    # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
    # Volume: 0.40
    xsession.windowManager.i3.config.keybindings =
      let
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        mpc = "${pkgs.mpc_cli}/bin/mpc";
        # pkgs.writeShellApplication
        getIntegerVolume = pkgs.writeShellScript "get-volume-as-integer" ''
          volume=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -f2 -d' ')
          ${pkgs.perl}/bin/perl -e "print 100 * $volume"
        '';
        getBrightness = pkgs.writeShellScript "get-volume-as-integer" ''
          # -m => machine
          brightness=$(${pkgs.brightnessctl}/bin/brightnessctl -m info | cut -f4 -d, )
          echo $brightness
        '';

      in
      # { name = "get-volume-as-integer";
      #   runtimeInputs = [ pkgs.wireplumber ];
      #   text = ''
      #   out=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -f2 -d' ')
      #   echo $(( 100 * $out ))
      #   '';
      #   checkPhase = ":";
      # };
      {
        # wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+
        # wpctl get-volume @DEFAULT_AUDIO_SINK@
        # -l to limit max volume
        # -t is timeout in ms
        XF86AudioRaiseVolume = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2;exec ${notify-send} --icon=audio-volume-high -u low -t 1000 -h int:value:$(${getIntegerVolume}) -h string:synchronous:audio-volume 'Audio volume' 'Audio Raised volume'";
        XF86AudioLowerVolume = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-;exec ${notify-send} --icon=audio-volume-low-symbolic -u low -t 1000 -h int:value:$(${getIntegerVolume}) -h string:synchronous:audio-volume 'Audio volume' 'Lower audio volume'";

        XF86AudioMute = "exec --no-startup-id ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle;exec ${notify-send} --icon=speaker_no_sound -h boolean:audio-toggle:1 -h string:synchronous:audio-volume -u low 'Toggling audio'";
        # XF86AudioLowerVolume = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%;exec ${notify-send} --icon=audio-volume-low-symbolic -u low 'Audio lowered'";
        # XF86AudioMute = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";

        # brightnessctl brightness-low
        XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%; exec ${notify-send} --icon=brightness -u low -t 1000 -h int:value:$(${getBrightness}) -h string:synchronous:brightness-level 'Brightness' 'Raised brightness'";
        XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-; exec ${notify-send} --icon=brightness-low -u low -t 1000 -h int:value:$(${getBrightness}) -h string:synchronous:brightness-level 'Brightness' 'Lowered brightness'";
        # XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";

        # "XF86Display" = "exec " + ../../rofi-scripts/monitor_layout.sh ;

        XF86AudioNext = "exec ${mpc} next; exec notify-send --icon=forward -h string:synchronous:mpd 'Audio next'";
        XF86AudioPrev = "exec ${mpc} next; exec notify-send --icon=backward -h string:synchronous:mpd 'Audio previous'";
        # XF86AudioPrev exec mpc prev; exec notify-send "Audio prev"
        XF86AudioPlay = "exec ${mpc} toggle; exec notify-send --icon=play-pause -h string:synchronous:mpd 'mpd' 'Audio Pause'";
        # XF86AudioPause (pas presente sur mon clavier ?

        XF86AudioStop = "exec ${mpc} stop; exec notify-send --icon=stop -h string:synchronous:mpd 'Stopped Audio'";

        # XF86AudioPlay = "exec ${pkgs.vlc}/bin/vlc; exec ${notify-send} --icon=media-playback-stop-symbolic -u low 'test'";
        "--release Print" = "exec ${pkgs.flameshot}/bin/scrot -s '/tmp/%s_%H%M_%d.%m.%Y_$wx$h.png'";

      };
  };
}
