{ pkgs, ... }:
{

  imports = [
    # flakeSelf.nixosProfiles.docling-serve
  ];

  environment.systemPackages = [
    pkgs.mariadb-ai-plugins
  ];

  # temporary hack
  networking.extraHosts = ''
    192.168.6.184 p7
    '';


    # invalid documentation value: vim.NIL
    services.mysql  = {
      enable = true;
      package = pkgs.mariadb;
    };

}
