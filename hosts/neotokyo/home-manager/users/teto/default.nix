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
    - just help
    - tremc
    ${banner}
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

  # only on login shell
  # initExtra => interactive shell
  # profileExtra => login shell
  # programs.bash.initExtra = ''
  #   cat "${pkgs.writeText "welcome-message" banner}";
  # '';

  programs.msmtp.enable = true;

  imports = [
    flakeSelf.homeModules.teto-nogui
    flakeSelf.homeProfiles.bash
    flakeSelf.homeProfiles.teto-aliases
    flakeSelf.homeProfiles.yt-dlp
  ];

  programs.yt-dlp.enable = true;

  programs.neovim = {

    enableFzfLua = true;
    highlightOnYank = true;
    enableMyDefaults = true;
  };

  # todo set zsh as default
  programs.zsh = {
    enable = true;
    loginExtra = ''
      cat "${pkgs.writeText "login-welcome" welcomeMessage}";
    '';
    # shellAliases = {
    #   st = "systemctl-tui";
    #   jctl = "journalctl -b0";
    # };
  };

  home.file."justfile".source = ./justfile;
}
