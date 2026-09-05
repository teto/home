{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.disk-space-alert;
in
{
  options.services.disk-space-alert = {
    enable = lib.mkEnableOption "email alerts when a filesystem is almost full";

    fileSystem = lib.mkOption {
      type = lib.types.str;
      default = "/";
      description = "Filesystem or path whose usage should be monitored.";
    };

    threshold = lib.mkOption {
      type = lib.types.ints.between 1 100;
      default = 90;
      description = "Percentage of used space at which an alert is sent.";
    };

    recipient = lib.mkOption {
      type = lib.types.str;
      description = "Email address that receives disk-space alerts.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "teto";
      description = "User whose msmtp configuration is used.";
    };

    account = lib.mkOption {
      type = lib.types.str;
      default = "fastmail";
      description = "Name of the msmtp account used to send alerts.";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "15m";
      example = "1h";
      description = "How often the filesystem usage is checked.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.disk-space-alert = {
      description = "Check filesystem usage and send an email alert";

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        StateDirectory = "disk-space-alert";
      };

      script = ''
        set -eu

        state_file=/var/lib/disk-space-alert/alert-sent
        usage=$(${pkgs.coreutils}/bin/df --output=pcent -- ${lib.escapeShellArg cfg.fileSystem} \
          | ${pkgs.coreutils}/bin/tail -n 1 \
          | ${pkgs.coreutils}/bin/tr -dc '0-9')

        if [ -z "$usage" ]; then
          echo "Could not determine disk usage for ${cfg.fileSystem}" >&2
          exit 1
        fi

        send_mail() {
          subject=$1
          body=$2
          {
            ${pkgs.coreutils}/bin/printf 'To: %s\n' ${lib.escapeShellArg cfg.recipient}
            ${pkgs.coreutils}/bin/printf 'Subject: %s\n' "$subject"
            ${pkgs.coreutils}/bin/printf 'Content-Type: text/plain; charset=UTF-8\n\n'
            ${pkgs.coreutils}/bin/printf '%s\n\n' "$body"
            ${pkgs.coreutils}/bin/df -h -- ${lib.escapeShellArg cfg.fileSystem}
          } | ${pkgs.msmtp}/bin/msmtp \
            --account=${lib.escapeShellArg cfg.account} \
            -- ${lib.escapeShellArg cfg.recipient}
        }

        if [ "$usage" -ge ${toString cfg.threshold} ]; then
          if [ ! -e "$state_file" ]; then
            send_mail \
              "[$(${pkgs.nettools}/bin/hostname)] disk usage is $usage%" \
              "${cfg.fileSystem} has reached $usage% usage (threshold: ${toString cfg.threshold}%)."
            ${pkgs.coreutils}/bin/touch "$state_file"
          fi
        elif [ -e "$state_file" ]; then
          send_mail \
            "[$(${pkgs.nettools}/bin/hostname)] disk usage recovered to $usage%" \
            "${cfg.fileSystem} is back below the ${toString cfg.threshold}% threshold."
          ${pkgs.coreutils}/bin/rm "$state_file"
        fi
      '';
    };

    systemd.timers.disk-space-alert = {
      description = "Periodically check filesystem usage";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = cfg.interval;
        Unit = "disk-space-alert.service";
      };
    };
  };
}
