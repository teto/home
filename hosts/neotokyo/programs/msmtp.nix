{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.msmtp = {
    enable = true;
    accounts = 
      {
        default = {
          auth = true;
          host = "smtp.example";
          # not sure I need a password here ? sops.secrets
          passwordeval = "cat /secrets/password.txt";
          user = "someone";
        };
      };

  };
}
