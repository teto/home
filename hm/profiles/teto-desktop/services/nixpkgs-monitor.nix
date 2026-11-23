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
    "${pkgs.notify-nixpkgs-advancement} ${secrets.users.teto.email} ${secrets.users.teto.email}"
  );
}
