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
    # in/dbus-update-activation-environment --systemd --all
    # SetLoginEnvironment=no
  };

  # when use-xdg-directories is true, the bin is in $XDG_STATE_HOME/
  # /home/teto/.local/state/nix/profile/bin

  # systemctl --user show-environment to check value
  user.settings.Manager.DefaultEnvironment = {
    # c'est transforme en PATH=$'$PATH:/home/teto/.local/state/nix/profile/bin:/home/teto/home/bin' bizarrement
    # TODO add coreutils

    # settings.Manager.DefaultEnvironment
    # /home/teto/.local/state/nix/profile/bin refernece ceux installes par nix profile
    PATH = "/home/teto/.local/state/nix/profile/bin:${pkgs.coreutils}/bin:${dotfilesPath}/bin";
    NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/default/config"; # for vdirsyncer
  };

  # TODO conditionnally define it
  # lib.mkIf config.mujmap-fastmail.enable
  # TODO try an equivalent with mail
  user.services = {
    # copied from nixos nixos/doc/manual/administration/service-mgmt.chapter.md, hoping it works the same
    # needs DBUS_SESSION_BUS_ADDRESS
    "desktop-notification@" = {
      Service = {
        ExecStart =
          let
            myScript = pkgs.writeScript "notify-and-wait" ''
              #!${pkgs.stdenv.shell}

              notify_and_wait() {
                ADDRESS=$1
                USERID=''${ADDRESS#/run/user/}
                # gnome-shell doesn't respect the timeout from notify-send,
                # hence the additional timeout command to make sure we exit
                # before the end of time
                if [ "$result" = "interrupt" ]; then
                  /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" \
                    ${pkgs.libnotify}/bin/notify-send -t 60000 -i dialog-warning "Interrupted" "Process failed"
                  exit 1
                fi
              }
              for ADDRESS in /run/user/*; do
                notify_and_wait "$ADDRESS" &
              done
            '';
            # %n => full unit name
          in
          "${myScript} %n";
      };
    };

    # "base-unit@".serviceConfig = {
    #   ExecStart = "...";
    #   User = "...";
    # };
    # "base-unit@instance-a" = {
    #   overrideStrategy = "asDropin"; # needed for templates to work
    #   wantedBy = [ "multi-user.target" ]; # causes NixOS to manage the instance
    # };

    # TODO enable conditionnally on account/services
    mujmap-fastmail = {
      Service = {
        Environment = [
          "GNUPGHOME=${config.programs.gpg.homedir}"
          "PATH=${
            pkgs.lib.makeBinPath [
              pkgs.pass-teto
              pkgs.bash
            ]
          }"
        ];
      };
      # unitConfig.OnFailureJobMode = "isolate";

      Unit = {
        # TODO add notmuch_CONFIG ?
        OnFailure = "desktop-notification@%i.service";
        After = "gpg-agent.socket";
        Wants = "gpg-agent.socket";
      };
    };

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
    # user.services.
    swayrd.Service = lib.mkIf config.programs.swayr.enable {
      Environment = [
        "PATH=${
          lib.makeBinPath [
            pkgs.fuzzel
            pkgs.wofi
          ]
        }"
      ];
    };

    # user.services.
    pimsync.Service = lib.mkIf config.programs.pimsync-teto.enable {
      Environment = [
        "PATH=$PATH:${
          pkgs.lib.makeBinPath [
            pkgs.pass-teto
            pkgs.bash
          ]
        }"
      ];

      # The [Unit] section accepts an OnFailure option. This is a space-separated list of one or more units that are activated when this unit enters the “failed” state.
      OnFailure = "desktop-notification@%i.service";
      # PrivateTmp=true
    };
  };


  targets = {

    # overriding the default of `Requires = [ "graphical-session-pre.target" ];`
    # seems like tray target never starts ?
    tray.Unit.Requires = [];

  };

}
