{
  flakeSelf,
  pkgs,
  lib,
  withSecrets,
  secretsFolder,
  ...
}:

let
  inherit (pkgs.tetoLib) ignoreBroken;
in
{
  imports = [

    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.sway-notification-center
    flakeSelf.homeProfiles.developer
    flakeSelf.homeProfiles.mpv
    flakeSelf.homeProfiles.vscode
    # flakeSelf.homeProfiles.waybar # breaks eval ?!

      flakeSelf.homeModules.fzf
      flakeSelf.homeModules.teto-zsh
      flakeSelf.homeModules.yazi
      flakeSelf.homeModules.services-mujmap
      flakeSelf.homeModules.pimsync
      flakeSelf.homeModules.package-sets

    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.teto-zsh
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.services-mujmap
    flakeSelf.homeModules.pimsync
    flakeSelf.homeModules.package-sets
    # ./programs/gpg.nix
  ]
  ++ lib.optionals (withSecrets) [
    flakeSelf.homeProfiles.nova
  ];

  # doing so enables support for it in greetd
  # services.gnome.gnome-keyring.enable = true;

  # TODO restore this
  # # generate an addressbook that can be used later
  # home.file."bin-nix/generate-addressbook".text = ''
  #   #!/bin/sh
  #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  # '';

  home.packages = with pkgs; [
    (ignoreBroken pkgs.aider-chat) # breaks
    mujmap-unstable
    notmuch # needed for waybar-custom-notmuch.sh
    panvimdoc # to generate vim doc from README, for instance in gp.nvim
    # poppler for pdf preview

    (pkgs.tetoLib.ignoreBroken mdcat) # markdown viewer

  ];

  package-sets = {

    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    enableIMPackages = true;
    jujutsu = true;
    yubikey = true;
    waylandPackages = true;
  };

  home.language = {
    # monetary =
    # measurement =
    # numeric =
    # paper =
    base = "fr_FR.utf8";
    time = "fr_FR.utf8";
  };

}
