{ config, lib, pkgs, ... }:

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

  # config = lib.mkMerge [
  #   (mkIf cfg.orgmode.enable {
  #     programs.neovim.plugins = cfg.orgmode.plugins;
  #   })
  # ];

  config = mkIf cfg.enableAudioKeys {
	# ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
	# Volume: 0.35
	# ❯ wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4
	# ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
	# Volume: 0.40
	xsession.windowManager.i3.config.keybindings = let 
	 notify-send = "${pkgs.libnotify}/bin/notify-send";
	in

	 {
    "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@  +5%;exec ${notify-send} --icon=audio-volume-high -u low -t 1000 'Audio Raised volume'";
    "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%;exec ${notify-send} --icon=audio-volume-low-symbolic -u low 'Audio lowered'";
    "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle;exec ${notify-send} --icon=speaker_no_sound -u low 'test'";
   };
  };
}

