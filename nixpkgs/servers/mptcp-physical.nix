
let
  secrets = import ../secrets.nix;
  nixos-remote = { config, pkgs, ... }:
  {
    
    deployment.targetHost = (builtins.head secrets.mptcp_server.ipv4.addresses).address;
    deployment.targetEnv = "none";

    # without this, it seems 
    deployment.keys.my-secret.text = "shhh this is a secret";
    deployment.keys.my-secret.user = "myuser";
    deployment.keys.my-secret.group = "wheel";
    deployment.keys.my-secret.permissions = "0640";
  };
in
{
  network.description = "Remote builder ";
  mptcp-server = nixos-remote;
}
