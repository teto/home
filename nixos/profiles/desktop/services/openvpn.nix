{
  pkgs,
  secrets,
  lib,
  withSecrets,
  secretsFolder,
  ...
}:
let
  # pushes the VPN's DNS servers/domains to systemd-resolved, scoped to the tun link
  updateResolved = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
in
lib.optionalAttrs withSecrets {
  # Each attribute of this option defines a systemd service that runs an OpenVPN instance.
  # The service is named ‘openvpn-«name».service’.
  servers = {

    # WatchGuard SSLVPN, formerly the NetworkManager "ixeal-vpn" profile.
    # Start with `sudo systemctl start openvpn-ixeal`: the password is asked via
    # systemd-ask-password since the credentials file only contains the username.
    ixeal =
      let
        certDir = "/home/teto/Nextcloud/ixeal/Mobile VPN";
      in
      {
        autoStart = false;

        # TODO add pull_filter
        # • For the desktop OpenVPN setup, the announcement comes from update-systemd-resolved: the VPN’s up script adds its DNS servers and domains to systemd-resolved for the tunnel interface
        #   (openvpn.nix (nixos/profiles/desktop/services/openvpn.nix:8)). To ignore specific pushed settings, add OpenVPN pull-filter ignore rules inside the config block. For example:
        #
        #   pull-filter ignore "dhcp-option DNS"
        #   pull-filter ignore "dhcp-option DOMAIN"
        #   pull-filter ignore "dhcp-option DOMAIN-SEARCH"
          # mssfix 1400 mtu
          # max-mss headers         float
        config = ''
          client
          dev tun
          # tcp-client
          proto udp
          remote ${secrets.accounts.ixeal.vpnHostNew} 443
          nobind
          persist-key
          persist-tun

          ca "${certDir}/ca.crt"
          cert "${certDir}/client.crt"
          key "${certDir}/client.pem"
          verify-x509-name "O=WatchGuard_Technologies, OU=Fireware, CN=Fireware SSLVPN Server" subject
          tls-version-min 1.2
          data-ciphers AES-256-GCM
          auth-nocache
          ping 10
          ping-restart 60
          reneg-sec 28800
          pull-filter ignore "dhcp-option DNS 192.168.1.61"
          pull-filter ignore "route 192.168.1.0"
          # run update-systemd-resolved before the tun device goes away
          down-pre
        '';
        # username only => openvpn prompts for the password
        # You can either provide an attribute set of ‘username’ and ‘password’, or the path to a file containing the credentials on two lines.
        # authUserPass = "${pkgs.writeText "openvpn-ixeal-username" secrets.accounts.ixeal.vpnUsername}";
        authUserPass = "${secretsFolder}/ixeal-auth-user-path.txt";
        up = updateResolved;
        down = updateResolved;
      };
  };
}
