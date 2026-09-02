{
  pkgs,
  secrets,
  lib,
  osConfig,
  ...
}:
{
  # runs on vps now
  enable = false;
  on-branch-advance-cmd = lib.optionalDrvAttr osConfig.tetos.withSecrets (
    lib.nixpkgsMonitorEmailNotifier secrets.users.teto.email secrets.users.teto.email
  );
}
