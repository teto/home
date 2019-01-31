{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

buildLinux (rec {
  mptcpVersion = "0.94.1";
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

  # src = fetchFromGitHub {
  #   owner = "multipath-tcp";
  #   repo = "mptcp";
  #   rev = "4ea5dee9786aea30fad9fa9fa32f6ac1e5300623";
  #   sha256 = "0laaw4xnpllm3lkb90b336mzihzw6j09ygrz9jcbcm91sgb12lfa";
  # };

  # src = fetchFromGitHub {
  #   owner = "teto";
  #   repo = "mptcp";
  #   rev = "d60de4e248b0fbe7cebaa3e7efeda04c1f64cc72";
  #   sha256 = "19fmfpgwl7jkxyr3d628adwczsndl9ichv5acdghygw55fjdfjrm";
  # };

  # url = "gitolite@nixos.iijlab.net:mptcp.git";
  # url = "git@github.com:teto/mptcp.git";

    # ref = "dbc16ee030d76df43d11c3de4cc084c61060f13b";
    # ref = "993605d4ee781311249b60dde267d2200d80c805";
    src = builtins.fetchGit { 
      url = "ssh://git@github.com/teto/mptcp.git";
      # url = https://github.com/teto/mptcp.git;
      ref = "trunk_v8"; 
    };
# # url The URL of the repo. 
# # name The name of the directory the repo should be exported to in the store. Defaults to the basename of the URL. 
# # rev The git revision to fetch. Defaults to the tip of ref. 
# # ref The git ref to look for the requested revision under. This is often a branch or tag name. Defaults to HEAD. 
  #   # ref = "mptcp_trunk";
  #   ref = "netlink_pm_trunk";
  # };

    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcp";
    #   rev = "abc4f13f871965b9bf4726f832b2dbce2e1a2cc9";
    #   sha256 = "1r89hjc2p6v9dw57bj9bhh17cg60f7mpsywf9swbryna72m7z3pi";
    # };

    # VIRTIO y

  extraConfig = ''

    IPV6 y
    MPTCP y
    IP_MULTIPLE_TABLES y

    # Enable advanced path-managers...
    MPTCP_PM_ADVANCED y
    MPTCP_FULLMESH y
    MPTCP_NDIFFPORTS y
    MPTCP_NETLINK m
    # ... but use none by default.
    # The default is safer if source policy routing is not setup.
    DEFAULT_DUMMY y
    DEFAULT_MPTCP_PM default

    # MPTCP scheduler selection.
    MPTCP_SCHED_ADVANCED y
    DEFAULT_MPTCP_SCHED default

    # Smarter TCP congestion controllers
    TCP_CONG_LIA m
    TCP_CONG_OLIA m
    TCP_CONG_WVEGAS m
    TCP_CONG_BALIA m

  '' + (args.extraConfig or "");
} // args)
