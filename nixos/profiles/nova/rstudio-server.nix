{
  config,
  lib,
  pkgs,
  system,
  ...
}:
{

  services.rstudio-server = {
    enable = false;
    # Rstudio server package to use. Can be set to rstudioServerWrapper to provide packages.
    # Default: pkgs.rstudio-server
    # Example: pkgs.rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; }
    # package = pkgs.rstudio-server;
    # package = flakeInputs.jinko-stats.packages.${pkgs.system}.rstudio-server;
    # 127.0.0.1
    # listenAddress
    # rserverExtraConfig = ''

    # defaults to "/var/lib/rstudio-server"
    # serverWorkingDir
    # rsessionExtraConfig = ''
    #  '';
  };
}
