{ config, pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
in
{
  # enable gitolite
  services.gitolite = {
    enable = true;
    adminPubkey = secrets.gitolitePublicKey ;
    # by default /var/lib/gitolite
    # dataDir = /home/teto/gitolite;
  };
}
