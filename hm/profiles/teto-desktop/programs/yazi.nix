{
  flakeSelf,
  pkgs,
  lib,
  # , secretsFolder
  ...
}:
let

  # breaks eval
  # serverConfigs = lib.mapAttrsToList (
  #   _: nixosCfg: lib.optionalAttrs nixosCfg.config.services.openssh.enable (genYaziVFSServer nixosCfg)
  # ) flakeSelf.nixosConfigurations;

in
{
  _imports = [
    flakeSelf.homeProfiles.yazi
    # {
    #
    #   # https://yazi-rs.github.io/docs/configuration/vfs
    #   xdg.configFile."yazi/vfs-generated.toml".text = lib.concatStringsSep "\n" serverConfigs;
    # }
  ];

  enable = true;
  package = flakeSelf.inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
  # shellWrapperName = "y";

  # NOTE that these can be installed imperatively via
  # ya pack -a GianniBYoung/rsync for instance
  plugins = {
    # foo = ./foo;
    # ouch = pkgs.yaziPlugins.ouch;
    # TODO package flakeSelf.inputs.rsync-yazi-plugin;
    # rsync = pkgs.rsync-yazi; # packaged by myself
    mediainfo = pkgs.yaziPlugins.mediainfo;

    # rsync-packaged = pkgs.mkYaziPlugin {
    #
    # };
  };
}
