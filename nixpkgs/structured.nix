{ lib }:
with lib.kernel;
{
  mininetConfigStructured =  {
    BPF         = yes;
    BPF_SYSCALL = yes;
    NET_CLS_BPF = yes;
    NET_ACT_BPF = yes;
    BPF_JIT     = yes;
    USER_NS     = yes;
    NET_NS      = yes;
    BPF_EVENTS  = yes;
    VETH        = yes;
    NET_SCH_HTB = yes;
    NET_SCH_RED = yes;
    NET_SCH_SFB = yes;
    NET_SCH_SFQ = yes;
    NET_SCH_TBF = yes;
    NET_SCH_GRED = yes;
    NET_SCH_NETEM = yes;
    NET_SCH_INGRESS = yes;
    NET_CLS = yes;
    CFS_BANDWIDTH = yes;
  };


  bpfConfigStructured = {
    #prev.pkgs.linuxPackages.bcc.kernelExtraConfig or
    BPF = yes;
    BPF_SYSCALL = yes;
    NET_CLS_BPF = yes;
    NET_ACT_BPF = yes;
    BPF_JIT = yes;
    BPF_EVENTS = yes;
    KPROBES                = yes;
    KPROBES_ON_FTRACE      = yes;
    HAVE_KPROBES           = yes;
    HAVE_KPROBES_ON_FTRACE = yes;
    KPROBE_EVENTS          = yes;
  };

  # NET_CLS_ACT y




  kvmConfigStructured = {
    VIRTIO_PCI        = yes;
    VIRTIO_PCI_LEGACY = yes;
    VIRTIO_BALLOON    = yes;
    VIRTIO_INPUT      = yes;
    VIRTIO_MMIO       = yes;
    VIRTIO_BLK        = yes;
    VIRTIO_NET        = yes;
    VIRTIO_CONSOLE    = yes;

    NET_9P_VIRTIO = option yes;

      HW_RANDOM_VIRTIO     = yes;
      # VIRTIO_MMIO_CMDLINE_DEVICES

      # allow to capture netlink packets with wireshark !!
      # https://jvns.ca/blog/2017/09/03/debugging-netlink-requests/
      NLMON                = yes;
      TUN                  = yes;

      # when run as -kernel, an embedded DHCP client is needed
      # need to get an ip
      IP_PNP               = yes;
      IP_PNP_DHCP          = yes;

      # this is the default NIC used by Qemu so we include it
      # not to have to set Qemu to e1000
      "8139CP"             = yes;
      "8139TOO"            = yes;
      "8139TOO_PIO"        = yes;
      # CONFIG_8139TOO_TUNE_TWISTER is not set
      "8139TOO_8129"       = yes;
      # CONFIG_8139_OLD_RX_RESET is not set

      DEBUG_KERNEL         = yes;
      FRAME_POINTER        = yes;
      KGDB                 = yes;
      KGDB_SERIAL_CONSOLE  = yes;
      DEBUG_INFO           = yes;

      PATA_MARVELL         = yes;
      SATA_SIS             = yes;
      MD_RAID0             = yes;

      # else qemu can't see the root filesystem when launched with -kenel
      EXT4_FS              = yes;

      CRYPTO_USER_API_HASH = yes;
      SYSFS                = yes;
      DEVTMPFS             = yes;
      INOTIFY_USER         = yes;
      SIGNALFD             = yes;
      TIMERFD              = yes;
          EPOLL            = yes;
      CRYPTO_SHA256        = yes;
      CRYPTO_HMAC          = yes;
      TMPFS_POSIX_ACL      = yes;
      SECCOMP              = yes;
};

    net9pConfigStructured = {

      # for qemu/libvirt shared folders
      NET_9P = yes;
      # generates 
      # repeated question:   9P Virtio Transport at /nix/store/l6m0lgcrls587pz0i644jhfjk6lyj55s-generate-config.pl line 8
      NET_9P_DEBUG = yes;
      "9P_FS" = yes;
      "9P_FS_POSIX_ACL" = yes;

      # unsur 
      # 9P_FS_SECURITY
      # 9P_FSCACHE
    };

    lklConfig = {
      # make ARCH=lkl 
      LKL_HOST = yes;
      LKL_STATIC = yes;
      LKL_SHARED = yes;
      # LKL example tools
      LKL_FUSE = yes;
      LKL_CPTOFS = yes;
      LKL_FS2TAR = yes;
      LKL_HIJACK = yes;
    };

    localConfigStructured = {

      # needed for tc-bpf
      CRYPTO_USER_API=yes;
      CRYPTO_USER_API_HASH=yes;

      # LOCALVERSION -matt
      # LOCALVERSION ""
      LOCALVERSION_AUTO = no;
      # EXTRAVERSION ""
      SYN_COOKIES = no;

      # poses problems see https://unix.stackexchange.com/questions/308870/how-to-load-compressed-kernel-modules-in-ubuntu
      # https://github.com/NixOS/nixpkgs/issues/40485
      MODULE_COMPRESS = no;
      MODULE_COMPRESS_XZ = no;
    };

    mptcpConfigStructured = {
      
      # don't always exist !
      MPTCP_NETLINK = yes;
      MPTCP = yes;
      MPTCP_SCHED_ADVANCED = yes;
      MPTCP_ROUNDROBIN = yes;
      MPTCP_REDUNDANT = yes;

      # this is a kernel I devised myself (hence the optional)
      MPTCP_PREVENANT = optional yes;
      MPTCP_OWD_COMPENSATE = optional yes;

      IP_MULTIPLE_TABLES = yes;

      # Enable advanced path-managers...
      MPTCP_PM_ADVANCED = yes;
      MPTCP_FULLMESH = yes;
      MPTCP_NDIFFPORTS = yes;
      # ... but use none by default.
      # The default is safer if source policy routing is not setup.
      # DEFAULT_DUMMY = yes;
      DEFAULT_MPTCP_PM = "fullmesh";

      # MPTCP scheduler selection.
      # Disabled as the only non-default is the useless round-robin.

      # Smarter TCP congestion controllers
      TCP_CONG_LIA = yes;
      TCP_CONG_OLIA = yes;
      TCP_CONG_WVEGAS = yes;
      TCP_CONG_BALIA = yes;

      # tool to generate packets at very high speed in the kerne
      # NET_PKTGEN = yes;
      NET_TCPPROBE = yes;

      # http://www.draconyx.net/articles/net_drop_monitor-monitoring-packet-loss-in-the-linux-kernel.html
      # NET_DROP_MONITOR = yes;
    };

    debugConfigStructured = {
      GDB_SCRIPTS         = yes;
      PRINTK_TIMES        = yes;
      # dynamic debug takes precedence over DEBUG_KERNEL http://blog.listnukira.com/Linux-Kernel-pr-debug-display/
      DYNAMIC_DEBUG       = no;
      PREEMPT             = yes;
      DEBUG_KERNEL        = yes;
      FRAME_POINTER       = yes;
      KGDB                = yes;
      KGDB_SERIAL_CONSOLE = yes;
      DEBUG_INFO          = yes;
    };
  }
