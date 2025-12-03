{
  pkgs,
  flakeSelf,
  lib,
  dotfilesPath,
  secretsFolder,
  ...
}:
let
  nix-builders = import ./nix-builder.nix { inherit flakeSelf lib secretsFolder; };
  neovim = import ./neovim.nix { inherit flakeSelf lib; };
  notify-send = "${pkgs.libnotify}/bin/notify-send";

in
{
  inherit
    nix-builders
    neovim
    ;

  inherit (neovim)
    genBlockLua
    luaPlugin
    ;

  inherit (nix-builders)
    deployrsNodeToBuilderAttr
    nixosConfToBuilderAttr
    ;

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

  /*
    convert a package to null because used to be borken

    null wont work
  */
  ignoreBroken =
    x: builtins.traceVerbose "${x.name} disabled because broken it used to be broken" pkgs.hello;

}
