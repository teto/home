{
  pkgs,
  config,
  flakeSelf,
  lib,
  secretsFolder,
  ...
}:
let
  inherit (lib) mkRemoteBuilderDesc;
  builder_neotokyo = mkRemoteBuilderDesc "3.0" (
    lib.nixosConfToBuilderAttr {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      # can
      # it's a base64 version of it
      publicHostKey = builtins.readFile ../../../../hosts/neotokyo/host_key.pub;
    } flakeSelf.nixosConfigurations.neotokyo
  );

  # public host key of the remote machine.  If omitted, SSH uses its regular known_hosts file.
  builder_jedha = mkRemoteBuilderDesc "3.0" (
    lib.nixosConfToBuilderAttr {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;
    } flakeSelf.nixosConfigurations.jedha
  );

  # TODO add jedha
  # flakeSelf.deploy.nodes.jedha;
in
{

  # goes to .profile
  sessionVariables = {
    TETOS_0 = builder_neotokyo;
    TETOS_1 = builder_jedha;

    HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    # HISTFILE="$XDG_CACHE_HOME/bash_history";
    CDPATH = "$HOME/neovim:$HOME/nova";
  };
  historyFile = "${config.xdg.cacheHome}/bash_history";

  shellAliases = {

    # nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";

    m = "neomutt";
    ns = "nix-shell";
  };

  # source_if_exists
  #     source $XDG_CONFIG_HOME/bash/lib.sh
  initExtra = ''
    source $XDG_CONFIG_HOME/bash/aliases.sh
    source $XDG_CONFIG_HOME/bash/bashrc.sh || true
  '';

}
