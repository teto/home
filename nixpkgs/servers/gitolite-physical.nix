
let
  secrets = import ../secrets.nix;
  nixos-remote = { config, pkgs, ... }:
  {
    deployment.targetHost = secrets.gitolite_server.ip4.address;
    deployment.targetEnv = "none";
  };
in
{
  network.description = "Generate MPTCP pcap";
  gitolite-server = nixos-remote;
}
