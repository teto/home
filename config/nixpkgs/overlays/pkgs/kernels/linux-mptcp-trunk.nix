{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

buildLinux (rec {
  mptcpVersion = "0.95.0";
  modDirVersion = "5.0.0";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  # autoModules= true;

  extraMeta = {
    branch = "5.0";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "teto";
    repo = "mptcp";
    rev = "ff14eb2e60b5c8143a6b29244249396eeb6c06f3";
    sha256 = "13mi671jr1x463kzig1hi9cpdi8x6nqdfd4bqlrjn8zca48f4ln4";
  };
  # I think that it's lost
  # src = builtins.fetchGit {
  #   url = https://github.com/teto/mptcp.git;
  #   # url = "gitolite@nixos.iijlab.net:mptcp.git";
  #   ref = "trunk_v8_wip";
  # };

} // args)
