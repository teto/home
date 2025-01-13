{
  pkgs,
  withSecrets,
  lib,
  flakeSelf,
  ...

}:
{
  imports =
    [

      # flakeSelf.homeModules.neovim
    ]
    ++ lib.optionals withSecrets [
      # ../../hm/profiles/nova/ssh-config.nix
      flakeSelf.homeModules.nova
    ];
  
  # root profile: Must have exactly one default Firefox profile but found 0
  programs.firefox.enable = lib.mkForce false;
  programs.ssh.enable = true;
}
