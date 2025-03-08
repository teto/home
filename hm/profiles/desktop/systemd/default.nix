{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
{
  # ~/.config/environment.d/10-home-manager.conf
  user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # SetLoginEnvironment=no
  };

  # when use-xdg-directories is true, the bin is in $XDG_STATE_HOME/
  # PATH= "${dotfilesPath}/bin";
  # /home/teto/.local/state/nix/profile/bin

  # systemctl --user show-environment to check value
  user.settings.Manager.DefaultEnvironment = {
    # c'est transforme en PATH=$'$PATH:/home/teto/.local/state/nix/profile/bin:/home/teto/home/bin' bizarrement
    # TODO add coreutils

    # settings.Manager.DefaultEnvironment
    # /home/teto/.local/state/nix/profile/bin refernece ceux installes par nix profile
    PATH = "/home/teto/.local/state/nix/profile/bin:${pkgs.coreutils}/bin:${dotfilesPath}/bin";
    NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/default/config";
  };
  # TODO move
  # systemd.user.settings.Manager.DefaultEnvironment = {
  #   # for vdirsyncer
  #   # NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/default/config";
  # };
  #
  #
  # # conditionnally define it
  # systemd.user.services.mujmap-fastmail.Service = {
  #   Environment = [
  #     "PATH=${
  #       pkgs.lib.makeBinPath [
  #         pkgs.pass-teto
  #         pkgs.bash
  #       ]
  #     }"
  #   ];
  #   # TODO add notmuch_CONFIG ?
  # };

  # TODO move somewhere else close to mbsync
  # copy load credential implem from https://github.com/NixOS/nixpkgs/pull/211559/files
  # systemd.user.services.mbsync = lib.mkIf config.services.mbsync.enable {
  #   Service = {
  #     # TODO need DBUS_SESSION_BUS_ADDRESS
  #     # --app-name="%N" toto
  #     Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
  #     # SetCredentialEncrypted=secrets.accounts.mail.fastmail_perso;
  #     # easier to update the file then regenarate the nix code
  #     # ImportCredential="fastmail_perso:/home/teto/home/secrets/mail.secret";
  #     LoadCredential = "fastmail_perso:${secretsFolder}/mail.secret";
  #     # LoadCredentialEncrypted="fastmail_perso:/home/teto/home/secrets/mail.secret";
  #     # TODO
  #     # FailureAction=''${pkgs.libnotify}/bin/notify-send "Failure"'';
  #     # TODO try to use LoadCredential
  #     # serviceConfig = {
  #     # DynamicUser = true;
  #     # PrivateTmp = true;
  #     # WorkingDirectory = "/var/lib/plausible";
  #     # StateDirectory = "plausible";
  #     # LoadCredential = [
  #     # "ADMIN_USER_PWD:${cfg.adminUser.passwordFile}"
  #     # "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
  #     # "RELEASE_COOKIE:${cfg.releaseCookiePath}"
  #     # ] ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [ "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"];
  #     # };
  #   };
  # };

  # systemd.user.settings
  #     Extra config options for user session service manager. See systemd-user.conf(5) for available options.
}
