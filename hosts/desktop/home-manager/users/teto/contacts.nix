{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:

# let
#   tetoLib = pkgs.callPackage ../../../hm/lib.nix { };
# in
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
