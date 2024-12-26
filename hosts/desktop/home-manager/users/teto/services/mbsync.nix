{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.mbsync = {
    # disabled because mujmap does it better ?
    enable = false; # disabled because it kept asking for my password
    verbose = true; # to help debug problems in journalctl
    frequency = "*:0/5";
    # TODO add a echo for the log
    postExec = "${pkgs.notmuch}/bin/notmuch new";
  };

  # copy load credential implem from https://github.com/NixOS/nixpkgs/pull/211559/files
  # systemd.user.services.mbsync
  systemd.user.services.mbsync = lib.mkIf config.services.mbsync.enable {
    Service = {
      # TODO need DBUS_SESSION_BUS_ADDRESS
      # --app-name="%N" toto
      Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
      # SetCredentialEncrypted=secrets.accounts.mail.fastmail_perso;
      # easier to update the file then regenarate the nix code
      # ImportCredential="fastmail_perso:/home/teto/home/secrets/mail.secret";
      LoadCredential = "fastmail_perso:/home/teto/home/secrets/mail.secret";
      # LoadCredentialEncrypted="fastmail_perso:/home/teto/home/secrets/mail.secret";
      # TODO
      # FailureAction=''${pkgs.libnotify}/bin/notify-send "Failure"'';
      # TODO try to use LoadCredential
      # serviceConfig = {
      # DynamicUser = true;
      # PrivateTmp = true;
      # WorkingDirectory = "/var/lib/plausible";
      # StateDirectory = "plausible";
      # LoadCredential = [
      # "ADMIN_USER_PWD:${cfg.adminUser.passwordFile}"
      # "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
      # "RELEASE_COOKIE:${cfg.releaseCookiePath}"
      # ] ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [ "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"];
      # };
    };
  };
}
