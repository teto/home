{ config, lib, pkgs, ... }:
let
  welcomeMessage = ''
    Welcome to the novadiscovery CI/CD runner dear devops.

    A few tips:
    - `journalctl -b0 -r` to see what's up lately
    - sudo systemctl start redis-nextcloud.service
    - sudo systemctl status phppfm.service
    - sudo systemctl start nextcloud-add-user to create the teto user
    - everything is in /var/lib/nextcloud
  '';
  in
{
 
 programs.zsh.loginExtra = ''
  cat "${pkgs.writeText "login-welcome" welcomeMessage}";
  '';

  home.packages = [
   pkgs.yazi
  ];
}
