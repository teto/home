{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
let
  cfg = config.services.nixpkgs-monitor;

  localNotifier = pkgs.writeShellScript "notify-advancement" ''
    set -ue

    message="nixpkgs advanced";
    branch_name="$1"
    old_revision="$2"
    new_revision="$3"
    timestamp="$4"

    title="$branch_name advanced";

    message=<<<EOF
      New revision: $new_revision
      Previous revision: $old_revision

      Timestamp: $timestamp
    EOF

    notify-send --expire-time=0 -a "" "$title" "$message"
  '';

in
{
  options = {
    services.nixpkgs-monitor = {
      enable = lib.mkEnableOption "nixpkgs-monitor";

      # trackedBranch = "";
      # lib.mkPackageOption pkgs "name" {
      on-branch-advance-cmd = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = localNotifier;
        description = ''
          Script to run in case of success
        '';
      };

    };
  };
  config = lib.mkIf cfg.enable {

    systemd.user = {
      services = {
        monitor-git-branch = {
          Unit = {
            Description = "Monitor nixos-unstable channel advancement";
          };

          Service = {
            Type = "oneshot";
            Environment = [
              "PATH=${
                lib.makeBinPath [
                  pkgs.coreutils
                  pkgs.curl
                  pkgs.gawk
                  pkgs.libnotify
                  pkgs.git
                  pkgs.fish # for shebang
                ]
              }"
            ];
            # wont work when deploying to neoktokyo
            # pass as arg a script to notify user on new nixpkgs
            # notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
            ExecStart =
              let
                # onSuccessScript = pkgs.writeScript
              in
              "${dotfilesPath}/bin/monitor-git-branch.fish -b nixos-unstable"
              + lib.optionalString (cfg.on-branch-advance-cmd != null) " --command ${cfg.on-branch-advance-cmd}";
          };
        };

      };
      timers = {
        monitor-git-branch = {
          Unit.Description = "Monitor nixos-unstable advancements";
          Timer = {
            OnCalendar = "*:0/30";
            Persistent = true;
          };
          Install.WantedBy = [ "timers.target" ];
        };

      };
    };
  };
}
