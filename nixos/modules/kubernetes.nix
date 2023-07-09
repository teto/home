{ config, pkgs, ... }:
# see https://nixos.org/nixos/manual/index.html#sec-kubernetes
let
  kubeMasterIP = "10.0.0.1";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 443;
in
{
  # resolve master hostname
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = [ "master" "node" ];
    masterAddress = kubeMasterHostname;
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dashboard = {
      enable = true;
      rbac.enable = true;
    };

    # apiserver.enable = true;

    # use coredns
    # addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
