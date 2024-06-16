{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = true;

  # todo add nova registry ?
  registries.search = [
    "docker.io"
    "quay.io"
  ];

}
