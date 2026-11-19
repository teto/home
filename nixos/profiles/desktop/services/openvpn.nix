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
        config = ''
          client
          dev tun
          proto tcp-client
          remote ${secrets.accounts.ixeal.vpnHost1} 443
          nobind
          float
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
