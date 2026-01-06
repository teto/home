# TODO rename
{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  # systemd template
  systemd.services."send-mail-to-teto@" = {
    # unitConfig = {
    #   Description = "Log success for %i";
    # };
    description = "Log success for %i";

    # requires
    # wantedBy
    unitConfig = {
      # StartLimitIntervalSec = 0;
      PropagatesStopTo = "";
      PropagatesReloadTo = "";
    };

    serviceConfig = {
      User = "teto"; # to access teto's msmtp config
      Type = "notify";

      # --read-envelope-from
      # TODO should be able to qualify service + result
      ExecStart = pkgs.writeShellScript "notify-service-result" ''
        # echo "Result: %i"
        SUBJECT=$1
        MSG=$2
        printf "Subject: notify service result %i\n\nTest body\n" | ${pkgs.msmtp}/bin/msmtp -afastmail "${secrets.users.teto.email}"
      '';
    };
  };
}
