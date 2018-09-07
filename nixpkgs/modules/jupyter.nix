{ config, pkgs, options, lib, ... } @ mainArgs:
{
# only if exists !
# enableDebugging
# journalctl -b -u jupyter.service 
  services.jupyter = {
    enable = true;
    # port = 8123; # 8888 by default
    # notebookDir = "/var/www/jupyter"; # ~ by default
    # password is 'test'

    # raw jupyter config
    notebookConfig = ''

      '';


    password = "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'";
    kernels= {
      # Python3 kernel
        python3 = let
          env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                  ipykernel
                  pandas
                  scikitlearn
                ]));
        in {
          displayName = "Python 3 for machine learning";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
          logo32 = builtins.toPath "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
          # logo64 = builtins.toPath "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };

        # just need to run
        # ihaskell install  --debug --prefix .
        # then we can read share/jupyter/kernels/haskell/kernel.json
        # ihaskell-kernel = builtins.toPath

      # haskell kernel
        haskell = let 
          ihaskellEnv = pkgs.haskellPackages.ghcWithHoogle (self: [
          self.ihaskell
          (pkgs.haskell.lib.doJailbreak self.ihaskell-blaze)
          (pkgs.haskell.lib.doJailbreak self.ihaskell-diagrams)
          (pkgs.haskell.lib.doJailbreak self.ihaskell-display)
          # self.netlink
          ]);

          # ihaskellSh = pkgs.writeScriptBin "ihaskell-wrapper" ''
          ihaskellSh = pkgs.writeScript "ihaskell-wrapper" ''
            #! ${pkgs.stdenv.shell}
            export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
            export PATH="${pkgs.stdenv.lib.makeBinPath ([ ihaskellEnv ])}''${PATH:+:}$PATH"
            ${ihaskellEnv}/bin/ihaskell ''$@
          '';
        in {
          displayName = "Haskell for machine learning";
          # https://github.com/gibiansky/IHaskell/issues/920
          argv = [
            "${ihaskellSh}"
            "kernel"
            "{connection_file}"
            "--ghclib"
            "${ihaskellEnv}/lib/ghc-8.4.3"
            "+RTS"
            "-M3g"
            # "-N2" # requires the program to be compiled with threaded
            "-RTS"
          ];
          language = "haskell";
        };


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

      };

  };
}
