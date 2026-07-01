{
  flakeSelf
, ...
}:
{

  home.stateVersion = "26.05";

  programs.ssh.enable = true;

  programs.ssh.enableDefaultConfig = false;

  imports = [
      flakeSelf.homeModules.nixpkgs-monitor
  ];

  services.nixpkgs-monitor = {
    enable = true;
    # TODO send a mail
    # on-branch-advance-cmd
  };

}
