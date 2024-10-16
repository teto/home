{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.mujmap;

  mujmapAccounts = filter (a: a.mujmap.enable) (attrValues config.accounts.email.accounts);

  mujmapOptions =
    optional (cfg.verbose) "--verbose"
    ++ optional (cfg.configFile != null) "-C ${cfg.configFile}";
in
# ++ [ (concatMapStringsSep " -a" (a: a.name) mujmapAccounts) ];
{
  meta.maintainers = [ maintainers.pjones ];

  options.services.mujmap = {
    enable = mkEnableOption "mujmap";

    package = mkOption {
      type = types.package;
      default = pkgs.mujmap;
      defaultText = literalExpression "pkgs.mujmap";
      example = literalExpression "pkgs.mujmap";
      description = "The package to use for the mujmap binary.";
    };

    frequency = mkOption {
      type = types.str;
      default = "*:0/5";
      description = ''
        How often to run mujmap.  This value is passed to the systemd
        timer configuration as the onCalendar option.  See
        {manpage}`systemd.time(7)`
        for more information about the format.
      '';
    };

    verbose = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether mujmap should produce verbose output.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Optional configuration file to link to use instead of
        the default file ({file}`~/.mujmaprc`).
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.mujmap" pkgs lib.platforms.linux)
    ];

    systemd.user.services = mapAttrs' (
      name: account:
      nameValuePair "mujmap-${name}" {
        Unit = {
          Description = "mujmap mailbox synchronization";
        };

        Service =
          let

          in
          # ${pkgs.dbus}/bin/dbus-send --system \
          #   / net.nuetzlich.SystemNotifications.Notify \
          #   "string:Problem detected with disk: $SMARTD_DEVICESTRING" \
          #   "string:Warning message from smartd is: $SMARTD_MESSAGE"
          # ''}
          {
            Type = "oneshot";
            # TODO adjust path
            ExecStart = "${cfg.package}/bin/mujmap -C ${config.accounts.email.maildirBasePath}/fastmail sync ${concatStringsSep " " mujmapOptions}";
          };

      }
    ) config.accounts.email.accounts;

    systemd.user.timers.mujmap = {
      Unit = {
        Description = "mujmap mailbox synchronization";
      };

      Timer = {
        OnCalendar = cfg.frequency;
        Unit = "mujmap.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
