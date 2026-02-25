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
    # remote broken
    flakeSelf.inputs.wayland-pipewire-idle-inhibit.homeModules.default
    flakeSelf.inputs.sops-nix.homeManagerModules.sops

    flakeSelf.homeProfiles.fzf
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    # flakeSelf.homeProfiles.neovim # takes too much space for router

    # TODO it should autoload those
    flakeSelf.homeModules.nvimpager
    flakeSelf.homeModules.bash
    flakeSelf.homeModules.memento
    flakeSelf.homeModules.kitty
    flakeSelf.homeModules.zsh
    flakeSelf.homeModules.fre
    # flakeSelf.homeModules.cliphist
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.neovim
    flakeSelf.homeModules.pimsync
    flakeSelf.homeModules.package-sets
    flakeSelf.homeModules.tig
    flakeSelf.homeModules.yazi

    (
      { ... }:
      {
        home.stateVersion = "25.11";

        # to avoid warnings about incompatible stateVersions
        home.enableNixpkgsReleaseCheck = false;
      }
    )
  ];
  home-manager.extraSpecialArgs = {
    secrets = lib.optionalAttrs withSecrets secrets;
    inherit
      withSecrets
      flakeSelf
      dotfilesPath
      secretsFolder
      ;
    inherit lib;
    # https://github.com/nix-community/home-manager/issues/5980

    # lib = lib.extend (_: _: flakeSelf.inputs.hm.lib // builtins.trace "${lib.neovim.toto}" lib);
  };

  # home-manager.users = {
  #   teto = {
  #     imports = [
  #     ];
  #   };
  # };
}
