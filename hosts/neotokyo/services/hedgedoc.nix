# doc at
# - https://wiki.nixos.org/wiki/Hedgedoc
# - https://discourse.nixos.org/t/does-anyone-know-how-to-configure-hedgedoc/33513/4
{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  hedgedocDomain = "hedgedoc.${secrets.jakku.hostname}";
in
{

  services.hedgedoc = {
    enable = false;
    configureNginx = true;

    settings = {
      domain = hedgedocDomain;

      # protocolUseSSL = true;
      # uploadsPath =
      allowOrigin = [
        "localhost"
        hedgedocDomain
        # "hedgedoc.${secrets.jakku.hostname}"
      ];
    };
  };
  #
  # services.nginx.virtualHosts."${hedgedocDomain}" = lib.mkIf config.services.hedgedoc.enable {
  #
  # };

}
