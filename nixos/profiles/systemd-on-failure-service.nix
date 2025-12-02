{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.services."send-mail-to-teto@" = {
    # unitConfig = {
    #   Description = "Log success for %i";
    # };
    description = "Log success for %i";

    serviceConfig = {
      Type = "notify";

      # /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" \
      #   ${pkgs.libnotify}/bin/notify-send -t 60000 -i dialog-warning "Interrupted" "Scan interrupted. Don't forget to have it run to completion at least once a week!"
      # exit 1

      # writeShellScript ?
      ExecStart = pkgs.writeShellScript "mail-success" ''
        ADDRESS=$1
        msmtp --serverinfo
      '';
    };
  };
}
