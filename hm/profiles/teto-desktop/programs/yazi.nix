{ flakeSelf, pkgs, lib
# , secretsFolder
, ... }:
let 
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
          ''
          [sftp.${name}]
          host = "${mcfg.networking.hostName}.${mcfg.networking.domain}"
          user = "teto"
          port = ${toString (builtins.head sshCfg.ports)}
          ''
          # relies on SSH_AUTH_SOCK by default
          # key_file = "~/.ssh/id_rsa"
          # or identity_agent
          ;

  serverConfigs = lib.mapAttrsToList (
    _: nixosCfg:
    lib.optionalAttrs nixosCfg.config.services.openssh.enable (genYaziVFSServer nixosCfg)
  ) flakeSelf.nixosConfigurations;

in
{
  _imports = [
    flakeSelf.homeProfiles.yazi
    {

      # https://yazi-rs.github.io/docs/configuration/vfs
      xdg.configFile."yazi/vfs-generated.toml".text = lib.concatStringsSep "\n" serverConfigs;
    }
  ];

  enable = true;
  package = flakeSelf.inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
  # shellWrapperName = "y";

  # NOTE that these can be installed imperatively via
  # ya pack -a GianniBYoung/rsync for instance
  plugins = {
    # foo = ./foo;
    # ouch = pkgs.yaziPlugins.ouch;
    # TODO package flakeSelf.inputs.rsync-yazi-plugin;
    # rsync = pkgs.rsync-yazi; # packaged by myself
    mediainfo = pkgs.yaziPlugins.mediainfo;

    # rsync-packaged = pkgs.mkYaziPlugin {
    #
    # };
  };
}
