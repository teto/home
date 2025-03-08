{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  xdg.configFile."yazi/plugins/ouch.yazi".source = flakeSelf.inputs.ouch-yazi-plugin;

  xdg.configFile."yazi/plugins/rsync.yazi".source = flakeSelf.inputs.rsync-yazi-plugin;

  # xdg.configFile."yazi/plugins/rsync.yazi".source = flakeSelf.inputs.rsync-yazi-plugin;

  # 7z
  home.packages = [

    pkgs._7zz # required for the ouch plugin
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = flakeSelf.inputs.yazi.packages.${pkgs.system}.yazi;
  };
}
