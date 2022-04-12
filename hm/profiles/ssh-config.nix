{ config, pkgs, lib,  ... }:
{
  programs.ssh = {

    enable = true;

	# can I have it per target ?
	# controlPath = "";
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
		identitiesOnly = true;
      };
      ovh2 = {
        # identityFile = "~/.ssh/ci-infra-ec2-dev";
        identityFile = "~/.ssh/ci-infra-ec2-dev";
        user = "ubuntu";
        host = "ovh-hybrid-runner-2.devops.novadiscovery.net";
		identitiesOnly = true;
      };
      # ovh3 = {
      #   identityFile = "~/.ssh/nova-infra-prod";
      #   user = "ubuntu";
      #   host = "ovh-hybrid-runner-3.devops.novadiscovery.net";
		# extraOptions = {
		  # # to fix https://dammit.nl/ssh-unix-socket.html
		  # controlPath = "~/.ssh/control/%C";
		# };
      # };
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
    extraConfig = ''
      Include ./manual.config
    '';
  };

  # home.file.".ssh/manual.config".source = ;
}
