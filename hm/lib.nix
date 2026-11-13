{
  pkgs,
  lib,
  flakeSelf,
  dotfilesPath,
  ...
}:
let
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{

  # TODO pass icon
  # muteAudio = pkgs.writeShellScript "mute-volume" ''
  #
  #   ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;
  # '' + lib.optionalString
  #   ${notify-send} --icon=speaker_no_sound -e -h boolean:audio-toggle:1 -h string:synchronous:audio-volume -u low 'Toggling audio';
  # '';
  #
  # -f --image ~/.config/wallpapers/snow_woods.jpg"
  swaylockCmd = pkgs.writeShellScript "lock-screen" ''
    ${pkgs.swaylock-effects}/bin/swaylock
  '';

}
