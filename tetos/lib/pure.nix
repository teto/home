{ lib }:
{
  /**
    Maps over folders in folder
  */
  importDirectories = folder: transformEntry:
    
    let
      # transformEntry = lib.id;
      pred = key: val: val == "directory";

      folders = lib.mapAttrs' transformEntry (lib.filterAttrs pred (builtins.readDir folder));
    in
      folders;

  importFiles =
    folder:
    let
      genKey = str: lib.replaceStrings [ ".nix" ] [ "" ] (baseNameOf (toString str));

      pred = name: val: lib.strings.hasSuffix ".nix" name;

      transformEntry =
        filename: val:
        let
          key = genKey filename;
          val' = folder + "/${filename}";
        in

        lib.nameValuePair key val';

      listOfModules = lib.mapAttrs' transformEntry (lib.filterAttrs pred (builtins.readDir folder));

    in
    listOfModules;

  /**
    default system
    modules: List
  */
  mkNixosSystem =
    {
      modules, # array
      withSecrets, # bool
      # hostname,
      overlays,
      cudaSupport,
      ...
    }@attrs:
  let 
    nixpkgsConfig = {
            # on desktop
            inherit cudaSupport;
            # nvidia.acceptLicense = true;
            # cudaCapabilities = [ "8.9" ]; # can speed up some builds ?
            checkMeta = false;
            # showDerivationWarnings = ["maintainerless"];

            allowUnfree = true;
            # this list makes me wanna vomit (except steam maybe because they do good for linux),
            # and sublime because guy has to eat
            allowUnfreePredicate =
              pkg:
              let
                ensureList = x: if builtins.isList x then x else [ x ];
                hasCudaLicense =
                  package:
                  builtins.all (
                    license:
                    license.free
                    || builtins.elem license.shortName [
                      "CUDA EULA"
                      "cuDNN EULA"
                      "cuSPARSELt EULA"
                      "cuTENSOR EULA"
                      "NVidia OptiX EULA"
                    ]
                  ) (ensureList package.meta.license);
                pkgName = lib.getName pkg;
              in
              if hasCudaLicense "cuda" pkgName then
                true
              else
                builtins.elem pkgName [
                  "antigravity-cli"
                  "Oracle_VM_VirtualBox_Extension_Pack"
                  "Oracle_VirtualBox_Extension_Pack"
                  "jocalsend"
                  "codeium"
                  "claude-code"
                  "mistral-vibe"

                  "ec2-api-tools"
                  "google-chrome"
                  # "slack"
                  "steam"
                  "steam-original"
                  "steam-runtime"
                  "steam-run"
                  "steam-unwrapped"
                  "sublimetext3"
                  "vault"
                  "vscode"
                  "vscode-extension-ms-vsliveshare-vsliveshare"
                  "xmind"
                  "zoom"
                ];
          };

  in
    # set it via nixpkgs.system.
    # nixpkgs.pkgs
    lib.nixosSystem (lib.recursiveUpdate (removeAttrs attrs ["withSecrets" "hostname" "cudaSupport" "overlays"] ) {
      # system = "x86_64-linux";
      # inherit pkgs;
      modules = [
        # flakeSelf.inputs.sops-nix.nixosModules.sops
        # flakeSelf.inputs.hm.nixosModules.home-manager
        #
        # # own module
        # flakeSelf.nixosModules.tetos

        {
          nixpkgs.overlays = overlays ++ [

            # define our own lib
            
          ];
          nixpkgs.config = nixpkgsConfig;
          # nixpkgs.hostPlatform.
          tetos.withSecrets = withSecrets;
        }

      ]
      ++ modules;

      # specialArgs = {
      #   inherit dotfilesPath secretsFolder;
      #   inherit flakeSelf;
      #   inherit
      #     withSecrets
      #     secrets
      #     hostname
      #     lib
      #     ;
      # };

    });


}
