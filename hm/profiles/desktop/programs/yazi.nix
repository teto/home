{ pkgs, ... }:
{
  # _imports = [
  #   homeProfiles.yazi
  # ];

  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  # package = flakeSelf.inputs.yazi.packages.${pkgs.system}.yazi;

  # NOTE that these can be installed imperatively via 
  # ya pack -a GianniBYoung/rsync for instance
  plugins = {
    # foo = ./foo;
    ouch = pkgs.yaziPlugins.ouch;
    # TODO package flakeSelf.inputs.rsync-yazi-plugin;
    rsync = pkgs.rsync-yazi; # packaged by myself
    # rsync-packaged = pkgs.mkYaziPlugin {
    #
    # };
  };
}
