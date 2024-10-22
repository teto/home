{
  stdenv,
  lib,
  buildPackages,
  fetchFromGitHub,
  perl,
  buildLinux,
  ...
}@args:

buildLinux (
  rec {
    mptcpVersion = "0.96.0";
    modDirVersion = "5.1.0";
    version = "${modDirVersion}-mptcp_v${mptcpVersion}";
    # autoModules= true;

    extraMeta = {
      branch = "5.1";
      maintainers = with lib.maintainers; [
        teto
        layus
      ];
    };

    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcp";
    #   rev = "8185ea4b9a4cdd42c68e9acdaae3fd9ce37b02ad";
    #   sha256 = "0rfrn3n9c0sksk5xqbi8nbzp8rb1vmckb44jzcli01cpdx35p98b";
    # };

    # this can take a long time
    src = builtins.fetchGit {
      # url = https://github.com/teto/mptcp.git;
      #  tilpner: arg the git fetch was working but after 50mn died with "remote: fatal: Out of memory, calloc failed". I will give more memory to the VM
      # now it seems like the firewall blocks some ports that could be used

      # this was too slow on gitolite
      # url = "gitolite@nixos.iijlab.net:mptcp.git";
      # on github it should be faster
      url = "git@github.com:teto/mptcp_private.git";
      ref = "integrated_owd";

    };

  }
  // args
)
