{ config, pkgs, options, lib, ... } @ mainArgs:
let

  #ihaskellEnv = ghcWithPackages (self: [
  #  self.ihaskell
  #  (haskell.lib.doJailbreak self.ihaskell-blaze)
  #  (haskell.lib.doJailbreak self.ihaskell-diagrams)
  #  (haskell.lib.doJailbreak self.ihaskell-display)
  #] ++ packages self);
  #ihaskellSh = writeScriptBin "ihaskell-notebook" ''
  #  #! ${stdenv.shell}
  #  export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
  #  export PATH="${stdenv.lib.makeBinPath ([ ihaskellEnv jupyter ])}\${PATH:+':'}$PATH"
  #  ${ihaskellEnv}/bin/ihaskell install -l $(${ihaskellEnv}/bin/ghc --print-libdir) && ${jupyter}/bin/jupyter notebook
  #'';
  haskellEnv = pkgs.haskellPackages.ghcWithHoogle (self: [
          self.ihaskell
          (pkgs.haskell.lib.doJailbreak self.ihaskell-blaze)
          (pkgs.haskell.lib.doJailbreak self.ihaskell-diagrams)
          (pkgs.haskell.lib.doJailbreak self.ihaskell-display)
          # self.netlink
        ]);  
        
  # le tric la c que c pas le ihhaskell de all-packages.nix mais celui du haskell set 
  # apparemment le global peut se configurer via nixpkgs.config.ihaskell.packages.
  # faut s'en inspirer
  # by default --use-rtsopts=""
  ihaskellKernel = pkgs.runCommand "ihaskellKernel" {
        buildInputs = [ pkgs.jupyter]; } ''
    export HOME=/tmp
    ${haskellEnv}/bin/ihaskell install --prefix=$out --use-rtsopts=""
  '';
  # 
  # buildEnv {
  #   name = "ihaskell-with-packages";
  #   buildInputs = [ makeWrapper ];
  #   paths = [ ihaskellEnv jupyter ];
  #   # export PATH="${pkgs.stdenv.lib.makeBinPath ([ ihaskellEnv ])}''${PATH:+:}$PATH"
  #   # export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
  #   # export PATH="${stdenv.lib.makeBinPath ([ ihaskellEnv jupyter ])}''${PATH:+:}$PATH"
  #   # to find ghc_pkg/hoogle doc etc
  #   postBuild = ''
  #     for prg in $out/bin"/"*;do
  #       if [[ -f $prg && -x $prg ]]; then
  # ca on en aura plus besoin ?!
  #         wrapProgram $prg --set PYTHONPATH "$(echo ${jupyter}/lib/*/site-packages)" \
  #           --prefix GHC_PACKAGE_PATH ':' "$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':')" \
  #           --prefix PATH ':'  "${stdenv.lib.makeBinPath ([ ihaskellEnv jupyter ])}"
  #       fi
  #     done
  #   '';
  # }

in
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
      # jupyter notebook --generate-config
      # 
#c.MappingKernelManager.kernel_info_timeout = 60
    notebookConfig = ''
      c.Application.log_level = 'DEBUG'
      c.Session.debug = True
      c.KernelManager.debug_kernel = True
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

          # ihaskellSh = pkgs.writeScriptBin "ihaskell-wrapper" ''
          #ihaskellSh = pkgs.writeScript "ihaskell-wrapper" ''
          #  #! ${pkgs.stdenv.shell}
          #  export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
          #  export PATH="${pkgs.stdenv.lib.makeBinPath ([ ihaskellEnv ])}''${PATH:+:}$PATH"
          #  ${ihaskellEnv}/bin/ihaskell ''$@
          #'';
          # share/jupyter/kernels/haskell/
          content = builtins.fromJSON (builtins.readFile "${ihaskellKernel}/share/jupyter/kernels/haskell/kernel.json");
        in 
        # builtins.trace 
        content
        # todo 
        # // {
        #   content.
          
        # }
        ;

        # {
          # displayName = "Haskell for machine learning";
          # # https://github.com/gibiansky/IHaskell/issues/920
          # argv = [
            # "${ihaskellSh}"
            # "kernel"
            # "{connection_file}"
            # "--ghclib"
            # "${ihaskellEnv}/lib/ghc-8.4.3"
            # "+RTS"
            # "-M3g"
            # # "-N2" # requires the program to be compiled with threaded
            # "-RTS"
          # ];
          # language = "haskell";
        # };


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
