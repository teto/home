{
  config,
  lib,
  pkgs,
  ...
}:
let
  welcomeMessage = ''
    Welcome to the router, dear master.

    A few tips:
    - `journalctl -b0 -r` to see what's up lately
    - sudo systemctl start redis-nextcloud.service
    - sudo systemctl status phppfm.service
    - sudo systemctl start nextcloud-add-user to create the teto user
    - everything is in /var/lib/nextcloud
  '';
in
{

  programs.zsh.enable = true;
  programs.zsh.loginExtra = ''
    cat "${pkgs.writeText "login-welcome" welcomeMessage}";
  '';

  home.packages = [ pkgs.yazi ];
}
