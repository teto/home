{ config, lib, pkgs,  ... }:
{
  nix = {
    package = pkgs.nixUnstable;

    # sshServe = {
    #   enable = true;
    #   protocol = "ssh";
    #   # keys = [ secrets.gitolitePublicKey ];
    # };

    # added to nix.conf
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    distributedBuilds = false;
  };
}
