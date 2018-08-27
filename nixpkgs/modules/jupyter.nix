{ config, pkgs, options, lib, ... } @ mainArgs:
{
# only if exists !
  services.jupyter = {
    enable = true;
    # port = 8123; # 8888 by default
    # notebookDir = "/var/www/jupyter"; # ~ by default
    # password is 'test'

    # raw jupyter config
    notebookConfig = ''

      '';


    password = "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'";
    # kernels= {

      # sage = let 
      #   # readFile
      #   kernel= builtins.fromJSON (builtins.readFile (pkgs.sage + "/share/jupyter/kernels/sagemath/kernel.json")) // {
      #     language="python";
      #   };
      #     env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      #               ipykernel
      #               pandas
      #               scikitlearn
      #               # qtconsole
      #             ]));
      #   in 
      #   kernel;
                # {
            # displayName = "Python 3 for sage";
            # argv = [
              # "$ {env.interpreter}"
              # "-m"
              # "ipykernel_launcher"
              # "-f"
              # "{connection_file}"
            # ];
            # language = "python";
            # logo32 = "$ {env.sitePackages}/ipykernel/resources/logo-32x32.png";
            # logo64 = "$ {env.sitePackages}/ipykernel/resources/logo-64x64.png";
          # };
      # };

  };
}
