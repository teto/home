{ pkgs, lib, inputs, config
, secrets
, ... }:

let
  n1 = pkgs.writeText "chimera-iot.psk" ''
    [Settings]
    AutoConnect=true
    [Security]
    Passphrase=${secrets.router.password}
  '';
in
{
  # config = {
    # sops.secrets = {
    #   "iwd_neotokyo.psk" = {
    #     # https://github.com/Mic92/sops-nix?tab=readme-ov-file#binary
    #     sopsFile = ./iwd_neotokyo.psk;
    #     format = "binary";
    #   };
    # };

    systemd.tmpfiles.rules = [
      # "C /var/lib/iwd/chimera-iot.psk 0400 root root - /run/secrets/iwd_network_chimera-iot.psk"
      "C /var/lib/iwd/neotokyo.psk 0600 root root - ${n1}"
      # "C /var/lib/iwd/neotokyo.psk 0600 root root - ${config.sops.secrets."iwd_neotokyo.psk".path}"
    ];
  # };
}
