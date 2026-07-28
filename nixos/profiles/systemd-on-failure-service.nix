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
      Type = "oneshot";
      # Environment = [
      # "SERVICE_NAME=%n" # %n =>
      # "EXIT_CODE=%e" # this doesn't seem to exist
      # ];
      # --read-envelope-from
      # TODO should be able to qualify service + result
      #       "$MONITOR_UNIT" \
      # "$MONITOR_SERVICE_RESULT" \
      # "$MONITOR_EXIT_CODE" \
      # "$MONITOR_EXIT_STATUS" \
      # "$MONITOR_INVOCATION_ID"
      ExecStart =
        let
          #
          # # This will be 1 in case of error
          # # Healthchecks supports "fail" or 1 for this:
          # # https://healthchecks.srv.vtimofeenko.com/docs/signaling_failures/
          # EXIT_CODE=$MONITOR_EXIT_STATUS

          script = pkgs.writeShellScript "notify-service-result" ''
            # echo "Result: %i"
            SUBJECT=$1
            MSG=$2

            title="notify service result %i"

            # Get logs of last invocation
            # Source:
            # https://serverfault.com/questions/768901/is-there-a-way-to-make-journalctl-show-logs-from-the-last-time-foo-service-ran
            # Slight tweak -- needs InactiveExitTimestamp ?
            LAST_TIMESTAMP=$(systemctl show --property InactiveExitTimestamp --value "$MONITOR_UNIT")
            LOGS=$(journalctl --no-pager -u "$MONITOR_UNIT" --since "$LAST_TIMESTAMP")

            # strip leading spaces else msmtp will complain
            message=$(cat <<EOF
            To: ${secrets.users.teto.email}
            Subject: $title
            Content-Transfer-Encoding: 8bit
            Content-Type: text/plain; charset=UTF-8

            Systemd service [$MONITOR_UNIT] exited with exit value of $MONITOR_EXIT_STATUS

            $LOGS

            $LAST_TIMESTAMP
            EOF
            )

            echo "$message" | ${pkgs.msmtp}/bin/msmtp -afastmail
          '';
        in
        "${script} %i";

    };
  };
}
