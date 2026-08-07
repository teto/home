# { config, lib, ... }:
{
  hostName = "jedha";
  domain = "jedha.local"; # Define your hostname.

  wireless = {
    scanOnLowSignal = false; # consume less energy and we dont roam anyway
  };

  networkmanager = {
    enable = true;

    unmanaged = [
      # we prefer to configure it with networkd
      "interface-name:enp11s0"
      #   "interface-name:r?-*"
    ];
    wifi = {
      backend = "iwd";
      # accept null/false/true
      # with `powersave` enabled, the link gets into DORMANT mode and then it becomes impossible to wake it up
      powersave = false;
    };

    # just documented to remember syntax
    # ensureProfiles = {
    #   environmentFiles = [ "/home/joe/.wifi" ];
    #
    #   # Note the network will be called `REDACTED` in your UIs, but that
    #   # does not have to be the same as the SSID
    #   profiles."REDACTED" = {
    #     connection = {
    #       id = "REDACTED";
    #       type = "wifi";
    #       autoconnect = true;
    #     };
    #   };
    # };
  };

  useNetworkd = true;

  hosts = {
    # a test, better would be to have nginx recognize another thing
    "10.100.0.1" = [ "neotokyo.local" ];
  };

  # hosts = [];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  resolvconf.dnsExtensionMechanism = false;
  resolvconf.dnsSingleRequest = false;

  # osConfig.config.networking.firewall = lib.mkIf cfg.openFirewall {
  #   allowedTCPPorts = [ cfg.port ];
  # };

  interfaces.enp11s0 = {
    #wakeOnLan.policy
    wakeOnLan.enable = true;
  };

  # .ipv4 = {
  #   addresses = [
  #                {
  #                  # apipa system
  #                  address = "169.254.1.10";
  #                  prefixLength = 16;
  #                  # metric = "800";
  #                }

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

  # 192.168.1.254
  # defaultGateway = {
  #   address = "131.211.84.1";
  #   interface = "enp3s0";
  #   source = "131.211.84.2";
  # };

  # mostly to add blocklsit
  # hostFiles
}
