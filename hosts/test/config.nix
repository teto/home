
{ config, flakeInputs, lib, pkgs, ... }:
{
  # imports = [

  home-manager.users.teto = {
    # TODO it should load the whole folder
    imports = [
     # ./teto/home.nix
      ../../hm/profiles/zsh.nix
      ../../hm/profiles/neovim.nix

      # breaks build: doesnt like the "activation-script"
     # nova.hmConfigurations.dev
    ];
  };
}
