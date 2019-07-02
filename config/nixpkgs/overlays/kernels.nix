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
  structuredConfigs = import ./kernels/structured.nix { inherit (prev) lib; inherit libk;};


  # TODO for dev shellHook
  # silent! call remove(g:LanguageClient_serverCommands, 'c')
  # see wiki
  addMenuConfig = kernel:
    # kernel;
    (kernel.overrideAttrs (o: {
    nativeBuildInputs=o.nativeBuildInputs ++ [ prev.pkgconfig prev.qt5.qtbase prev.ncurses ];
    shellHook = (o.shellHook or "") + ''
      echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
      echo "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
    '';
  }));

  defaultConfigStructured = with prev.lib.kernel; with structuredConfigs; prev.lib.mkMerge [
    # structuredConfigs.kvmConfigStructured
    bpfConfigStructured
    debugConfigStructured
    soundConfig
    mininetConfigStructured
    kvmConfigStructured
    mptcpConfigStructured
    localConfigStructured
    net9pConfigStructured
    strongswanStructured  # to get VPN working
    persoConfig

    minimalConfig
    # noChelsio # because of mptcp trunk

  ];

  # todo remove tags
  filter-src = builtins.filterSource (p: t:
  let baseName = baseNameOf p;
  in prev.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

in rec {

  mptcp94 = (prev.linux_mptcp.override ({
      kernelPatches=[];
      ignoreConfigErrors=true;
      autoModules = false;
      preferBuiltin = true;
      structuredExtraConfig = defaultConfigStructured;
  }));

  mptcp94-local-stable = mptcp94.override ({

    name="mptcp94-local";

    # TODO might need to revisit
    ignoreConfigErrors = true;
    autoModules = false;
    kernelPreferBuiltin = true;

    structuredExtraConfig = defaultConfigStructured;
  });

  my_lenovo_kernel = linux_mptcp_trunk_raw;


  # linux_mptcp_trunk_official = prev.callPackage ./pkgs/kernels/linux-mptcp-trunk.nix {
  #   kernelPatches = prev.linux_5_0.kernelPatches;
  #   # does not seem true anymore
  #   # preferBuiltin = true;
  #   # ignoreConfigErrors=true;
  #   # autoModules = true;
  #   # boot.debug1device
  #   # modDirVersion="4.19.0";
  #   structuredExtraConfig = defaultConfigStructured;
  # });


  # TODO try make localmodconfig
  linux_mptcp_trunk_raw = (prev.callPackage ./pkgs/kernels/linux-mptcp-trunk.nix
    {

    # triggers can't exec "lsmod"
    # defconfig = "localmodconfig";
    kernelPatches = prev.linux_5_1.kernelPatches;
    # does not seem true anymore
    preferBuiltin = true;
    ignoreConfigErrors=true;
    # autoModules = true;
    # boot.debug1device

    structuredExtraConfig = defaultConfigStructured;
  });

  linux_mptcp_trunk_dev = addMenuConfig linux_mptcp_trunk_raw ;

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

