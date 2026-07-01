{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
let
  cfg = config.services.nixpkgs-monitor;
  defaultNotifier = pkgs.writeShellScript "notify-advancement" ''
    title="hello";
    message="nixpkgs advanced";
    notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
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
          default = defaultNotifier; 
          description = ''
            Script to run in case of success
          '';
      };
    };
  };
  config = lib.mkIf cfg.enable {

    # TODO conditionnally define it
    # lib.mkIf config.mujmap-fastmail.enable
    # TODO try an equivalent with mail
    systemd.user.services = {
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
  };
}
