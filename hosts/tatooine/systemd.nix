{ pkgs, ... }:
{
  # user.services.pipewire.environment = {
  # PIPEWIRE_DEBUG = "5";
  # };

  # systemd.user.services.wireplumber.environment = {
  #     WIREPLUMBER_DEBUG="5";
  #   };

  # see https://github.com/NixOS/nixpkgs/issues/562661
  services.alsa-init = {
    description = "Initialize ALSA sound cards and UCM";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      SuccessExitStatus = [
        0
        99
      ];
      ExecStart = "${pkgs.alsa-utils}/bin/alsactl init";
    };
  };

  # when needed to run DHCP server for PXE / with pixiecore
  # network.networks."20-enp1s0f0-pixiecore" = {
  #   matchConfig.Name = "enp1s0f0";
  #   address = [ "10.42.0.1/24" ];
  #   networkConfig.DHCPServer = true;
  #   dhcpServerConfig = {
  #     PoolOffset = 100;
  #     PoolSize = 100;
  #   };
  # };

    # networks =
      # lib.optionalAttrs withSecrets {
      #   "10-disable-wlan1" = {
      #     matchConfig.PermanentMACAddress = "${secrets.jedha.mediatekMacAddress}";
      #     linkConfig.ActivationPolicy = "always-down";
      #   };
      # }
      # //
      #
      # {
      #   "50-wg0" = {
      #     matchConfig.Name = "wg0";
      #     networkConfig.MulticastDNS = false;
      #   };
}
