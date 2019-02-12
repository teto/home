# https://nixos.wiki/wiki/Linux_Kernel
self: prev:
# with prev.lib.kernel;


# DYNAMIC_DEBUG n is important !!

let

  # level of indirection while waiting for a better solution
  # callPackage ?
  libk = import <nixpkgs/lib/kernel.nix> { inherit (prev.stdenv) lib; version = 4; };


  # TODO I could use this to discrimanate between branches ?
    # let res = builtins.tryEval (
    #   if isDerivation value then
    #     value.meta.isBuildPythonPackage or []
    #   else if value.recurseForDerivations or false || value.recurseForRelease or false then
    #     packagePython value
    #   else
    #     []);
    # in if res.success then res.value else []

  # TODO tester ce qui fait flipper/ peut foirer
# EXT4_ENCRYPTION
# /home/teto/nixpkgs3/lib/kernel.nix


#  strongswan required configuration
# https://wiki.strongswan.org/projects/strongswan/wiki/KernelModules
  structuredConfigs = import ../structured.nix { inherit (prev) lib; inherit libk;};


  # see wiki
  addMenuConfig = kernel:
  kernel.overrideAttrs (o: {
    nativeBuildInputs=o.nativeBuildInputs ++ [ prev.pkgconfig prev.qt5.qtbase prev.ncurses ];
    shellHook = o.shellHook + ''
      echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
      echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
    '';
  });

    # extraConfig = mptcpKernelExtraConfig + localConfig 
    #  + bpfConfig + net9pConfig + mininetConfig + noChelsio + ovsConfig;
  defaultConfigStructured = with prev.lib.kernel; with structuredConfigs; prev.lib.mkMerge [
    # structuredConfigs.kvmConfigStructured
    bpfConfigStructured
    debugConfigStructured
    mininetConfigStructured
    kvmConfigStructured
    mptcpConfigStructured
    localConfigStructured
    net9pConfigStructured
    strongswanStructured  # to get VPN working

    noChelsio # because of mptcp trunk

  ];



  # todo remove tags
  filter-src = builtins.filterSource (p: t:
  let baseName = baseNameOf p;
  in prev.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

  # potentially interesting
  # KERN_DEFAULT "d" The default kernel loglevel
  # KERN_CONT "" "continued" line of log printout (only done after a line that had no enclosing)
  # todo we could use isYes
  # system.requiredKernelConfig

  # don't forget to suppress LOCALVERSION 
  # LOCALVERSION_AUTO

  # logic of kernel config 
  # my $answer = "";
  # # Build everything as a module if possible.
  # $answer = "m" if $autoModules && $alts =~ /\/m/ && !($preferBuiltin && $alts =~ /Y/);
  # $answer = $answers{$name} if defined $answers{$name};

  # in common-config.nix mark it as an optional one with `?` suffix,
  # VETH mandatory because of things like "ip link add name h1-eth0 address de:73:c3:f9:49:73 type veth peer name s1-eth1 address ca:80:83:c9:8b:3c netns"

  # might be needed for newer kernels to embed the module
  # NF_DEFRAG_IPV6 y
  # NF_NAT_IPV4 y
  # NF_NAT_IPV6 y
  #ovsConfig = 
  #  #prev.pkgs.openvswitch.kernelExtraConfig or 
  #  ''
  #  # Can't be embedded; must be a module !?
  #  NF_INET y
  #  NF_CONNTRACK y

  #  NF_NAT y
  #  NF_NAT_IPV4 y

  #  # added for mptcp trunk
  #  IPV6 n
  #  NF_NAT_IPV6 n
  #  NETFILTER y
  #  NETFILTER_CONNCOUNT y
  #  NETFILTER_ADVANCED y

  #  NFT_CONNLIMIT y
  #  NF_NAT y
  #  NF_TABLES y

  #  # force it to yes as otherwise generate-config.pl seems to ignore it ?
  #  # NET_NSH y
  #  OPENVSWITCH y
  #'';

in rec {

  # mptcpStructuredExtraConfig = mkMerge [
  #   kvmConfigStructured
  #   debugConfigStructured
  #   net9pConfig
  # ];

  mptcp94 = (prev.linux_mptcp.override ({
      kernelPatches=[];
      ignoreConfigErrors=true;
      autoModules = false;
      preferBuiltin = true;
      structuredExtraConfig = defaultConfigStructured;
      # extraConfig = mptcpKernelExtraConfig;
  }));

  mptcp94-local-stable = mptcp94.override ({

    # src = prev.fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcp";
    #   rev = "c1f91c32ebd1d4bf38fc17756c61441c925135cb";
    #   sha256 = "061zzlkjm3i1nhgnz3dfhbshjicrjc5ydwy6hr5l6y8cl2ps2iwf";
    # };
    # modDirVersion="4.9.87";
    # modVersion="4.9.87";
    # modDirVersion="4.9.60-matt+";
    name="mptcp94-local";

    # TODO might need to revisit
    ignoreConfigErrors = true;
    autoModules = false;
    kernelPreferBuiltin = true;

    structuredExtraConfig = defaultConfigStructured;
    # extraConfig = mptcpKernelExtraConfig + localConfig 
    # + ovsConfig + bpfConfig + net9pConfig + mininetConfig
    # ;
  });


  lkl_mptcp = prev.pkgs.lkl.overrideAttrs(old: {
    src = builtins.fetchGit file:///home/teto/lkl;
  });

  # "cc10d7c54daa1dd6bd00d24619ed4eb6be8f5691";
  # linux_mptcp_with_netlink = (prev.linux_mptcp_94 or prev.linux_mptcp).override({

  # my_lenovo_kernel = prev.linux_latest.override({
  my_lenovo_kernel = linux_mptcp_trunk;
  # my_lenovo_kernel = self.linux_mptcp_with_netlink.override({



  linux_mptcp_trunk_raw = addMenuConfig (prev.callPackage ./pkgs/kernels/linux-mptcp-trunk.nix {

    kernelPatches = prev.linux_4_19.kernelPatches;
    # does not seem true anymore
    preferBuiltin = true;
    ignoreConfigErrors=true;
    # autoModules = true;
    # boot.debug1device
    # modDirVersion="4.19.0";

    structuredExtraConfig = defaultConfigStructured;
    # extraConfig = mptcpKernelExtraConfig + localConfig 
    #  + bpfConfig + net9pConfig + mininetConfig + noChelsio + ovsConfig;
  });

  # see https://nixos.wiki/wiki/Linux_Kernel
  linux_mptcp_trunk = (prev.linuxManualConfig {
    inherit (prev) stdenv;
    inherit (linux_mptcp_trunk_raw) src version modDirVersion;
    # version = linux_mptcp_94.version;

    configfile = /home/teto/dotfiles/kernels/mptcp_trunk_netlink.config;
    # we need this to true else the kernel can't parse the config and 
    # detect if modules are in used
    allowImportFromDerivation = true;
    # modDirVersion="4.14.70";

  }).overrideAttrs (oa: {
    shellHook = ''
      touch .scmversion
      echo "hello boss"
    '';
  });

  # linux_mptcp_trunk_test = self.linux_mptcp_trunk.overrideAttrs(oa: {
  #   src = prev.fetchFromGitHub {
  #     owner = "teto";
  #     repo = "mptcp";
  #     rev = "abc4f13f871965b9bf4726f832b2dbce2e1a2cc9";
  #     sha256 = "061zzlkjm3i1nhgnz3dfhbshjicrjc5ydwy6hr3l6y8cl2ps2iwf";
  #   };
  # });

    # linux_test2 = linux_test.override {
    #   # TODO 
    #   structuredExtraConfig = with prev.lib.modules;
    #   # just to tests
    #   # mkMerge 
    #   [
    #     # linux_test.passthru.commonStructuredConfig
    #     structuredConfigs.mininetConfigStructured 
    #     { USB_DEBUG = optional yes; }
    #     { USB_DEBUG = yes; }
    #   ];
    # };

}

