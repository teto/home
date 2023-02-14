{ config, pkgs, lib, secrets, ... }:
{
  programs.ssh = {

    enable = true;

    # can I have it per target ?
    # controlPath = "";
    matchBlocks = {
      jakku = {
        host = secrets.jakku.hostname;
        user = "teto";
        # le port depend du service
        port = secrets.jakku.sshPort;
        identityFile = "~/.ssh/id_rsa";
      };
      nova = {
        host = "git.novadiscovery.net";
        user = "matthieu.coudron";
        identityFile = "~/.ssh/nova_key";
      };
      ovh1 = {
        # checkHostIP
        identityFile = "~/.ssh/nova_key";
        # user = "nova";
        host = "ovh1";
        hostname = "ovh-hybrid-runner-1.devops.novadiscovery.net";
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        # match = "ovh1";
      };
      ovh2 = {
        # identityFile = "~/.ssh/ci-infra-ec2-dev";
        identityFile = "~/.ssh/nova_key";
        # user = "teto";
        host = "ovh2";
        hostname = "ovh-hybrid-runner-2.devops.novadiscovery.net";
        identitiesOnly = true;
      };
      ovh3 = {
        # identityFile = "~/.ssh/nova-infra-prod";
        # user = "teto";
        identitiesOnly = true;
        identityFile = "~/.ssh/nova_key";
        host = "ovh3";
		port = 12666;

        hostname = "ovh-hybrid-runner-3.devops.novadiscovery.net ";
        # extraOptions = {
        # to fix https://dammit.nl/ssh-unix-socket.html
        # controlPath = "~/.ssh/control/%C";
        # };
      };
      gitlab = {
        host = "gitlab.devops.novadiscovery.net";
        user = "ubuntu";
        identityFile = "~/.ssh/nova_key";
        identitiesOnly = true;
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
    # { path = config.xdg.configHome + "/git/config.inc"; }

    extraConfig = ''
      Include "${config.xdg.configHome}/ssh/config"
    '';
  };

  # home.file.".ssh/manual.config".source = ;
}
