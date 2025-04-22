{
  flakeSelf,
  pkgs,
  lib,
  withSecrets,
  secretsFolder,
  ...
}:
{

  imports =
    [

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
    ]
    ++ lib.optionals (lib.debug.traceVal withSecrets) [
      flakeSelf.homeProfiles.nova
    ];

  # TODO restore this
  # # generate an addressbook that can be used later
  # home.file."bin-nix/generate-addressbook".text = ''
  #   #!/bin/sh
  #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  # '';

  home.packages = with pkgs; [
    pkgs.aider-chat # breaks
    bluetuith # Bluetooth TUI

    isync # not used ?
    mujmap-unstable
    notmuch # needed for waybar-custom-notmuch.sh

    panvimdoc # to generate vim doc from README, for instance in gp.nvim
    unar # used to view archives by yazi
    # poppler for pdf preview
    memento # capable to display 2 subtitles at same time

    pkgs.trurl # used to parse url in the firefox-router executable
    viu # a console image viewer
    mdcat # markdown viewer

  ];

  package-sets = {

    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    enableIMPackages = true;
    jujutsu = true;
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
