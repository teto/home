{ config, pkgs, lib,  ... }:

{
  systemd.user.services.vdirsyncer = {
    Unit = {
      After = [ "network.target" ];
      Description = "Vdirsyncer Daemon";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      Type = "notify";
      # ExecStartPre = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${cfg.dataDir}' '${cfg.playlistDirectory}'"'';
    };
  };
}
