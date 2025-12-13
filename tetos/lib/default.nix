{
  pkgs,
  flakeSelf,
  lib,
  dotfilesPath,
  secretsFolder,
  ...
}:
let
  firefox = pkgs.callPackage ./firefox.nix {};
  nix-builders = import ./nix-builder.nix { inherit flakeSelf lib secretsFolder; };
  neovim = import ./neovim.nix { inherit flakeSelf lib; };
  notify-send = "${pkgs.libnotify}/bin/notify-send";

in
{
  inherit
    nix-builders
    firefox
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


    # generate a client ssh config from the server config
    # https://fmartingr.com/blog/2022/08/12/using-ssh-config-match-to-connect-to-a-host-using-multiple-ip-or-hostnames/
    genSshClientConfig =
        name: value:
        let
          mcfg = value;
          sshCfg = mcfg.config.services.openssh;
        in
        builtins.trace "SSH config for ${name}" (
          lib.optionalAttrs sshCfg.enable
            # lib.warn if "teto" is not in users.users
            (
              {
                match = ''host="${mcfg.config.networking.hostName},${mcfg.config.networking.domain}"'';
                # assumption ? or check/warn it has it ?
                user = "teto";
                identityFile = "${secretsFolder}/ssh/id_rsa";
                port = builtins.head sshCfg.ports;
                identitiesOnly = true;
                extraOptions = {
                  AddKeysToAgent = "yes";
                  HostName = lib.throwIf (mcfg.config.networking.domain == null) 
                      "Missing domaing for ${name}" 
                  mcfg.config.networking.domain ;
                };
              }
            )
        );


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
