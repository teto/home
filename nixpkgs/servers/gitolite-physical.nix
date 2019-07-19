
let
  # hercules-ci-agent =
  #     builtins.fetchTarball "https://github.com/hercules-ci/hercules-ci-agent/archive/stable.tar.gz";

  secrets = import ../secrets.nix;
  nixos-remote = { config, pkgs, ... }:
  {
    deployment.targetHost = (builtins.head secrets.gitolite_server.interfaces.ipv4.addresses).address;
    # deployment.targetHost = builtins.head secrets.gitolite_server.hostname;
    deployment.targetEnv = "none";

    # deployment.keys.my-secret.text = builtins.readFile ./secret-mptcp;
    # deployment.keys.my-secret.user = "teto";
    # deployment.keys.my-secret.group = "wheel";
    # deployment.keys.my-secret.permissions = "0640";
  };
in
{
  network.description = "Generate MPTCP pcap";
  gitolite-server = nixos-remote;
}
