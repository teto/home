{ pkgs, lib, ... }:
let
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  genBlockLua = title: content: ''
    -- ${title} {{{
    ${content}
    -- }}}
  '';
in
{

  # TODO pass icon
  muteAudio = pkgs.writeShellScript "mute-volume" ''

    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; ${notify-send} --icon=speaker_no_sound -e -h boolean:audio-toggle:1 -h string:synchronous:audio-volume -u low 'Toggling audio';
  '';

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
      "pass-perso"
      "show"
      accountName
    ];

  # TODO hopefully should get upstreamed
  mkRemoteBuilderDesc =
    machine:
    with lib;
    concatStringsSep " " ([
      "${optionalString (machine.sshUser != null) "${machine.sshUser}@"}${machine.hostName}"
      (
        if machine.system != null then
          machine.system
        else if machine.systems != [ ] then
          concatStringsSep "," machine.systems
        else
          "-"
      )
      (if machine.sshKey != null then machine.sshKey else "-")
      (toString machine.maxJobs)
      (toString machine.speedFactor)
      (concatStringsSep "," (machine.supportedFeatures ++ machine.mandatoryFeatures))
      (concatStringsSep "," machine.mandatoryFeatures)
      # assume we r always > 2.4
      (if machine.publicHostKey != null then machine.publicHostKey else "-")
    ]);

  luaPlugin =
    attrs:
    attrs
    // {
      type = "lua";
      config = lib.optionalString (attrs ? config && attrs.config != null) (
        genBlockLua attrs.plugin.pname attrs.config
      );
    };

  inherit genBlockLua;

  /* 
  convert a package to null because used to be borken


  null wont work
  */
  ignoreBroken = x: builtins.traceVerbose "${x.name} disabled because broken it used to be broken" pkgs.hello;

}
