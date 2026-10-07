{ lib, ... }:
{
  # then coredumpctl debug will launch gdb !
  # boot.kernel.sysctl."kernel.core_pattern" = "core"; to disable.
  # security.pam.loginLimits
  coredump.enable = false;
  # see
  #JournalSizeMax=767M
  #MaxUse=
  #KeepFree=
  coredump.settings.Coredump = ''
    #Storage=external
    #Compress=yes
    ProcessSizeMax=5G
    ExternalSizeMax=10G
  '';

  # sleep.settings.Sleep = {
  #   HibernateDelaySec="30m";
  #   SuspendState="mem";
  # };

  # This environment variable prevents the AWS cli from trying to fetch
  # metadata at the initialisation, and allow us to win 6 seconds of
  # waiting at each nix command.
  # See https://github.com/aws/aws-cli/issues/5623
  services.nix-daemon.serviceConfig.Environment = [ "AWS_EC2_METADATA_DISABLED=true" ];

  # force restart / do it only if enabled
  services.systemd-resolved.stopIfChanged = lib.mkForce true;

  # "desktop-notification@" = {
  #   description = "Log success for %i";
  #
  #
  #   Service = {
  #     Type = "oneshot";
  #     SyslogIdentifier = "notify-%i";
  #     ExecStart =
  #       let
  #         myScript = pkgs.writeScript "notify-and-wait" ''
  #           #!${pkgs.stdenv.shell}
  #
  #           notify_and_wait() {
  #             ADDRESS=$1
  #             USERID=''${ADDRESS#/run/user/}
  #             # gnome-shell doesn't respect the timeout from notify-send,
  #             # hence the additional timeout command to make sure we exit
  #             # before the end of time
  #             if [ "$result" = "interrupt" ]; then
  #               /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" \
  #                 ${pkgs.libnotify}/bin/notify-send -t 60000 -i dialog-warning "Interrupted" "Process failed"
  #               exit 1
  #             fi
  #           }
  #           for ADDRESS in /run/user/*; do
  #             notify_and_wait "$ADDRESS" &
  #           done
  #         '';
  #         # %n => full unit name
  #       in
  #       "${myScript} %n";
  #   };
  # };

}
