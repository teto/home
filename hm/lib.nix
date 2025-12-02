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
  muteAudio = pkgs.writeShellScript "mute-volume" ''

    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; ${notify-send} --icon=speaker_no_sound -e -h boolean:audio-toggle:1 -h string:synchronous:audio-volume -u low 'Toggling audio';
  '';

  # -f --image ~/.config/wallpapers/snow_woods.jpg"
  swaylockCmd = pkgs.writeShellScript "lock-screen" ''
    ${pkgs.swaylock-effects}/bin/swaylock
  '';

  # temporary solution since it's not portable
  getPassword =
    accountName:
    # let
    #   # https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
    #   # 	  export PASSWORD_STORE_GPG_OPTS=" --default-cache-ttl 34560000"
    #   script = pkgs.writeShellScriptBin "pass-show" ''
    #     ${pkgs.pass}/bin/pass show "$@" | ${pkgs.coreutils}/bin/head -n 1
    #   '';
    # in
    # ["${script}/bin/pass-show" accountName];
    [
      # ${pkgs.pass-teto}/bin/
      "${dotfilesPath}/bin/pass-perso"
      "show"
      accountName
    ];

}
