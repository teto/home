{ config, lib, pkgs, flakeInputs, ... }:
{

 services.rstudio-server = {
   enable = true;
   # Rstudio server package to use. Can be set to rstudioServerWrapper to provide packages.
   # Default: pkgs.rstudio-server
   # Example: pkgs.rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; }
   package = pkgs.rstudio-server;
   # listenAddress
   # rserverExtraConfig = ''

   # defaults to "/var/lib/rstudio-server"
   # serverWorkingDir 
   # rsessionExtraConfig = ''
   #  '';
  };
}
