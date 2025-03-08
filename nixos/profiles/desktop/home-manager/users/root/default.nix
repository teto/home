{
  flakeSelf,
  ...
}:
{
  # to generate ssh config file for the nix builder
  programs.ssh.enable = true;

  imports = [
    flakeSelf.homeModules.neovim
  ];
}
