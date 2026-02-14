{
  pkgs,
  flakeSelf,
  ...
}:
{

  # now installed via yazi.plugins
  # xdg.configFile."yazi/plugins/rsync.yazi".source = flakeSelf.inputs.rsync-yazi-plugin;

  # 7z
  home.packages = [
    pkgs._7zz # required for the ouch plugin
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = flakeSelf.inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
    shellWrapperName = "y";
    plugins = {

      ouch = pkgs.yaziPlugins.ouch;

    };
  };
}
