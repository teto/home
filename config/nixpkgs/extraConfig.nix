
      INFINIBAND n
      MMC_SDHCI n

      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y

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
    DEFAULT_DUMMY y
    DEFAULT_MPTCP_PM default

    # MPTCP scheduler selection.
    # Disabled as the only non-default is the useless round-robin.

    # Smarter TCP congestion controllers
    TCP_CONG_LIA m
    TCP_CONG_OLIA m
    TCP_CONG_WVEGAS m
    TCP_CONG_BALIA m

      # TODO perso ? l activer ?
      NETWORK_PHY_TIMESTAMPING n

      NET_SWITCHDEV y
      NET_TCPPROBE m

      # else qemu can't see the root filesystem when launched with -kenel
      EXT4_FS y

 VIRTIO_PCI y
 VIRTIO_PCI_LEGACY y
 VIRTIO_BALLOON m
 VIRTIO_INPUT m
 VIRTIO_MMIO m

VIRTIO_BLK y

# when run as -kernel, need to get an ip
IP_PNP y
IP_PNP_DHCP y

8139CP y
8139TOO y
8139TOO_PIO y
# CONFIG_8139TOO_TUNE_TWISTER is not set
8139TOO_8129 y
# CONFIG_8139_OLD_RX_RESET is not set

    TCP_PROBE y
