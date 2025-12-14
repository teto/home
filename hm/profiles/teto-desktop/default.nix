{
  flakeSelf,
  pkgs,
  lib,
  withSecrets,
  secretsFolder,
  dotfilesPath,
  ...
}:

let
  inherit (pkgs.tetosLib) ignoreBroken;
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

    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.teto-zsh
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.services-mujmap
    flakeSelf.homeModules.pimsync
    flakeSelf.homeModules.package-sets
  ];

  # TODO restore this
  # # generate an addressbook that can be used later
  # home.file."bin-nix/generate-addressbook".text = ''
  #   #!/bin/sh
  #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  # '';

  home.packages = with pkgs; [
    pass-perso
    (ignoreBroken pkgs.aider-chat) # breaks
    notmuch # needed for waybar-custom-notmuch.sh
    panvimdoc # to generate vim doc from README, for instance in gp.nvim
    # poppler for pdf preview

    viu # a console image viewer
    mdcat # markdown viewer

      # flakeSelf.inputs.git-repo-manager.packages.${pkgs.stdenv.hostPlatform.system}.git-repo-manager
  ];

  home.shellAliases = {
    lg = "lazygit";
    # trans aliases{{{
    fren = "trans -from fr -to en ";
    enfr = "trans -from en -to fr ";
    jpfr = "trans -from ja -to fr ";
    frjp = "trans -from fr -to ja ";
    jpen = "trans -from ja -to en ";
    enjp = "trans -from en -to ja ";
    # }}}
  };


  home.sessionVariables = {
    # might be a hack
    PASSWORD_STORE_ENABLE_EXTENSIONS="true";  # it must be "true" and nothing else !
    PASSWORD_STORE_EXTENSIONS_DIR="${dotfilesPath}/contrib/pass-extensions";
  };

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
