{ pkgs
, withSecrets 
, lib
, flakeSelf
, ... 

}:
{
    imports = [

      # flakeSelf.homeModules.neovim
    ] ++ lib.optionals withSecrets [
      # ../../hm/profiles/nova/ssh-config.nix 
        flakeSelf.homeModules.nova
    ];

  programs.ssh.enable = true;
}
