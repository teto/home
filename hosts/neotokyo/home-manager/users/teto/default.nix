{
  config,
  lib,
  pkgs,
  flakeSelf,
  secrets,
  withSecrets,
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
  imports = [
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.bash
    flakeSelf.homeProfiles.teto-aliases
    flakeSelf.homeProfiles.readline
    flakeSelf.homeModules.nixpkgs-monitor

    flakeSelf.homeProfiles.yazi
    flakeSelf.homeProfiles.yt-dlp
  ];

  home.packages = [
    pkgs.just # to run justfile
    pkgs.nix-diff
  ];

  home.stateVersion = "26.05";

  # move to teto
  services.nixpkgs-monitor =
    let
      parts = lib.splitString "@" secrets.users.teto.email;
      user = builtins.elemAt parts 0;
      domain = builtins.elemAt parts 1;
    in
    {
      enable = true;
      # TODO send a mail
      on-branch-advance-cmd = lib.optionalDrvAttr withSecrets (
        lib.nixpkgsMonitorEmailNotifier "${user}+neotokyo@${domain}" secrets.users.teto.email
      );
      monitorCommand = "${lib.getExe pkgs.git-branch-monitor}";
    };

  # only on login shell
  # initExtra => interactive shell
  # profileExtra => login shell
  # programs.bash.initExtra = ''
  #   cat "${pkgs.writeText "welcome-message" banner}";
  # '';

  # required for systemd to send emails
  programs.msmtp.enable = true;

  programs.yt-dlp.enable = true;

  programs.neovim = {
    enableFzfLua = true;
    highlightOnYank = true;
    enableMyDefaults = true;
  };

  programs.bash = {
    #       export GITHUB_TOKEN=$(cat ~/github-token)
    initExtra = ''
      cd nixpkgs
      echo "exporting token..."
    '';
    profileExtra = ''
      cat "${pkgs.writeText "login-welcome" welcomeMessage}";
    '';

  };

  # to export XDG_CACHE_HOME
  xdg.enable = true;

  # TODO set default ?
  programs.fish.enable = true;

  # todo set zsh as default
  # programs.zsh = {
  #   enable = true;
  #   loginExtra = ''
  #     cat "${pkgs.writeText "login-welcome" welcomeMessage}";
  #   '';
  #   # shellAliases = {
  #   #   st = "systemctl-tui";
  #   #   jctl = "journalctl -b0";
  #   # };
  # };

  home.file."justfile".source = ./justfile;
}
