{ config, lib, pkgs, ... }:
{
  
  services.linkwarden = {

    enable = true;
    # secretFiles.NEXTAUTH_SECRET = ;
  };

}
