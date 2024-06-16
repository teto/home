# The website can't actually be run automatically (yet) since nixpkgs lacks some lua modules (lapis)
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.luarocks-site;
in
# wireshark = cfg.package;
{
  options = {
    services.luarocks-site = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run an equivalent of www.luarocks.org website
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ wireshark ];
    # users.groups.wireshark = {};
    # TODO enable postgresql / redis /  nginx
    services.nginx.virtualHosts."luarocks-site" = {
      enable = true;
      enableReload = true;
      # appendConfig = "";
      # appendHttpConfig = "";
      # services.nginx.additionalModules
      # Additional third-party nginx modules[1] to install. Packaged modules are available in ‘pkgs.nginxModules’.
      # Example: [ pkgs.nginxModules.echo ]
    };

  };
}
