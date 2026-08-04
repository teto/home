{
  pkgs,
  secrets,
  lib,
  withSecrets,
  ...
}:
{
  enable = true;
  on-branch-advance-cmd = lib.optionalDrvAttr withSecrets (
    lib.nixpkgsMonitorEmailNotifier secrets.users.teto.email
  );
}
