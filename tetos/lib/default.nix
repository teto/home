{
  pkgs,
  flakeSelf,
  lib,
  dotfilesPath,
  secretsFolder,
  secrets,
  ...
}:
let
  sway = import ./sway.nix;
  # doesnt like the pkgs
  nix-builders = import ./nix-builder.nix { inherit flakeSelf lib secretsFolder; };
  neovim = import ./neovim.nix { inherit flakeSelf lib; };
  wireguard = import  ./wireguard.nix { inherit secrets flakeSelf lib secretsFolder; };
  # email = import ./mail.nix { inherit pkgs; };
  firefox = import ./firefox.nix ;
  pure = import ./pure.nix ;

in
{
  inherit
    nix-builders
    firefox
    neovim
    sway
    wireguard
    ;

  inherit (neovim)
    genBlockLua
    luaPlugin
    ;

  inherit (nix-builders)
    deployrsNodeToBuilderAttr
    nixosConfToBuilderAttr
    ;


  inherit (wireguard) 
    mkWireguardPeer
    ;

  inherit (pure)
      importFiles 
      importDirectories
      ;


    nixpkgsMonitorEmailNotifier = 
    fromEmail:
    destinationEmail:
    # by name 
    pkgs.writeShellScript "notify-advancement" ''

    branch_name="$1"
    old_revision="$2"
    new_revision="$3"
    timestamp="$4"

    title="$branch_name advanced (from $HOSTNAME)";

    # strip leading spaces else msmtp will complain
    message=$(cat <<EOF
    From: ${fromEmail}
    To: ${destinationEmail}
    Subject: $title


    New revision: $new_revision
    Previous revision: $old_revision
    EOF
    )

    echo "$message" | ${lib.getExe pkgs.msmtp} --read-envelope-from --read-recipients -afastmail 
  '';


  /**
    default system
    modules: List
  */
  mkNixosSystem =
    {
      modules, # array
      withSecrets, # bool
      hostname,
      overlays,
      cudaSupport
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
        flakeSelf.inputs.sops-nix.nixosModules.sops
        flakeSelf.inputs.hm.nixosModules.home-manager

        # own module
        flakeSelf.nixosModules.tetos

        {
          nixpkgs.overlays = overlays;
          nixpkgs.config = nixpkgsConfig;
          # nixpkgs.hostPlatform.
          tetos.withSecrets = withSecrets;
        }

      ]
      ++ modules;

      specialArgs = {
        inherit dotfilesPath secretsFolder;
        inherit flakeSelf;
        inherit
          withSecrets
          secrets
          hostname
          lib
          ;
      };

    });


  # generate a client ssh config from the server config
  # https://fmartingr.com/blog/2022/08/12/using-ssh-config-match-to-connect-to-a-host-using-multiple-ip-or-hostnames/
  # Match localnetwork
  genSshClientConfig =
    # value is one of nixosConfigurations.<ENTRY>
    value:
    let
      mcfg = value.config;
      sshCfg = mcfg.services.openssh;
      name = mcfg.networking.hostName;
      hasDomain = mcfg.networking.domain != null;
    in
    builtins.trace "SSH config for ${name}" (
      lib.optionalAttrs sshCfg.enable 
        # lib.warn if "teto" is not in users.users
        {
          # or false) 
          # use originalhost ?
          header = ''Match host=${mcfg.networking.hostName}''
          # let resolved handle expansion for now ?!
          + lib.optionalString hasDomain ",${mcfg.networking.fqdn}"
          # + lib.optionalString (mcfg.tetos.wireguard.enable or false) ",${mcfg.networking.hostName}.vpn"
          ;

          # assumption ? or check/warn it has it ?
          # user = "teto";
          identityFile = "${secretsFolder}/ssh/id_rsa";
          port = builtins.head sshCfg.ports;
          identitiesOnly = true;
          AddKeysToAgent = "yes";

          # set domain to null ?
          # TODO  set it depending if hostName is FQDN ?
          # HostName = lib.throwIf (
          #   mcfg.networking.domain == null
          # ) "Missing domaing for ${name}" mcfg.networking.domain;
          # };

          # allow customizations ?
          Include = "${secretsFolder}/ssh/${mcfg.networking.hostName}";
        }  // lib.optionalAttrs (!hasDomain) {
          CanonicalizeFallbackLocal = true;
          CanonicalizeHostname = true;
          # done at resolve layer ?
          # CanonicalDomains = [ "local" "vpn" ];
        }
    );

  # temporary solution since it's not portable
  getPassword =
    accountName:
    # let
    #   # https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
    #   # 	  export PASSWORD_STORE_GPG_OPTS=" --default-cache-ttl 34560000"
    #   script = pkgs.writeShellScriptBin "pass-show" ''
    #     ${pkgs.pass}/bin/pass show "$@" | ${pkgs.coreutils}/bin/head -n 1
    #   '';
    # in
    # ["${script}/bin/pass-show" accountName];
    [
      "${lib.getExe pkgs.pass-perso}"
      "show"
      accountName
    ];

  /*
    convert a package to null because used to be borken

    null wont work
  */
  ignoreBroken =
    x: builtins.traceVerbose "${x.name} disabled because broken it used to be broken" pkgs.hello;


  genYaziVFSServer =
    # value is one of nixosConfigurations.<ENTRY>
    value:
    let
      mcfg = value.config;
      sshCfg = mcfg.services.openssh;
      name = mcfg.networking.hostName;
    in
    builtins.trace "YAZI config for ${name}"

      # header = ''Match host="${mcfg.networking.hostName},${mcfg.networking.domain}${lib.optionalString (mcfg.tetos.wireguard.enable or false) ",${mcfg.networking.hostName}.vpn"}"'';
      # assumption ? or check/warn it has it ?
      # identityFile = "${secretsFolder}/ssh/id_rsa";
      # host = "${mcfg.networking.hostName}";
      # .${mcfg.networking.domain}"
      ''
        [sftp.${name}]
        host = "${mcfg.networking.hostName}"
        user = "teto"
        port = ${toString (builtins.head sshCfg.ports)}
      ''
  # relies on SSH_AUTH_SOCK by default
  # key_file = "~/.ssh/id_rsa"
  # or identity_agent
  ;
}
