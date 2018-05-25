self: super:
let
    # todo remove tags
    filter-src = builtins.filterSource (p: t:
    let baseName = baseNameOf p;
    in super.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

  # potentially interesting
  # CONFIG_NLMON is not set
  # KERN_DEFAULT "d" The default kernel loglevel
  # KERN_CONT "" "continued" line of log printout (only done after a line that had no enclosing)
  # todo we could use isYes
  # system.requiredKernelConfig

  mininetConfig = ''
    VETH y
    NET_NS y

    # Can't be embedded; must be a module !?
    OPENVSWITCH y
  '';


  kvmConfig = ''
      VIRTIO_PCI y
      VIRTIO_PCI_LEGACY y
      VIRTIO_BALLOON y
      VIRTIO_INPUT y
      VIRTIO_MMIO y
      VIRTIO_BLK y
      VIRTIO_NET y
      VIRTIO_CONSOLE y
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

      # for qemu/libvirt shared folders
      NET_9P y
      # generates 
      # repeated question:   9P Virtio Transport at /nix/store/l6m0lgcrls587pz0i644jhfjk6lyj55s-generate-config.pl line 8
      # NET_9P_VIRTIO y
      NET_9P_DEBUG y
      9P_FS y

      # unsure
      # 9P_FS_SECURITY
      # 9P_FSCACHE

    '';
    # system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled
    #   [ "DEVTMPFS" "CGROUPS" "INOTIFY_USER" "SIGNALFD" "TIMERFD" "EPOLL" "NET"
    #     "SYSFS" "PROC_FS" "FHANDLE" "CRYPTO_USER_API_HASH" "CRYPTO_HMAC"
    #     "CRYPTO_SHA256" "DMIID" "AUTOFS4_FS" "TMPFS_POSIX_ACL"
    #     "TMPFS_XATTR" "SECCOMP"
    #   ];

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
      MPTCP_ROUNDROBIN m
      MPTCP_REDUNDANT m

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
      TCP_CONG_LIA m
      TCP_CONG_OLIA m
      TCP_CONG_WVEGAS m
      TCP_CONG_BALIA m

      # tool to generate packets at very high speed in the kerne
      # NET_PKTGEN y
      NET_TCPPROBE y

      # http://www.draconyx.net/articles/net_drop_monitor-monitoring-packet-loss-in-the-linux-kernel.html
      # NET_DROP_MONITOR y
    '';

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

      NET_SCH_NETEM y
      NETLINK_DIAG y
      L2TP_IP m
    '';
  # must be used with ignoreConfigErrors in kernels
  # kernelExtraConfig=builtins.readFile ../extraConfig.nix;

in rec {
  # linux_4_9 = super.linux_4_9.override({
  #   hostPlatform=test-platform;
  # });

  # Thanks <3 ericson1234 for this command that overrides the current localSystem platform in order
  # to compile a custom kernel
  # nix-build -A linux_mptcp --arg 'localSystem' 'let top = (import <nixpkgs> { overlays= [ (import /home/teto/dotfiles/config/nixpkgs/overlays/kernels.nix)]; } ); in top.lib.recursiveUpdate (top.lib.systems.elaborate { system = builtins.currentSystem; }) { platform = top.test-platform; }' '<nixpkgs>' --show-trace
  mptcpKernelExtraConfig = kvmConfig
      + mptcpConfig
      + debugConfig
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
  test-localSystem = let system = super.lib.systems.elaborate { system = builtins.currentSystem; };
   in super.lib.recursiveUpdate (system) { platform = system.platform // test-platform; };

  mptcp-custom = mptcp93;
   # super.pkgs.linux_mptcp.override (  {
  #  });

  # improve the default mptcp config
  mptcp93 = super.pkgs.linux_mptcp.override (  {
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

  mptcp-local =
  mptcp93.override ({
      src= super.lib.cleanSource /home/teto/mptcp;
      # modDirVersion="4.9.87";
      modVersion="4.9.87";
      # modDirVersion="4.9.60-matt+";
      # modDirVersion="4.9.60-00010-g5a1ca10181c6";
      name="mptcp-local";
      # hostPlatform=test-localSystem;

      # TODO might need to revisit
      ignoreConfigErrors=true;
      autoModules = false;
      kernelPreferBuiltin = true;

      # configfile = "/home/teto/mptcp/config.tpl";
      # configfilename = /home/teto/dotfiles/kernel_config.mptcp;
      # src= super.fetchgitLocal "/home/teto/mptcp";
      # src = fetchGitHashless {
      #   # rev="owd93";
      #   branchName="owd93";
      #   # url= file:///home/teto/mptcp;
      #   url= "/home/teto/mptcp";
      # };
      enableParallelBuilding=true;

      extraConfig=mptcpKernelExtraConfig + localConfig + mininetConfig;

      # if we dont want to have to regenerate it
      # configfile=

    });


  # linuxManualConfig is buggy see tracker
  mptcp-manual = super.linuxManualConfig {
    inherit (super) stdenv hostPlatform;
    # inherit (linux_4_9) src;
    inherit (super.linux_mptcp) version;
    # version = "${linux_4_9.version}-linuxkit";
    # configfile = fetchurl {
    #   url = https://raw.githubusercontent.com/linuxkit/linuxkit/cb1c74977297b326638daeb824983f0a2e13fdf2/kernel/kernel_config-4.9.x-x86_64;
    #   sha256 = "1lpz2q5mhvq7g5ys2s2zynibbxczqzscxbwxfbhb4mkkpps8dv08";
    # };

    modDirVersion="4.9.87";
    # modVersion="4.9.87";

    # or config.tpl
    configfile = /home/teto/mptcp/config_off;

    src= filter-src /home/teto/mptcp;
    allowImportFromDerivation = true;
  };

  mptcp-manual-dev = mptcp-manual.override {
 
    modDirVersion="4.9.87+";
  };
  # mptcp-head = mptcp93.override ({

  # linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_mptcp-local = super.pkgs.linuxPackagesFor mptcp-local;

  # hostPlatform = super.hostPlatform.overrideAttrs(old: {
    # platform = test-platform;
  # });

  lkl_mptcp = super.pkgs.lkl.overrideAttrs(old: {
    src=builtins.fetchGit file:///home/teto/lkl;
  });


  # linux_latest_9p = super.pkgs.linux_latest.override({
  #   extraConfig = ''
  #     NET_9P y
  #     NET_9P_VIRTIO y
  #     NET_9P_DEBUG y
  #   '';
  # });

}

