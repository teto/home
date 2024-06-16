{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = true;
  # enableNvidia = true;

  # # podman-related changes
  # # reproducing virtualisation.containers in container :o
  # mkdir -p /etc/containers
  # cp "${pkgs.skopeo.policy}/default-policy.json" /etc/containers/policy.json
  # cp ${containerRegistryConf} /etc/containers/registries.conf
}
