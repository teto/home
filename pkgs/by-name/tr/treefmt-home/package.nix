
         treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.x86_64-linux {
          # Used to find the project root
          projectRootFile = ".git/config";

          # TODO useofficial 
          programs.fourmolu.enable = true;
          programs.nixfmt = { 
            enable = true;
            package = myPkgs.nixfmt;
          };
          programs.stylua.enable = true;
          programs.just.enable = true;
          programs.shfmt.enable = true;

          settings.global.excludes = [
            "*.org"
            "*.wiki"
            "nixpkgs/secrets.nix" # all git-crypt files ?
          ];

        };
