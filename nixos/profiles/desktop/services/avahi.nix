{ config, pkgs, lib, ... }:
{
  # inspired by novos
    enable = true;
    ipv6 = false; # bug with multiple hostnames
    # allows applications to resolve names in the ‘.local’ domain by transparently querying the Avahi daemon.
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      workstation = true;
      domain = true;
      addresses = true;
      hinfo = true; # just to test: expose hardware info
      userServices = true;
      # userServices
    };

    extraServiceFiles = {
      # correct port ?
      # ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";

      # TODO generate a port per service
      ssh = ''<service-group>

  <name replace-wildcards="yes">%h</name>

  <service>
    <type>_ssh._tcp</type>
    <port>${toString( builtins.head config.services.openssh.ports)}</port>
  </service>

</service-group>
'';

      # include only if enabled
      # must be a string

      # ssh = builtins.toXML {
      #   type = "service";
      #   id = "SSH";
      #   # hostname = "localhost.localdomain";
      #   domainName = "local";
      #   serviceType = "_ssh._tcp";
      #   portNumbers = 
      #     config.services.openssh.ports
      #   ;
      #   user = "teto";
      # };

      # smb = ''
      #   <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
      #   <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      #   <service-group>
      #     <name replace-wildcards="yes">%h</name>
      #     <service>
      #       <type>_smb._tcp</type>
      #       <port>445</port>
      #     </service>
      #   </service-group>
      # '';
    };
    browseDomains =  [
      # "0pointer.de"
      "zeroconf.org"
    ];
}
