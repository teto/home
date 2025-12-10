{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
let
  welcomeMessage = ''
    Welcome to neotokyo, dear master.

    A few tips:
    - `journalctl -b0 -r` to see what's up lately
    - just help
  '';
    # - sudo systemctl start redis-nextcloud.service
    # - sudo systemctl status phppfm.service
    # - sudo systemctl start nextcloud-add-user to create the teto user
    # - everything is in /var/lib/nextcloud
    # - to check the backups: systemctl status restic-backups-immich-db-to-backblaze.service
  # TODO add a justfile to run the basic steps
  banner = "You can start the nextcloud-add-user.service unit if teto user doesnt exist yet";
in
{
  programs.bash.shellAliases = {

  };
  programs.bash.initExtra = ''
    cat "${pkgs.writeText "welcome-message" banner}";
  '';

  imports = [
    flakeSelf.homeProfiles.bash
    flakeSelf.homeModules.yazi
  ];

  programs.zsh = {
    enable = true;
    loginExtra = ''
      cat "${pkgs.writeText "login-welcome" welcomeMessage}";
    '';
    shellAliases = {
      st = "systemctl-tui";
      jctl = "journalctl -b0";

    };
  };

  home.file."justfile".source =  ./justfile;
}
