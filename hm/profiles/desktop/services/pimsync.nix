{
  pkgs,
  lib,
  flakeSelf,
  config,
  ...
}:
{

  # _imports = [
  #   ({ config, ...}: {
  #     systemd.user.services.pimsync.Service = lib.mkIf config.programs.pimsync.enable {
  #       Environment = [
  #         "PATH=$PATH:${
  #           pkgs.lib.makeBinPath [
  #             pkgs.pass-teto
  #             pkgs.bash
  #           ]
  #         }"
  #       ];
  #     })
  #
  #
  # ];

  enable = true;

  # package = pkgs.pimsync-dev;

}
