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
  firefox = pkgs.callPackage ./firefox.nix { };
  nix-builders = import ./nix-builder.nix { inherit flakeSelf lib secretsFolder; };
  neovim = import ./neovim.nix { inherit flakeSelf lib; };
  wireguard = import  ./wireguard.nix { inherit secrets flakeSelf lib secretsFolder; };

in
{
  inherit
    nix-builders
    firefox
    neovim
    sway
    ;

  inherit (neovim)
    genBlockLua
    luaPlugin
    ;

  inherit (nix-builders)
    deployrsNodeToBuilderAttr
    nixosConfToBuilderAttr
    ;

  inherit wireguard;

  inherit (wireguard) 
    mkWireguardPeer
    ;



    nixpkgsMonitorEmailNotifier = 
    fromEmail:
    destinationEmail:
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
      # pkgs = self.inputs.nixos-unstable.legacyPackages.${system}.pkgs;
      pkgs,
    }:
    lib.nixosSystem {
      system = "x86_64-linux";
      inherit pkgs;
      modules = [
        flakeSelf.inputs.sops-nix.nixosModules.sops
        flakeSelf.inputs.hm.nixosModules.home-manager

        # own module
        flakeSelf.nixosModules.tetos
        {
            tetos.withSecrets = true;
        }

      ]
      ++ modules;

      specialArgs = {
        inherit
          withSecrets
          secrets
          hostname
          lib
          ;
        inherit dotfilesPath secretsFolder;
        inherit flakeSelf;
      };

    };

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
    in
    builtins.trace "SSH config for ${name}" (
      lib.optionalAttrs sshCfg.enable
        # lib.warn if "teto" is not in users.users
        {
          # or false) 
          header = ''Match host="${mcfg.networking.hostName},${mcfg.networking.hostName}.${mcfg.networking.domain}${lib.optionalString (mcfg.tetos.wireguard.enable or false) ",${mcfg.networking.hostName}.vpn"}"'';
          # assumption ? or check/warn it has it ?
          # user = "teto";
          identityFile = "${secretsFolder}/ssh/id_rsa";
          port = builtins.head sshCfg.ports;
          identitiesOnly = true;
          # extraOptions = {
          AddKeysToAgent = "yes";
          CanonicalizeHostname = true;
          # CanonicalDomains corp.example.com lab.example.com 
          # set domain to null ?
          CanonicalDomains = [ "${mcfg.networking.hostName}.${mcfg.networking.domain}" ];
          # Specifies  rules to determine whether CNAMEs should be followed when canonicalizing hostnames.  The rules consist
          # CanonicalizePermittedCNAMEs
          # TODO  set it depending if hostName is FQDN ?
          # HostName = lib.throwIf (
          #   mcfg.networking.domain == null
          # ) "Missing domaing for ${name}" mcfg.networking.domain;
          # };
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
      "${pkgs.pass-perso}/bin/pass-perso"
      # "${dotfilesPath}/bin/pass-perso"
      "show"
      accountName
    ];

  /*
    convert a package to null because used to be borken

    null wont work
  */
  ignoreBroken =
    x: builtins.traceVerbose "${x.name} disabled because broken it used to be broken" pkgs.hello;

}
