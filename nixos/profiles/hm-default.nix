{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  secrets,
  dotfilesPath,
  secretsFolder,
  ...
}:
{
  home-manager.verbose = true;
  # install through the use of user.users.USER.packages
  home-manager.useUserPackages = true;
  # disables the Home Manager option nixpkgs.*
  home-manager.useGlobalPkgs = true;

  # from PR https://github.com/nix-community/home-manager/pull/6981
  # home-manager.useUserService = true;

  # shall we import all modules ?
  home-manager.sharedModules = [
    # deleted the input ? useless ?
    # flakeSelf.inputs.wayland-pipewire-idle-inhibit.homeModules.default
    flakeSelf.inputs.sops-nix.homeManagerModules.sops

    flakeSelf.homeProfiles.readline
    flakeSelf.homeProfiles.fzf
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    # flakeSelf.homeProfiles.neovim # takes too much space for router

    # TODO it should autoload all of them ?
    flakeSelf.homeModules.bash
    flakeSelf.homeModules.fish
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.nvimpager
    flakeSelf.homeModules.neovim
    flakeSelf.homeModules.package-sets
    flakeSelf.homeModules.yazi

    (
      # { ... }:
      {
        # to avoid warnings about incompatible stateVersions
        home.enableNixpkgsReleaseCheck = false;
      })
  ];
  home-manager.extraSpecialArgs = {
    secrets = lib.optionalAttrs withSecrets secrets;
    inherit
      # TODO use nixosConfig version ?
      withSecrets
      flakeSelf
      dotfilesPath
      secretsFolder
      ;
    inherit lib;
    # https://github.com/nix-community/home-manager/issues/5980
  };

}
