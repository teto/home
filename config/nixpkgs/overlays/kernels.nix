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

  # prev.lib.mkForce 
  defaultConfigStructured = with prev.lib.kernel; with structuredConfigs; (prev.lib.mkMerge [
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

  ]);

  # todo remove tags
  filter-src = builtins.filterSource (p: t:
  let baseName = baseNameOf p;
  in prev.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");

in rec {


  # TODO maybe I should modify linuxPackagesFor instead ?
  linux_latest_debug = prev.linux_latest.override {
    structuredExtraConfig = structuredConfigs.debugConfigStructured ;
  };

  my_lenovo_kernel = linux_mptcp_trunk_raw;


  # TODO try make localmodconfig
  linux_mptcp_trunk_raw = (prev.callPackage ./pkgs/kernels/linux-mptcp-trunk.nix
    {


    # will set INSTALL_MOD_STRIP=1
    dontStrip = true;

    # triggers can't exec "lsmod"
    # defconfig = "localmodconfig";
    kernelPatches = prev.linux_5_2.kernelPatches;
    # does not seem true anymore
    # preferBuiltin = false;
    ignoreConfigErrors=true;
    # autoModules = true;
    # boot.debug1device

    structuredExtraConfig = defaultConfigStructured;
  });

  linuxPackages_mptcp_trunk = prev.linuxPackagesFor linux_mptcp_trunk_raw;

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

