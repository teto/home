
let
  secrets = import ../secrets.nix;
  nixos-remote = { config, pkgs, ... }:
  {
    deployment.targetHost = (builtins.head secrets.gitolite_server.ipv4.addresses).address;
    deployment.targetEnv = "none";
  };
in
{
  network.description = "Generate MPTCP pcap";
  gitolite-server = nixos-remote;
}
