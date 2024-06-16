let
  secrets = import ../secrets.nix;
  nixos-remote =
    { config, pkgs, ... }:
    {
      deployment.targetHost = (builtins.head secrets.mptcp_server.interfaces.ipv4.addresses).address;
      deployment.targetEnv = "none";

      # without this, it seems 
      deployment.keys.my-secret.text = builtins.readFile ./secret-mptcp;
      deployment.keys.my-secret.user = "teto";
      deployment.keys.my-secret.group = "wheel";
      deployment.keys.my-secret.permissions = "0640";
    };
in
{
  network.description = "Remote builder ";
  mptcp-server = nixos-remote;
}
