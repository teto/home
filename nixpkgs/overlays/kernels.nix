self: prev:

  with prev.lib.kernel;
let
    # todo remove tags
    filter-src = builtins.filterSource (p: t:
    let baseName = baseNameOf p;
    in prev.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

  # potentially interesting
  # CONFIG_NLMON is not set
  # KERN_DEFAULT "d" The default kernel loglevel
  # KERN_CONT "" "continued" line of log printout (only done after a line that had no enclosing)
  # todo we could use isYes
  # system.requiredKernelConfig


  
	# depends on !NF_CONNTRACK || \
	# 	   (NF_CONNTRACK && ((!NF_DEFRAG_IPV6 || NF_DEFRAG_IPV6) && \
	# 			     (!NF_NAT || NF_NAT) && \
	# 			     (!NF_NAT_IPV4 || NF_NAT_IPV4) && \
	# 			     (!NF_NAT_IPV6 || NF_NAT_IPV6)))

  # logic of kernel config 
  # my $answer = "";
  # # Build everything as a module if possible.
  # $answer = "m" if $autoModules && $alts =~ /\/m/ && !($preferBuiltin && $alts =~ /Y/);
  # $answer = $answers{$name} if defined $answers{$name};

  # in common-config.nix mark it as an optional one with `?` suffix,
  # VETH mandatory because of things like "ip link add name h1-eth0 address de:73:c3:f9:49:73 type veth peer name s1-eth1 address ca:80:83:c9:8b:3c netns"
  # TODO import 
  mininetConfig = ''
    BPF y
    BPF_SYSCALL y
    NET_CLS_BPF y
    NET_ACT_BPF y
    BPF_JIT y
    BPF_EVENTS y
    USER_NS y
    VETH y
    NET_SCH_HTB y
    NET_SCH_RED y
    NET_SCH_SFB y
    NET_SCH_SFQ y
    NET_SCH_TBF y
    NET_SCH_GRED y
    NET_SCH_NETEM y
    NET_SCH_INGRESS y
    NET_CLS y
  '';

  # mininetConfigStructured = with prev.lib.kernel; {
  #   BPF         = yes;
  #   BPF_SYSCALL = yes;
  #   USER_NS     = yes;
  #   NET_NS      = yes;
  #   NET_CLS_BPF = yes;
  #   NET_ACT_BPF = yes;
  #   BPF_JIT     = yes;
  #   BPF_EVENTS  = yes;
  #   VETH        = yes;
  # } 

  # might be needed for newer kernels to embed the module
  # NF_DEFRAG_IPV6 y
  # NF_NAT_IPV4 y
  # NF_NAT_IPV6 y
  # IPV6 y 
  ovsConfig = 
    #prev.pkgs.openvswitch.kernelExtraConfig or 
    ''
    # Can't be embedded; must be a module !?
    NF_INET y
    NF_CONNTRACK y

    NF_NAT y
    NF_NAT_IPV4 y

    # force it to yes as otherwise generate-config.pl seems to ignore it ?
    OPENVSWITCH y
  '';

  # CONFIG_BPF_JIT_ALWAYS_ON
  bpfConfig = 
    #prev.pkgs.linuxPackages.bcc.kernelExtraConfig or
  ''
    BPF y
    BPF_SYSCALL y
    NET_CLS_BPF y
    NET_ACT_BPF y
    BPF_JIT y
    BPF_EVENTS y
    KPROBE_EVENTS y
    BPF_EVENTS y
    KPROBES                y
    KPROBES_ON_FTRACE      y
    HAVE_KPROBES           y
    HAVE_KPROBES_ON_FTRACE y
    KPROBE_EVENTS          y
  '';


  # NET_CLS_ACT y


  kvmConfig = ''
      VIRTIO_PCI y
      VIRTIO_PCI_LEGACY y
      VIRTIO_BALLOON y
      VIRTIO_INPUT y
      VIRTIO_MMIO y
      VIRTIO_BLK y
      VIRTIO_NET y
      VIRTIO_CONSOLE y

      NET_9P_VIRTIO? y

      HW_RANDOM_VIRTIO y
      # VIRTIO_MMIO_CMDLINE_DEVICES

      # allow to capture netlink packets with wireshark !!
      # https://jvns.ca/blog/2017/09/03/debugging-netlink-requests/
      NLMON y
      TUN y

      # when run as -kernel, an embedded DHCP client is needed
      # need to get an ip
      IP_PNP y
      IP_PNP_DHCP y

      # this is the default NIC used by Qemu so we include it
      # not to have to set Qemu to e1000
      8139CP y
      8139TOO y
      8139TOO_PIO y
      # CONFIG_8139TOO_TUNE_TWISTER is not set
      8139TOO_8129 y
      # CONFIG_8139_OLD_RX_RESET is not set

      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y

      PATA_MARVELL y
      SATA_SIS y
      MD_RAID0 y

      # else qemu can't see the root filesystem when launched with -kenel
      EXT4_FS y

CRYPTO_USER_API_HASH y
SYSFS y
DEVTMPFS y
INOTIFY_USER y
SIGNALFD y
TIMERFD y
    EPOLL y
CRYPTO_SHA256 y
CRYPTO_HMAC y
TMPFS_POSIX_ACL y
SECCOMP y


    '';

    net9pConfig = ''

      # for qemu/libvirt shared folders
      NET_9P y
      # generates 
      # repeated question:   9P Virtio Transport at /nix/store/l6m0lgcrls587pz0i644jhfjk6lyj55s-generate-config.pl line 8
      NET_9P_DEBUG y
      9P_FS y

      # unsure
      # 9P_FS_SECURITY
      # 9P_FSCACHE
    '';

    localConfig = ''

      # LOCALVERSION -matt
      SYN_COOKIES n

      # poses problems see https://unix.stackexchange.com/questions/308870/how-to-load-compressed-kernel-modules-in-ubuntu
      # https://github.com/NixOS/nixpkgs/issues/40485
      MODULE_COMPRESS n
      MODULE_COMPRESS_XZ n 
    '';

    # For the tests don't forget to disable syn cooki
    mptcpConfig = ''
      
      # don't always exist !
      MPTCP_NETLINK y
      MPTCP y
      MPTCP_SCHED_ADVANCED y
      MPTCP_ROUNDROBIN y
      MPTCP_REDUNDANT y

      # this is a kernel I devised myself (hence the optional)
      MPTCP_PREVENANT? y

      IP_MULTIPLE_TABLES y

      # Enable advanced path-managers...
      MPTCP_PM_ADVANCED y
      MPTCP_FULLMESH y
      MPTCP_NDIFFPORTS y
      # ... but use none by default.
      # The default is safer if source policy routing is not setup.
      # DEFAULT_DUMMY y
      DEFAULT_MPTCP_PM fullmesh

      # MPTCP scheduler selection.
      # Disabled as the only non-default is the useless round-robin.

      # Smarter TCP congestion controllers
      TCP_CONG_LIA y
      TCP_CONG_OLIA y
      TCP_CONG_WVEGAS y
      TCP_CONG_BALIA y

      # tool to generate packets at very high speed in the kerne
      # NET_PKTGEN y
      NET_TCPPROBE y

      # http://www.draconyx.net/articles/net_drop_monitor-monitoring-packet-loss-in-the-linux-kernel.html
      # NET_DROP_MONITOR y
    '';

    # if not set it is converted to  https://lwn.net/Articles/434833/
    debugConfig = ''
      GDB_SCRIPTS y
      PRINTK_TIMES y
      # dynamic debug takes precedence over DEBUG_KERNEL http://blog.listnukira.com/Linux-Kernel-pr-debug-display/
      DYNAMIC_DEBUG n
      PREEMPT y
      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y
    '';

    # don't use the module
    # worried about
# warning: unused option: SQUASHFS_ZLIB
# warning: unused option: UBIFS_FS_ADVANCED_COMPR
# warning: unused option: USB_SERIAL_GENERIC

    persoConfig=''
      # netling debug/diagnostic
      NETLINK_DIAG y
    '';
  # must be used with ignoreConfigErrors in kernels
  # kernelExtraConfig=builtins.readFile ../extraConfig.nix;

in rec {
  # linux_4_9 = prev.linux_4_9.override({
  #   hostPlatform=test-platform;
  # });

  # need to override 

  # Thanks <3 ericson1234 for this command that overrides the current localSystem platform in order
  # to compile a custom kernel
  # nix-build -A linux_mptcp --arg 'localSystem' 'let top = (import <nixpkgs> { overlays= [ (import /home/teto/dotfiles/config/nixpkgs/overlays/kernels.nix)]; } ); in top.lib.recursiveUpdate (top.lib.systems.elaborate { system = builtins.currentSystem; }) { platform = top.test-platform; }' '<nixpkgs>' --show-trace
  mptcpKernelExtraConfig = kvmConfig
      + mptcpConfig
      + debugConfig
      + net9pConfig
      ;

  # TODO use this platform to build the various kernels
  # this won t be used by nixops ?
  test-platform =  {
    name="zizou";
    kernelAutoModules = false;
    kernelExtraConfig = mptcpKernelExtraConfig;
    ignoreConfigErrors = true;

    kernelPreferBuiltin = true;
  };

  # builtins.currentSystem returns "x86_64-linux"
  test-localSystem = let system = prev.lib.systems.elaborate { system = builtins.currentSystem; };
   in prev.lib.recursiveUpdate (system) { platform = system.platform // test-platform; };

  mptcp-custom = mptcp93;
   # prev.pkgs.linux_mptcp.override (  {
  #  });

  # improve the default mptcp config
  mptcp93 = prev.pkgs.linux_mptcp_93.override ({
    kernelPatches=[];
    # name="mptcp-override";
      # modDirVersion="4.9.60-matt";

      ignoreConfigErrors=true;
      autoModules = false;
      kernelPreferBuiltin = true;

      extraConfig=mptcpKernelExtraConfig;

  });

  # sandbox doesn't like
  # in a repl I see mptcp-local.stdenv.hostPlatform.platform
  mptcp93-local = mptcp-local;

  mptcp-local-stable = mptcp93.override ({

    # generates too many problems with nixops
    # src = builtins.fetchGit {
    #   url = /home/teto/mptcp;
    #   rev = "de77de05db08c6a76fe6dcea69c63a3ec563ee6f";
    # };

    src = prev.fetchFromGitHub {
      owner = "teto";
      repo = "mptcp";
      # url = /home/teto/mptcp;
      # rev = "c0b411996da32bf013af7ba39bd502eff60ac3ad";
      # sha256 = "07xrlpvl3hp5vypgzvnpz9m9wrjz51iqpgdi56jvqlzvhcymch7l";

      rev = "de77de05db08c6a76fe6dcea69c63a3ec563ee6f";
      sha256 = "07xrlpvl3hp5vypgzvnpz9m9wrjz51iqpgdi56jvqlzvhcymch7l";
    };

    # src = prev.fetchgitPrivate {
    #   # url = git://gitolite@iij_vm:mptcp.git;
    #   url = "ssh://gitolite@202.214.86.52:mptcp.git";
    #   rev = "de77de05db08c6a76fe6dcea69c63a3ec563ee6f";
    #   sha256 = "9999999999999999999999999999999999999999999999999999999999999999";
    # };

    modDirVersion="4.9.87";
    # modVersion="4.9.87";
    # modDirVersion="4.9.60-matt+";
    # modDirVersion="4.9.60-00010-g5a1ca10181c6";
    name="mptcp-local";

    # TODO might need to revisit
    ignoreConfigErrors=true;
    autoModules = false;
    kernelPreferBuiltin = true;

    # structuredExtraConfig = mininetConfigStructured;
    extraConfig = mptcpKernelExtraConfig + localConfig 
    + ovsConfig + bpfConfig + net9pConfig + mininetConfig
    # to prevent the "+" from being added to modDirVersion
    # + ''
    #   LOCALVERSION 
    # ''
    ;

     # if we dont want to have to regenerate it
      # configfile=

  });

  mptcp-local = mptcp-local-stable.override ({
      src = filter-src /home/teto/mptcp;
  });


  # linuxManualConfig is buggy see tracker
  # mptcp-manual = prev.linuxManualConfig {
  #   inherit (prev) stdenv hostPlatform;
  #   # inherit (linux_4_9) src;
  #   inherit (prev.linux_mptcp) version;
  #   # version = "${linux_4_9.version}-linuxkit";
  #   # configfile = fetchurl {
  #   #   url = https://raw.githubusercontent.com/linuxkit/linuxkit/cb1c74977297b326638daeb824983f0a2e13fdf2/kernel/kernel_config-4.9.x-x86_64;
  #   #   sha256 = "1lpz2q5mhvq7g5ys2s2zynibbxczqzscxbwxfbhb4mkkpps8dv08";
  #   # };

  #   modDirVersion="4.9.87";
  #   # modVersion="4.9.87";

  #   # or config.tpl
  #   # openvswitch won't work because of a mix between N/m
  #   configfile = /home/teto/mptcp/config_off;

  #   src= filter-src /home/teto/mptcp;
  #   allowImportFromDerivation = true;
  # };

  # mptcp-manual-dev = mptcp-manual.override {
 
  #   modDirVersion="4.9.87+";
  # };
  # mptcp-head = mptcp93.override ({

  # linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_mptcp-local = prev.pkgs.linuxPackagesFor mptcp-local;

  # hostPlatform = prev.hostPlatform.overrideAttrs(old: {
    # platform = test-platform;
  # });

  lkl_mptcp = prev.pkgs.lkl.overrideAttrs(old: {
    src = builtins.fetchGit file:///home/teto/lkl;
  });

  linux_mptcp_with_netlink = prev.linux_mptcp_93.override({
    src = prev.fetchFromGitHub {
      owner = "teto";
      repo = "mptcp";
      rev = "a7bdd7a8e6ebae940d6a38d023c31746979260a2";
      sha256 = "198ms07jm0kcg8m69y2fghvy6hdd5b4af4p2gjar3ibkxca1s6az";
    };
    # kernelPatches = [];
  });

  # my_lenovo_kernel = prev.linux_latest.override({
  my_lenovo_kernel = prev.linux_mptcp.override({
  # my_lenovo_kernel = self.linux_mptcp_with_netlink.override({
    # to be able to run as
    # preferBuiltin=true;
    ignoreConfigErrors=true;

    # structuredExtraConfig = mininetConfigStructured;

    # I don't really care here if openvswitch is as a module or not
    extraConfig = bpfConfig + net9pConfig + ''
      OPENVSWITCH m
    '' ;
  });

  # linux_test = prev.linux_4_12.override {
  #   ignoreConfigErrors=true;
  #   autoModules = false;
  #   kernelPreferBuiltin = true;
  #   structuredExtraConfig = mininetConfigStructured;
  # };



  # linux_latest_9p = prev.pkgs.linux_latest.override({
  #   extraConfig = ''
  #     NET_9P y
  #     NET_9P_VIRTIO y
  #     NET_9P_DEBUG y
  #   '';
  # });

}

