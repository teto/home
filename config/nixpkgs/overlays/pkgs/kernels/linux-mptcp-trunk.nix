{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

buildLinux (rec {
  mptcpVersion = "0.94.4";
  modDirVersion = "4.19.0";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  # autoModules= true;

  extraMeta = {
    branch = "4.19";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  #src = fetchFromGitHub {
  #  owner = "multipath-tcp";
  #  repo = "mptcp";
  #  rev = "v${mptcpVersion}";
  #  sha256 = "13mi672jr1x463kzig1hi9cpdi8x6nqdfd4bqlrjn8zca48f4ln4";
  #};
  # I think that it's lost


    src = builtins.fetchGit {
      # url = "ssh://git@github.com/teto/mptcp.git";
      url = https://github.com/teto/mptcp.git;
      # url = "gitolite@nixos.iijlab.net:mptcp.git";
      ref = "trunk_v8_wip";
      # url = https://github.com/teto/mptcp.git;
      # sha256= "00000000000000000000000000000000";
    };

} // args)
