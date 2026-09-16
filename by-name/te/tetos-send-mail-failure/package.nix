{ writeShellScriptBin, msmtp }:

# TODO complain loudly if incorrect number of arguments !
writeShellScriptBin "notify-service-result" ''

  if [ $# -lt 2 ]; then 
    echo "Usage: <DESTINATION_EMAIL> <SUBJECT>"
    exit 1
  fi

  TO="$1"
  SUBJECT="$2"

  echo "Looking at monitor_unit=$MONITOR_UNIT"
  echo "with exit status=$MONITOR_EXIT_STATUS"

  # Get logs of last invocation
  # Source:
  # https://serverfault.com/questions/768901/is-there-a-way-to-make-journalctl-show-logs-from-the-last-time-foo-service-ran
  # Slight tweak -- needs InactiveExitTimestamp ?
  LAST_TIMESTAMP=$(systemctl show --property InactiveExitTimestamp --value "$MONITOR_UNIT")
  LOGS=$(journalctl --no-pager -u "$MONITOR_UNIT" --since "$LAST_TIMESTAMP")

  # strip leading spaces else msmtp will complain
  message=$(cat <<EOF
  To: ''${TO}
  Subject: ''${SUBJECT}
  Content-Transfer-Encoding: 8bit
  Content-Type: text/plain; charset=UTF-8

  Systemd service [$MONITOR_UNIT] exited value [$MONITOR_EXIT_STATUS].

  Logs:
  ===
  $LOGS
  ===

  $LAST_TIMESTAMP
  EOF
  )

  # TODO use msmtpq instead ?
  echo "$message" | ${msmtp}/bin/msmtp --read-recipients -afastmail
''
