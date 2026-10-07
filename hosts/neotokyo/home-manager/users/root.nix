{ withSecrets }:
{

  home.stateVersion = "26.05";

  programs.ssh.enable = withSecrets;

  programs.ssh.enableDefaultConfig = false;

}
