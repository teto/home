{ config, pkgs, lib,  ... }:
{
  programs.ssh = {

    enable = true;

    matchBlocks = {
      nova = {
        host = "git.novadiscovery.net";
        user = "matthieu.coudron";

      };
      ovh1 = {
        # checkHostIP
        identityFile = "~/.ssh/nova-infra-prod";
        user = "ubuntu";
        host = "ovh-hybrid-runner-1.devops.novadiscovery.net";
      };
      ovh2 = {
        identityFile = "~/.ssh/ci-infra-ec2-dev";
        user = "ubuntu";
        host = "ovh-hybrid-runner-2.devops.novadiscovery.net";
      };
      gitlab = {
        host = "gitlab.devops.novadiscovery.net";
        user = "ubuntu";
        identityFile = "~/.ssh/nova_key";
      };
      novinfra = {
        host = "data.novinfra.net";
        user = "ubuntu";
        # le port depend du service
        # port = 2207;
        identityFile = "~/.ssh/nova_key";
      };
    };
    # extraOptionOverrides
    # include path to file
    extraConfig = ''
      Include ./manual.config
    '';
  };

  # home.file.".ssh/manual.config".source = ;
}
