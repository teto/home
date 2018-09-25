
let
  secrets = import ../secrets.nix;
  nixos-remote = { config, pkgs, ... }:
  {
    
    deployment.targetHost = (builtins.head secrets.mptcp_server.ipv4.addresses).address;
    deployment.targetEnv = "none";
  };
in
{
  network.description = "Remote builder ";
  mptcp-server = nixos-remote;
}
