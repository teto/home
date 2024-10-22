{
  config,
  lib,
  pkgs,
  flakeInputs,
  ...
}:
{

  xdg.configFile."yazi/plugins/ouch.yazi".source = flakeInputs.ouch-yazi-plugin;

  xdg.configFile."yazi/plugins/rsync.yazi".source = flakeInputs.rsync-yazi-plugin;

  # xdg.configFile."yazi/plugins/rsync.yazi".source = flakeInputs.rsync-yazi-plugin;

  # 7z
  home.packages = [

    pkgs._7zz # required for the ouch plugin
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = flakeInputs.yazi.packages.${pkgs.system}.yazi;
  };
}
