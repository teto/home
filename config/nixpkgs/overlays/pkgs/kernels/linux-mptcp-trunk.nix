{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

buildLinux (rec {
  mptcpVersion = "0.96.0";
  modDirVersion = "5.1.0";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  # autoModules= true;

  extraMeta = {
    branch = "5.1";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "teto";
    repo = "mptcp";
    rev = "8185ea4b9a4cdd42c68e9acdaae3fd9ce37b02ad";
    sha256 = "0rfrn3n9c0sksk5xqbi8nbzp8rb1vmckb44jzcli01cpdx35p98b";
  };
  # I think that it's lost
  # src = builtins.fetchGit {
  #   url = https://github.com/teto/mptcp.git;
  #   # url = "gitolite@nixos.iijlab.net:mptcp.git";
  #   ref = "trunk_v8_wip";
  # };

} // args)
