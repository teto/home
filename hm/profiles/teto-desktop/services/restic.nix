{ config, pkgs, ... }:
{
  enable = true;
  backups = {
    nextcloud = {
      extraOptions = [
        # "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
      ];
      # todo retreive path from sops-nix module
      #
      passwordFile = "~/.config/sops-nix/secrets/b2-restic-password";
      paths = [
        "${config.home.homeDirectory}/Nextcloud"
      ];
      #
      repositoryFile = "/toto";
      #
      # repository = "sftp:backup@host:/backups/home";
      # timerConfig = {
      #   OnCalendar = "00:05";
      #   RandomizedDelaySec = "5h";
      # };
    };

    # localbackup = {
    #   exclude = [
    #     "/home/*/.cache"
    #   ];
    #   initialize = true;
    #   passwordFile = "/etc/nixos/secrets/restic-password";
    #   paths = [
    #     "/home"
    #   ];
    #   repository = "/mnt/backup-hdd";
    # };
    # remotebackup = {
    #   extraOptions = [
    #     "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
    #   ];
    #   passwordFile = "/etc/nixos/secrets/restic-password";
    #   paths = [
    #     "/home"
    #   ];
    #   repository = "sftp:backup@host:/backups/home";
    #   timerConfig = {
    #     OnCalendar = "00:05";
    #     RandomizedDelaySec = "5h";
    #   };
    # };
  };
}
