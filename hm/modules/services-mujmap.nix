# this completes programs.mujmap by generating the necessary timers
# todo upstream
{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.mujmap;

  mujmapAccounts = lib.filter (a: a.mujmap.enable) (lib.attrValues config.accounts.email.accounts);

  mujmapOptions =
    lib.optional (cfg.verbose) "--verbose"
    ++ lib.optional (cfg.configFile != null) "-C ${cfg.configFile}";
in
# ++ [ (concatMapStringsSep " -a" (a: a.name) mujmapAccounts) ];
{
  meta.maintainers = [ ];

  options.services.mujmap = {
    enable = lib.mkEnableOption "mujmap";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mujmap;
      defaultText = lib.literalExpression "pkgs.mujmap";
      example = lib.literalExpression "pkgs.mujmap";
      description = "The package to use for the mujmap binary.";
    };

    frequency = lib.mkOption {
      type = lib.types.str;
      default = "*:0/5";
      description = ''
        How often to run mujmap.  This value is passed to the systemd
        timer configuration as the onCalendar option.  See
        {manpage}`systemd.time(7)`
        for more information about the format.
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether mujmap should produce verbose output.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional configuration file to link to use instead of
        the default file ({file}`~/.mujmaprc`).
      '';
    };
  };

  config =
    let

      mkMujmapServiceName = name: "mujmap-${name}";
    in
    lib.mkIf cfg.enable {
      assertions = [
        (lib.hm.assertions.assertPlatform "services.mujmap" pkgs lib.platforms.linux)
      ];

      systemd.user.services = lib.mapAttrs' (
        name: account:
        lib.nameValuePair (mkMujmapServiceName name) {
          Unit = {
            Description = "mujmap mailbox synchronization";
          };

          Service =
            # ${pkgs.dbus}/bin/dbus-send --system \
            #   / net.nuetzlich.SystemNotifications.Notify \
            #   "string:Problem detected with disk: $SMARTD_DEVICESTRING" \
            #   "string:Warning message from smartd is: $SMARTD_MESSAGE"
            # ''}
            {
              Type = "oneshot";
              # TODO should be
              ExecStart = "${cfg.package}/bin/mujmap -C ${config.accounts.email.maildirBasePath}/fastmail sync ${lib.concatStringsSep " " mujmapOptions}";
            };

        }
      ) config.accounts.email.accounts;

      # check all accounts
      systemd.user.timers = lib.mapAttrs' (
        name: account:
        let
          timerName = mkMujmapServiceName name;
        in
        lib.nameValuePair timerName {
          Unit = {
            Description = "mujmap mailbox synchronization";
          };

          Timer = {
            OnCalendar = cfg.frequency;
            Unit = "${timerName}.service";
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };
        }
      ) config.accounts.email.accounts;
    };
}
