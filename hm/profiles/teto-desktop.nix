{
  config,
  flakeSelf,
  lib,
  dotfilesPath,
  secretsFolder,
  ...
}:
let

  haumea = flakeSelf.inputs.haumea;
  autoloadedModule =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = lib.fileset.toSource {
        root = ./teto-desktop;
        fileset = ./teto-desktop;
      };
      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{

  imports = [
    autoloadedModule
    ./common.nix
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.neovim
    flakeSelf.inputs.noctalia-shell.homeModules.default

  ];

  home.file.".password-store".source =
    config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/password-store-perso";
  # TODO link .config
  # home.file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/password-store-teto";
  # home.file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/gnupg";

  # allows to find fonts enabled through home.packages
  fonts.fontconfig.enable = true;

  # programs.delta.enable = true;

  # TODO remove ? dangerous
  home.sessionPath = lib.mkBefore [
    # "$XDG_DATA_HOME/../bin"
    "${dotfilesPath}/bin"
  ];


}
