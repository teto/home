# TODO rename
{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  # @ => systemd template
  /*
    <service_name>@<argument>.service
    %i passes the argument, specially formatted (escaped)
    %I passes the argument verbatim without escaping

    The script can use:
    - MONITOR_UNIT
    - "$MONITOR_SERVICE_RESULT"
    - "$MONITOR_EXIT_CODE"
    - "$MONITOR_EXIT_STATUS"
    - "$MONITOR_INVOCATION_ID"
  */
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
      Type = "oneshot";
      SyslogIdentifier = "notify-%i";
      ExecStart =
        # This will be 1 in case of error
        # Healthchecks supports "fail" or 1 for this:
        # https://healthchecks.srv.vtimofeenko.com/docs/signaling_failures/
        ''${lib.getExe pkgs.tetos-send-mail-failure} ${secrets.jakku.email} "Neotokyo: %i'';

    };
  };
}
