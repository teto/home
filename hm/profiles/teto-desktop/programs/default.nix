{
  bat.enable = true;

  # TODO add config
  helix.enable = true;

  tig.enable = true;
  nvimpager.enable = false; # too slow
  # fre = {
  #   enable = false;
  #   enableAsFzfFile = true;
  # };

  # GUI to manage keyrings
  # seahorse.enable = true;

  # always broken
  # rbw = {
  #   enable = withSecrets;
  #   settings = {
  #     email = config.accounts.email.accounts.fastmail.address;
  #     lock_timeout = 300;
  #     # pinentry = pkgs.pinentry-gnome3;
  #     pinentry = pkgs.pinentry-rofi;
  #     # see https://github.com/nix-community/home-manager/issues/2476
  #     device_id = secrets.bitwarden.device-id;
  #   };
  # };

}
