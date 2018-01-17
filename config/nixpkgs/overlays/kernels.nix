self: super:
let
  kvmConfig = ''
      VIRTIO_PCI y
      VIRTIO_PCI_LEGACY y
      VIRTIO_BALLOON y
      VIRTIO_INPUT y
      VIRTIO_MMIO y
      VIRTIO_BLK y

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

    '';

    mptcpConfig = ''

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
    '';

    debugConfig = ''

      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y
    '';

  # must be used with ignoreConfigErrors in kernels
  # kernelExtraConfig=builtins.readFile ../extraConfig.nix;

in rec {
  # linux_4_9 = super.linux_4_9.override({
  #   hostPlatform=test-platform;
  # });

  # TODO use this platform to build the various kernels
  # this won t be used by nixops ?
  test-platform = super.platforms.pc64_simplekernel // {
    kernelAutoModules = false;
    extraConfig = super.platforms.pc64_simplekernel
      + kvmConfig
      + mptcpConfig
      + debugConfig
      ;
  };


  # to improve the config
  # make localmodconfig
  mptcp93 = super.pkgs.linux_mptcp.override ({
    kernelPatches=[];
    # NIX_DEBUG=8;
    # maybe that works
    # configfile = /path/to/my/config
    # TODO reuse old value of extraConfig
    # check because that line is strange

    # it will append then overwrite itself ;/
  # '' + (args.extraConfig or "");
# } // args // (args.argsOverride or {}))
    # kernelAutoModules = false;
    # TODO make a new configuration light ?
    # hostPlatform=super.lib.platforms.pc64_simplekernel;
    # hostPlatform=test-platform;
    # extraConfig=kernelExtraConfig;

    # useless on the kernel branch
    # argsOverride = {
    #   # supposed  to always work
    #   modDirVersion="4.9.60+";
    # };
  });

  # sandbox doesn't like 
  mptcp-local =
  let
    # todo remove tags
    filter-src = builtins.filterSource (p: t:
    let baseName = baseNameOf p;
    in super.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");
  in
  mptcp93.override ({
      # src= super.lib.cleanSource /home/teto/mptcp;
      modDirVersion="4.9.60+";
      name="mptcp-local";
      # TODO testing...
      # hostPlatform=super.platforms.pc64_simplekernel;

      # TODO might need to revisit
      ignoreConfigErrors=true;

      configfile = "/home/teto/mptcp/config.tpl";
      # configfilename = /home/teto/dotfiles/kernel_config.mptcp;
      # src= super.fetchgitLocal "/home/teto/mptcp";

      # src = fetchGitHashless {
      #   # rev="owd93";
      #   branchName="owd93";
      #   # url= file:///home/teto/mptcp;
      #   url= "/home/teto/mptcp";
      # };
      enableParallelBuilding=true;

      # if we dont want to have to regenerate it
      # configfile=

  });

  # mptcp-head = mptcp93.override ({

  # linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_mptcp-local = super.pkgs.linuxPackagesFor mptcp-local;

  # hostPlatform = super.hostPlatform.overrideAttrs(old: {
    # platform = test-platform;
  # });
}

