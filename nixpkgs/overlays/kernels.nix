self: prev:
  # with prev.lib.kernel;


# DYNAMIC_DEBUG n is important !!

let




  # shellHook = ''
  #   alias xconfig="make xconfig KCONFIG_CONFIG=build/.config"
  #   alias menuconfig="make menuconfig KCONFIG_CONFIG=build/.config"
  # '';

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
  structuredConfigs = import ../structured.nix { inherit (prev) lib; };

  kernelPatch0 = rec {
    name = "xen-netfront_update_features_after_registering_netdev";
    extraStructuredConfig = {
      # MMC_BLOCK_MINORS   = freeform "44";
      # EXT4_ENCRYPTION   = option ((if (versionOlder version "4.8") then module else yes));
      # EXT4_ENCRYPTION   = option ((if (versionOlder version "4.8") then module else yes));

      # FS_ENCRYPTION   = mkMerge [ { optional = true; } (whenAtLeast "4.9" module) ];
    };
    patch = null;
  };

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

  # don't forget to suppress LOCALVERSION 
  # LOCALVERSION_AUTO

  
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
    CFS_BANDWIDTH y
  '';


    # NET_9P_DEBUG y
    net9pConfig = ''

      # for qemu/libvirt shared folders
      NET_9P y
      # generates 
      # repeated question:   9P Virtio Transport at /nix/store/l6m0lgcrls587pz0i644jhfjk6lyj55s-generate-config.pl line 8
      9P_FS y
      9P_VIRTIO? y

      # POSIX might slow down the whole thing
      9P_FS_POSIX_ACL y

      # unsur 
      # 9P_FS_SECURITY
      # 9P_FSCACHE
    '';

    # if not set it is converted to  https://lwn.net/Articles/434833/
    # CONSOLE_LOGLEVEL_DEFAULT=7
    # CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
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

    persoConfig=''
      # netling debug/diagnostic
      NETLINK_DIAG y
    '';

    # to prevent kernel from adding a `+` when in a git repository
    localConfig = ''

      # LOCALVERSION -matt
      # LOCALVERSION ""
      LOCALVERSION_AUTO n
      # EXTRAVERSION ""
      SYN_COOKIES n

      # poses problems see https://unix.stackexchange.com/questions/308870/how-to-load-compressed-kernel-modules-in-ubuntu
      # https://github.com/NixOS/nixpkgs/issues/40485
      MODULE_COMPRESS n
      MODULE_COMPRESS_XZ n 
    '';

    # since 4.14 we have L2TP  replace:
    # L2TP_V3                     = yes;
    # L2TP_IP                     = module;
    # L2TP_ETH                    = module;
    vpnConfig = ''
      L2TP y
    '';

    # For the tests don't forget to disable syn cooki
    mptcpConfig = ''
      # increase ring kernel buffer size
      LOG_BUF_SHIFT 22
      IPV6 y 

      # don't always exist !
      # netlink can't be compiled as a module for 0.94 else it triggers
      # ERROR: "tcp_send_active_reset" [net/mptcp/mptcp_netlink.ko] undefined!
      # ERROR: "tcp_reset" [net/mptcp/mptcp_netlink.ko] undefined!
      # ERROR: "mptcp_send_active_reset" [net/mptcp/mptcp_netlink.ko] undefined!
      # ERROR: "mptcp_hash_find" [net/mptcp/mptcp_netlink.ko] undefined!
      MPTCP_NETLINK? y
      MPTCP y
      MPTCP_SCHED_ADVANCED y
      MPTCP_ROUNDROBIN y
      MPTCP_REDUNDANT y

      # this is a kernel I devised myself (hence the optional)
      MPTCP_PREVENANT? y
      MPTCP_OWD_COMPENSATE? y

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


  # might be needed for newer kernels to embed the module
  # NF_DEFRAG_IPV6 y
  # NF_NAT_IPV4 y
  # NF_NAT_IPV6 y
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
    BPF_JIT_ALWAYS_ON y
    NETFILTER_XTABLES y
    NETFILTER_XT_MATCH_BPF y
    BPF_SYSCALL y
    NET_CLS_BPF y
    NET_ACT_BPF y
    BPF_JIT y
    BPF_EVENTS y
    KPROBE_EVENTS y
    KPROBES                y
    KPROBES_ON_FTRACE      y
    HAVE_KPROBES           y
    HAVE_KPROBES_ON_FTRACE y
    KPROBE_EVENTS          y
  '';

  kvmConfig = ''
      VIRTIO y
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

      # PATA_MARVELL y # needs SATA_SIS
      # SATA_SIS y # might cause problems with more recent kernels
      # MD_RAID0 y

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



    # don't use the module
    # worried about
# warning: unused option: SQUASHFS_ZLIB
# warning: unused option: UBIFS_FS_ADVANCED_COMPR
# warning: unused option: USB_SERIAL_GENERIC
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


  # mptcpStructuredExtraConfig = mkMerge [
  #   kvmConfigStructured
  #   debugConfigStructured
  #   net9pConfig
  # ];

  # improve the default mptcp config
  mptcp93 = prev.linux_mptcp_93.override ({
      kernelPatches=[];
      ignoreConfigErrors=true;
      autoModules = false;
      kernelPreferBuiltin = true;
      extraConfig = mptcpKernelExtraConfig;
  });

  mptcp94 = (prev.linux_mptcp.override ({
      kernelPatches=[];
      ignoreConfigErrors=true;
      autoModules = false;
      kernelPreferBuiltin = true;
      extraConfig = mptcpKernelExtraConfig;
    }));
    # .overrideAttrs(o: {
    # nativeBuildInputs=o.nativeBuildInputs ++ (with prev.pkgs; [ pkgconfig ncurses qt5.qtbase ]);
  # });

# sandbox doesn't like
  # in a repl I see mptcp-local.stdenv.hostPlatform.platform

  mptcp94-local-stable = mptcp94.override ({
    # TODO try to use in private mode
    # generates too many problems with nixops
    # src = builtins.fetchGit {
    #   url = "ssh://gitolite@202.214.86.52:mptcp.git";
    # url = /home/teto/mptcp;
    #   rev = "de77de05db08c6a76fe6dcea69c63a3ec563ee6f";
    # };

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

      rev = "c1f91c32ebd1d4bf38fc17756c61441c925135cb";
      sha256 = "061zzlkjm3i1nhgnz3dfhbshjicrjc5ydwy6hr5l6y8cl2ps2iwf";
    };

    # src = prev.fetchgitPrivate {
    #   # url = git://gitolite@iij_vm:mptcp.git;
    #   url = "ssh://gitolite@202.214.86.52:mptcp.git";
    #   rev = "de77de05db08c6a76fe6dcea69c63a3ec563ee6f";
    #   sha256 = "9999999999999999999999999999999999999999999999999999999999999999";
    # };

    modDirVersion="4.9.87";
    modVersion="4.9.87";
    # modDirVersion="4.9.60-matt+";
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

  # "cc10d7c54daa1dd6bd00d24619ed4eb6be8f5691";
  # linux_mptcp_with_netlink = (prev.linux_mptcp_94 or prev.linux_mptcp).override({

  # })
  linux_mptcp_with_netlink = (prev.linux_mptcp_94 or prev.linux_mptcp).override({
    src = prev.fetchFromGitHub {
      owner = "teto";
      repo = "mptcp";
      rev = "a7bdd7a8e6ebae940d6a38d023c31746979260a2";
      sha256 = "198ms07jm0kcg8m69y2fghvy6hdd5b4af4p2gjar3ibkxca1s6az";

      # fetchSubmodules = true;
    };
    # kernelPatches = [];
    # netlink won't load as a module
    # kernelPreferBuiltin = true;
    # extraConfig = mptcpKernelExtraConfig;
    # structuredExtraConfig = {
    #   MPTCP_NETLINK = yes;
    # };
  });

  # my_lenovo_kernel = prev.linux_latest.override({
  # my_lenovo_kernel = prev.linux_mptcp_94.override({
  my_lenovo_kernel = self.linux_mptcp_with_netlink.override({

    modDirVersion="4.14.24";
    # to be able to run as
    # preferBuiltin=true;
    ignoreConfigErrors=true;
    # src = prev.fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcp";
    #   rev = "a7bdd7a8e6ebae940d6a38d023c31746979260a2";
    #   sha256 = "198ms07jm0kcg8m69y2fghvy6hdd5b4af4p2gjar3ibkxca1s6az";
    # };

    # structuredExtraConfig = mininetConfigStructured;

    # I don't really care here if openvswitch is as a module or not
    # kvmConfig +
    extraConfig = mptcpConfig + bpfConfig + net9pConfig + ''
      OPENVSWITCH m
    '' ;
  });

  
  


  # hardenedPackages = hardenedLinuxPackagesFor prev.linux_mptcp;

    linux_test = let 
      # mininetConfigStructured = {};
      configStructured = with prev.lib.kernel; with structuredConfigs; prev.lib.mkMerge [ 
        # structuredConfigs.kvmConfigStructured
        bpfConfigStructured
        debugConfigStructured 
        mininetConfigStructured 
        # kvmConfigStructured 
        mptcpConfigStructured 
        # just try to contradict common-config settings
        # { USB_DEBUG = optional yes; }

        # common-config.nix default is 32, shouldn't trigger any error
        # The option `settings.MMC_BLOCK_MINORS.freeform' has conflicting definitions, in `<unknown-file>' and `<unknown-file>'
        # { MMC_BLOCK_MINORS   = freeform "32"; }
        # { MMC_BLOCK_MINORS   = freeform "64"; }

        # mandatory should win by default
        # { USB_DEBUG = option yes;}
        # { USB_DEBUG = yes;}

        # default for "8139TOO_PIO" is no
        # { "8139TOO_PIO"  = yes; }


      ];
    in
    prev.linux_latest.override {
      kernelPreferBuiltin = true;
      structuredExtraConfig = configStructured;
  };

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

