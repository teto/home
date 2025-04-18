{ lib, libk }:

with libk;
# with lib.kernel;
with lib.modules;
{
  _file = "overlay/kernel/structured.nix";

  strongswanStructured = {
    XFRM_USER = yes;
    NET_KEY = yes;
    INET = yes;
    IP_ADVANCED_ROUTER = yes;
    IP_MULTIPLE_TABLES = yes;
    INET_AH = yes;
    INET_ESP = yes;
    INET_IPCOMP = yes;
    INET_XFRM_MODE_TRANSPORT = yes;
    INET_XFRM_MODE_TUNNEL = yes;
    INET_XFRM_MODE_BEET = yes;

    # IPV6
    # INET6_AH
    # INET6_ESP
    # INET6_IPCOMP
    # INET6_XFRM_MODE_TRANSPORT
    # INET6_XFRM_MODE_TUNNEL
    # INET6_XFRM_MODE_BEET
    # IPV6_MULTIPLE_TABLES

    NETFILTER = yes;
    NETFILTER_XTABLES = yes;
    NETFILTER_XT_MATCH_POLICY = yes;
  };

  mininetConfigStructured = {
    BPF = yes;
    BPF_SYSCALL = yes;
    # NET_CLS_BPF = yes;
    # NET_ACT_BPF = yes;
    BPF_JIT = yes;
    USER_NS = yes;
    NET_NS = yes;
    BPF_EVENTS = yes;
    VETH = yes;
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
    IP_ADVANCED_ROUTER = yes; # to enable net.ipv4.ip_forward
    IP_ROUTE_VERBOSE = yes;

    # INET_XFRMODE_BEET= yes;
    PACKET_DIAG = yes;
    UNIX = yes;
    INET_DIAG = yes;
    INET_TCP_DIAG = yes;
    INET_UDP_DIAG = yes;
    INET_RAW_DIAG = yes;
    # CONFIG_INET_DIAG_DESTROY is not set
  };

  ovsConfigStructured = {
    #prev.pkgs.openvswitch.kernelExtraConfig or
    # Can't be embedded; must be a module !?
    NF_INET = yes;
    NF_CONNTRACK = yes;

    NF_NAT = yes;
    NF_NAT_IPV4 = yes;
    # added for mptcp trunk
    # IPV6  = no;
    # NF_NAT_IPV6 = no;
    NETFILTER = yes;
    NETFILTER_CONNCOUNT = yes;
    NETFILTER_ADVANCED = yes;

    NFT_CONNLIMIT = yes;
    NF_TABLES = yes;

    # force it to = yes;es as otherwise generate-config.pl seems to ignore it ?
    # NET_NSH = yes;
    OPENVSWITCH = yes;
  };

  soundConfig = {
    SND_HWDEP = yes;
    SND_OSSEMUL = yes;
    SND_MIXER_OSS.tristate = "m";
    SND_PCM_OSS.tristate = "m";
    SND_PCM_OSS_PLUGINS = yes;
    SND_PCM_TIMER = yes;
    SND_HRTIMER.tristate = "m";
    SND_DYNAMIC_MINORS = yes;
    # SND_MAX_CARDS=32
    SND_SUPPORT_OLD_API = yes;
    SND_PROC_FS = yes;
    SND_VERBOSE_PROCFS = yes;

  };

  bpfConfigStructured = {
    #prev.pkgs.linuxPackages.bcc.kernelExtraConfig or
    BPF = yes;
    BPF_JIT_ALWAYS_ON = yes;
    NETFILTER_XTABLES = yes;
    NETFILTER_XT_MATCH_BPF = yes;
    BPF_SYSCALL = yes;
    # NET_CLS_BPF = yes;
    # NET_ACT_BPF = yes;
    HAVE_EBPF_JIT = yes;
    BPF_JIT = yes;
    BPF_EVENTS = yes;
    KPROBES = yes;
    KPROBES_ON_FTRACE = yes;
    HAVE_KPROBES = yes;
    HAVE_KPROBES_ON_FTRACE = yes;
    KPROBE_EVENTS = yes;
  };

  noChelsio = {

    CRYPTO_DEV_CHELSIO_TLS = option no;
    CRYPTO_DEV_CHELSIO = option no;
    # CHELSIO_T4? n
    NET_VENDOR_CHELSIO = no;
    # CHELSIO_T1? no
    # CHELSIO_T2? no
    # CHELSIO_T3? no
    # CHELSIO_T4? no
    CHELSIO_LIB = no;
    # to prevent selection of NET_VENDOR_CHELSIO
    # SCSI_LOWLEVEL = no;
    CHELSIO_TLS = no;
  };

  # CONFIG_INITRAMFS_SOURCE=""
  # TODO https://www.oipapio.com/question-3244544

  # really good reference
  # https://www.linux-kvm.org/page/Tuning_Kernel

  # Useful options for the kernel of the host
  paravirtualization_host = {
    KVM_INTEL = option module;
    KVM_AMD = option module;

    # VHOST_NET ne se lance pas tout seul
    VHOST_NET = module; # vhost_net should appear in lsmod
    HPET = yes; # High Precision Event Timer
    TRANSPARENT_HUGEPAGE = yes;
    CGROUPS = yes;
    COMPACTION = yes; # compact of memory for the allocation of huge pages
  };

  # virtio etc.
  # see linux-4.19.80/kernel/configs/kvm_guest.config
  # override defconfig
  # make O=../obj/x86_64 kvmconfig
  # http://www.gorecursion.com/virtualization/2016/12/17/buildkernel.html
  # scripts/kconfig/merge_config.sh we could provide several snippets
  # TODO find how it works
  paravirtualization_guest = {
    # FIREWIRE = no;
    # MACINTOSH_DRIVERS = no;
    VETH = yes;
    TTY = yes;
    VIRTIO = yes; # should be selected by the rest
    # no
    VSOCKETS = yes;
    VHOST_VSOCK = yes;
    CAIF_VIRTIO = no;
    PCCARD = no;
    CRYPTO_DEV_VIRTIO = yes; # by default a module
    # SCSI_VIRTIO    = yes; # appears first
    S390_GUEST = yes;
    VIRTIO_VSOCKETS = yes;
    VIRTIO_VSOCKETS_COMMON = yes;
    VIRTIO_PCI = yes; # should selection VIRTIO
    VIRTIO_PCI_LEGACY = yes;
    VIRTIO_BALLOON = yes;
    VIRTIO_INPUT = yes;
    VIRTIO_MMIO = yes;
    # VIRTIO_MMIO_CMDLINE_DEVICES = no;
    VIRTIO_BLK = yes;
    VIRTIO_NET = yes;
    RPMSG_VIRTIO = yes;
    REMOTEPROC = no;
    VIRTIO_CONSOLE = yes;
    NETWORK_FILESYSTEMS = yes;
    # yes when
    PACKET = yes;
    PACKET_DIAG = yes;

    PARAVIRT_GUEST = yes;
    PARAVIRT_DEBUG = yes;

    HW_RANDOM = yes; # Means module or yes
    HW_RANDOM_VIRTIO = yes; # Means module or yes
    DRM_VIRTIO_GPU = mkForce no;

    # to fix a build issue :s
    # depends on INET_DIAG that defaults to yes
    # INET_TCP_DIAG = yes;

    INET = yes;
    SERIAL_8250 = yes;
    SERIAL_8250_CONSOLE = yes;
    PARAVIRT = yes;

    # This enables automatic configuration of IP addresses of devices and
    # of the routing table during kernel boo
    IP_PNP = yes;
    IP_PNP_DHCP = yes;

    # NET=y
    # NET_CORE=y
    # NETDEVICES=y
    # BLOCK=y
    # BLK_DEV=y
    # NETWORK_FILESYSTEMS=y
    # INET=y
    # TTY=y
    # SERIAL_8250=y
    # SERIAL_8250_CONSOLE=y
    # IP_PNP=y
    # IP_PNP_DHCP=y
    # BINFMT_ELF=y
    # PCI=y
    # PCI_MSI=y
    # DEBUG_KERNEL=y
    # VIRTUALIZATION=y
    # HYPERVISOR_GUEST=y
    # PARAVIRT=y
    # KVM_GUEST=y
    # S390_GUEST=y
    # VIRTIO=y
    # VIRTIO_PCI=y
    # VIRTIO_BLK=y
    # VIRTIO_CONSOLE=y
    # VIRTIO_NET=y
    # 9P_FS=y
    # NET_9P=y
    # NET_9P_VIRTIO=y
    # SCSI_LOWLEVEL=y
    # SCSI_VIRTIO=y
    # VIRTIO_INPUT=y
    # DRM_VIRTIO_GPU=y

  };

  # TODO cleanup to retain kvm specific config
  kvmConfigStructured = {
    KVM_CLOCK = yes;
    KVM_GUEST = yes;
    MEMORY_HOTREMOVE = yes;

    # all the VIRTIO that appears in "selected by" when you open
    # make menuconfig
    PCI = yes;
    VOP = option no;
    SCIF_BUS = option no;
    # CAIF = option no; # stands for "Communication CPU to Application CPU Interface"
    CAIF = no; # stands for "Communication CPU to Application CPU Interface"
    INTEL_MIC_CARD = option yes;
    REMOTEPROC = option yes;
    # VIRTIO_MENU y

    VIRTIO = yes;
    VIRTIO_PCI = yes;
    VIRTIO_PCI_LEGACY = yes;
    VIRTIO_BALLOON = yes;
    VIRTIO_INPUT = yes;
    VIRTIO_MMIO = yes;
    # VIRTIO_MMIO = no;
    VIRTIO_BLK = yes;
    VIRTIO_NET = yes;
    RPMSG_VIRTIO = option yes; # Remote Processor Messaging
    VIRTIO_CONSOLE = yes;
    # DRM_VIRTIO_GPU    = yes;

    # if we go for paravirtualized then we dont need ide/sata
    IDE = mkForce yes;
    IDE_GENERIC = mkForce yes;
    BLK_DEV_IDE_SATA = yes;
    BLK_DEV_GENERIC = yes;
    IDE_GD_ATAPI = yes;
    BLK_DEV_SR = yes;
    # MD=> MULTI device
    PCMCIA = yes;

    # BLK_DEV_MD = no;
    # PARIDE = mkForce yes;

    # DM => DEVICE MAPPER (lvm
    BLK_DEV_DM_BUILTIN = no;

    SCSI = yes;
    # SCSI_VIRTIO    = yes;

    HW_RANDOM = yes; # Means module or yes
    HW_RANDOM_VIRTIO = yes; # Means module or yes
    # VIRTIO_MMIO_CMDLINE_DEVICES

    # allow to capture netlink packets with wireshark !!
    # https://jvns.ca/blog/2017/09/03/debugging-netlink-requests/
    NLMON = yes;
    TUN = yes;

    # when run as -kernel, an embedded DHCP client is needed
    # need to get an ip
    # should not be necessary anymore now that we have a qemu agent in nixops
    IP_PNP = mkForce yes;
    IP_PNP_DHCP = yes;

    # this is the default NIC used by Qemu so we include it
    # not to have to set Qemu to e1000
    "8139CP" = yes;
    "8139TOO" = yes;
    # "8139TOO_PIO"        = yes;  # default is no
    # CONFIG_8139TOO_TUNE_TWISTER is not set
    "8139TOO_8129" = yes;
    # CONFIG_8139_OLD_RX_RESET is not set

    # PATA_MARVELL         = yes;
    # SATA_SIS             = yes;
    # MD_RAID0             = yes;

    # else qemu can't see the root filesystem when launched with -kenel
    EXT4_FS = yes;

    CRYPTO_USER_API_HASH = yes;
    SYSFS = yes;
    DEVTMPFS = yes;
    INOTIFY_USER = yes;
    SIGNALFD = yes;
    TIMERFD = yes;
    EPOLL = yes;
    CRYPTO_SHA256 = yes;
    CRYPTO_HMAC = yes;
    TMPFS_POSIX_ACL = yes;
    SECCOMP = yes;
  };

  net9p = {

    # for qemu/libvirt shared folders
    NET_9P = yes;
    # repeated question:   9P Virtio Transport at /nix/store/l6m0lgcrls587pz0i644jhfjk6lyj55s-generate-config.pl line 8
    "9P_FS" = yes;
    # "9P_VIRTIO" = option yes;
    NET_9P_DEBUG = yes;

    NET_9P_VIRTIO = yes; # depends on VIRTIO
    # POSIX might slow down the whole thing
    "9P_FS_POSIX_ACL" = yes;

    # to be able to use capabilities on shared folders
    "9P_FS_SECURITY" = yes;
    "9P_FSCACHE" = yes;
    FSCACHE = yes;
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

    #
    DRM_NOUVEAU = no;

    # needed for tc-bpf
    CRYPTO_USER_API = yes;
    CRYPTO_USER_API_HASH = yes;

    # TODO works only if > 4.14
    L2TP = yes;

    # LOCALVERSION -matt
    # LOCALVERSION ""
    LOCALVERSION_AUTO = no;
    # EXTRAVERSION ""
    SYN_COOKIES = lib.modules.mkForce no;

    # TODO reenable ?
    # poses problems see https://unix.stackexchange.com/questions/308870/how-to-load-compressed-kernel-modules-in-ubuntu
    # https://github.com/NixOS/nixpkgs/issues/40485
    MODULE_COMPRESS = mkForce no;
    MODULE_COMPRESS_XZ = mkForce no;
    KERNEL_XZ = mkForce no;
  };

  mptcpConfigStructured = {

    # don't always exist !
    MPTCP_NETLINK = module;
    MPTCP = yes;
    MPTCP_SCHED_ADVANCED = yes;
    MPTCP_ROUNDROBIN = yes;
    MPTCP_REDUNDANT = yes;

    # this is a kernel I devised myself (hence the optional)
    MPTCP_PREVENANT = option yes;
    MPTCP_OWD_COMPENSATE = option yes;

    IP_MULTIPLE_TABLES = yes;
    IP_ROUTE_MULTIPATH = yes;

    # Enable advanced path-managers...
    MPTCP_PM_ADVANCED = yes;
    MPTCP_FULLMESH = yes;
    MPTCP_NDIFFPORTS = yes;
    # ... but use none by default.
    # The default is safer if source policy routing is not setup.
    # DEFAULT_DUMMY = yes;
    DEFAULT_MPTCP_PM.freeform = "fullmesh";

    # MPTCP scheduler selection.
    # Disabled as the only non-default is the useless round-robin.

    # Smarter TCP congestion controllers
    TCP_CONG_LIA = module;
    TCP_CONG_OLIA = module;
    TCP_CONG_WVEGAS = module;
    TCP_CONG_BALIA = yes;

    # tool to generate packets at very high speed in the kerne
    # NET_PKTGEN = yes;

    # http://www.draconyx.net/articles/net_drop_monitor-monitoring-packet-loss-in-the-linux-kernel.html
    # NET_DROP_MONITOR = yes;
  };

  # remove some superfluous
  minimalConfig = {

    INPUT_TOUCHSCREEN = no;
    INFINIBAND = no;
    DRM_RADEON = no;
    # mkForce ?
    IPV6 = no;
  };

  # if not set it is converted to  https://lwn.net/Articles/434833/
  # CONSOLE_LOGLEVEL_DEFAULT=7
  # CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
  debugConfigStructured = {
    GDB_SCRIPTS = yes;
    PRINTK_TIMES = yes;
    # dynamic debug takes precedence over DEBUG_KERNEL http://blog.listnukira.com/Linux-Kernel-pr-debug-display/
    # DYNAMIC_DEBUG       = lib.mkForce no;
    # PREEMPT caused a problem when trying to insert modules
    # let's keep the  default here
    # PREEMPT             = yes;
    DEBUG_KERNEL = yes;
    FRAME_POINTER = yes;
    KGDB = yes;
    KGDB_SERIAL_CONSOLE = yes;
    DEBUG_INFO = lib.mkForce yes;

    # CONFIG_DEBUG_INFO_REDUCED is not set
    # CONFIG_DEBUG_INFO_SPLIT is not set
  };

  persoConfig = {
    # netling debug/diagnostic
    NET_DEVLINK = yes; # can be used with userspace program "dl"
    NETLINK_DIAG = yes;
    INET_DIAG = yes;
    CPU_IDLE_GOV_TEO = no;
    GNSS = no;
    MTD_SPI_NOR = no;
    INTEL_MEI_HDCP = no;
    HABANA_AI = no;
    NET_VENDOR_TI = no;

    # else I get an error with current mptcp 0.95
    HSA_AMD = lib.modules.mkForce no;

    # DRM_AMDGPU = yes; # generates another error, implies DRM ?

    # increase ring kernel buffer size
    LOG_BUF_SHIFT = freeform "22";
    I2C_NVIDIA_GPU = yes;
  };
}
