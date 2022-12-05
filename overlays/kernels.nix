# https://nixos.wiki/wiki/Linux_Kernel
# configfile.passthru.structuredConfig
final: prev:

# DYNAMIC_DEBUG n is important !!
let

  # level of indirection while waiting for a better solution
  # callPackage ?
  libk = prev.lib.kernel;

  # TODO tester ce qui fait flipper/ peut foirer
  # EXT4_ENCRYPTION

  # https://wiki.strongswan.org/projects/strongswan/wiki/KernelModules
  structuredConfigs = import ./kernels/structured.nix { inherit (prev) lib; inherit libk; };


  # TODO for dev shellHook
  addMenuConfig = kernel:
    # kernel;
    (kernel.overrideAttrs (o: {
      nativeBuildInputs = o.nativeBuildInputs ++ [
        prev.pkgconfig
        prev.qt5.qtbase
        prev.ncurses
        # we need python to run scripts/gen_compile_commands
        prev.python
      ];
      # buildInputs = (o.buildInputs or []) ++ [prev.python];
      shellHook = (o.shellHook or "") + ''
        echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
        echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
      '';
    }));



  # soundConfig
  defaultConfigStructured = with prev.lib.kernel; with structuredConfigs; (prev.lib.mkMerge [
    # structuredConfigs.kvmConfigStructured
    bpfConfigStructured
    debugConfigStructured
    mininetConfigStructured
    kvmConfigStructured
    mptcpConfigStructured
    localConfigStructured
    net9p
    # strongswanStructured  # to get VPN working
    persoConfig

    paravirtualization_guest
    minimalConfig
    # noChelsio # because of mptcp trunk

  ]);

  # todo remove tags
  filter-src = builtins.filterSource (p: t:
    let baseName = baseNameOf p;
    in prev.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

in
rec {

  kernelForDev = { debugKconfig ? true }: kernel:
    (kernel.overrideAttrs (oa: {
      # could be or kernelPatches
      # prePatch = ''
      #   substituteInPlace scripts/kconfig/ \
      #     --replace 'int cdebug = PRINTD;' 'int cdebug = DEBUG_PARSE;'
      # '';
    }));

  #   Setups the kernel config to use virtio as a guest
  kernelConfigureAsGuest = kernel:
    (kernel.override {
      # temp because of deadline
      # preferBuiltin = true; -> should change the structuredConfig
      # defconfig = "kvmguest"; # doesn't work well
      # TODO 
      # it was not answering Console on 8250/16550 and compatible serial port, NAME: SERIAL_8250_CONSOLE, ALTS: Y/n/?, ANSWER:
      ignoreConfigErrors = true;

      # won't work like this
      autoModules = true;

      # structuredConfigs.debugConfigStructured
      structuredExtraConfig = with structuredConfigs; (prev.lib.mkMerge [
        kernel.configfile.passthru.structuredConfig
        net9p
        paravirtualization_guest
        kvmConfigStructured
        # mptcpConfigStructured
      ]);
    });

  # TODO maybe I should modify linuxPackagesFor instead ?
  linux_latest_debug = prev.linux_latest.override {
    structuredExtraConfig = structuredConfigs.debugConfigStructured;
  };


  # used to check https://github.com/NixOS/nixpkgs/pull/55755/files
  linux_latest_without_ns = prev.linux_latest.override {
    # That works
    # defconfig = "x86_64_defconfig kvmconfig";
    structuredExtraConfig = {
      NET_NS = libk.no;
    };
  };


  # TODO try make localmodconfig
  linux_mptcp_trunk_raw = (prev.callPackage ./pkgs/kernels/linux-mptcp-trunk.nix {

    # will set INSTALL_MOD_STRIP=1
    dontStrip = true;

    # triggers can't exec "lsmod"
    # defconfig = "localmodconfig";
    kernelPatches = prev.linux_5_4.kernelPatches;
    # does not seem true anymore
    # preferBuiltin = false;
    ignoreConfigErrors = true;
    # autoModules = true;
    # boot.debug1device

    structuredExtraConfig = defaultConfigStructured;
  });

  linux_latest_with_virtio = (prev.linux_latest.override {
    structuredExtraConfig = with structuredConfigs; (prev.lib.mkMerge [
      kvmConfigStructured
    ]);
  });

  linuxPackages_mptcp_trunk = prev.linuxPackagesFor linux_mptcp_trunk_raw;

  linux_mptcp_trunk_dev = addMenuConfig linux_mptcp_trunk_raw;

  # doesn't work as expected yet
  # now enabled by default
  # linux_mptcp_official = pkgs.linux_latest.override {
  #   structuredExtraConfig = with lib.kernel; {
  #     MPTCP      = yes;
  #     MPTCP_IPV6 = yes;
  #   };
  # };

  # see https://nixos.wiki/wiki/Linux_Kernel
  # linux_mptcp_trunk = (prev.linuxManualConfig {
  #   inherit (prev) stdenv;
  #   inherit (linux_mptcp_trunk_raw) src version modDirVersion;
  #   # version = linux_mptcp_94.version;
  #   configfile = ./kernels/mptcp_trunk_netlink.config;
  #   # we need this to true else the kernel can't parse the config and 
  #   # detect if modules are in used
  #   allowImportFromDerivation = true;
  #   # modDirVersion="4.14.70";
  # }).overrideAttrs (oa: {
  #   shellHook = ''
  #     touch .scmversion
  #     echo "hello boss"
  #   '';
  # });

  /*
    simple convenience to just test the code faster
  */
  # checkKernelConfigTest = let
  #   # alread flattened
  #   # genericCfg = import ../os-specific/linux/kernel/common-config.nix {
  #   #   inherit (linux_latest) stdenv version ;
  #   #   # otherwise common-config crashes
  #   #   features = { xen_dom0 = false; };
  #   # };

  #   # this one has been processed yet
  #   # genericCfg = linux_latest.configfile.passthru.structuredConfig;
  #   genericCfg = prev.linux_latest.configfile.outPath;
  #   requiredConfig = with prev.lib.kernel; {
  #     IDE = yes;
  #     HAVE_IDE = yes;
  #   };
  # in
  #   # prev.lib.kernel.checkKernelConfig (builtins.trace "hello" genericCfg) requiredConfig;
  #   prev.checkKernelConfig (builtins.trace "hello" genericCfg) requiredConfig;

}
