{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:
{

  accounts.contact = {
    # XDG_DATA instead ?
    basePath = ".contacts";

    # basePath = ".contacts";
    accounts = {

      fastmail = {
        khard = {
          enable = true;
        };

        # pimsync.enable = false;
      };
    };
  };
}
