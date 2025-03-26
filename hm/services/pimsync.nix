{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.pimsync;

  pimsyncOptions =
    [ ]
    ++ optional (cfg.verbosity != null) "--verbosity ${cfg.verbosity}"
    ++ optional (cfg.configFile != null) "--config ${cfg.configFile}";

in
{
  meta.maintainers = [ maintainers.pjones ];

  options.services.pimsync = {
    enable = mkEnableOption "pimsync";

    package = mkOption {
      type = types.package;
      default = pkgs.pimsync;
      defaultText = "pkgs.pimsync";
      example = literalExpression "pkgs.pimsync";
      description = "The package to use for the pimsync binary.";
    };

    frequency = mkOption {
      type = types.str;
      default = "*:0/5";
      description = ''
        How often to run pimsync.  This value is passed to the systemd
        timer configuration as the onCalendar option.  See
        {manpage}`systemd.time(7)`
        for more information about the format.
      '';
    };

    verbosity = mkOption {
      type = types.nullOr (
        types.enum [
          "CRITICAL"
          "ERROR"
          "WARNING"
          "INFO"
          "DEBUG"
        ]
      );
      default = null;
      description = ''
        Whether pimsync should produce verbose output.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Optional configuration file to link to use instead of
        the default file ({file}`$XDG_CONFIG_HOME/pimsync/config`).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.pimsync = {
      Unit = {
        Description = "pimsync calendar&contacts synchronization";
        PartOf = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        # TODO `pimsync discover`
        ExecStart =
          let
            optStr = concatStringsSep " " pimsyncOptions;
          in
          [
            # "${cfg.package}/bin/pimsync ${optStr} metasync"
            "${cfg.package}/bin/pimsync ${optStr} sync"
          ];
      };
    };

    systemd.user.timers.pimsync = {
      Unit = {
        Description = "pimsync calendar&contacts synchronization";
      };

      Timer = {
        OnCalendar = cfg.frequency;
        Unit = "pimsync.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
