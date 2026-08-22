# TODO move to lib/sway
{
  config,
  pkgs,
  lib,
  ...
}:
let
  term = "${pkgs.kitty}/bin/kitty";

  # key modifier
  # mad = "Mod4";
  mod = "Mod1";

  # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
  # Volume: 0.35
  # ❯ wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4
  # ❯ wpctl get-volume @DEFAULT_AUDIO_SINK@
  # Volume: 0.40
in
{
  # }}}

  sharedKeybindings = {
  };
  # just trying to overwrite previous bindings with i3dispatch
  # // lib.optionalAttrs (pkgs ? i3dispatch ) {
  # "${mod}+Left" = "exec ${pkgs.i3dispatch}/bin/i3dispatch left";
  # "${mod}+Right" = "exec ${pkgs.i3dispatch}/bin/i3dispatch right";
  # "${mod}+Down" = "exec ${pkgs.i3dispatch}/bin/i3dispatch down";
  # "${mod}+Up" = "exec ${pkgs.i3dispatch}/bin/i3dispatch up";
  # }
  # # The middle button over a titlebar kills the window
  # bindsym --release button2 kill
}
