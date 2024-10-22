{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mujmap = {
    enable = true;
    package = pkgs.mujmap-unstable;
  };
  # export PASSWORD_STORE_DIR="$TETO_SECRETS_FOLDER/password-store"

}
