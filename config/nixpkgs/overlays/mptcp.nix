self: super:
{
  # kernel derivations are written in
  # generic.nix / manual-config.nix
  # /home/teto/nixpkgsbis/pkgs/os-specific/linux/kernel/linux-mptcp.nix
  # the 'stripping FHS path' appears is done in manual-config.nix:prePatch

  # requiredKernelConfig
  # configfile is a derivation
  # buildLinux

  # todo bump the linux mptcp one
  # https://nixos.org/nixpkgs/manual/#sec-overrides
  # mptcp-dev = super.linux_mptcp.override (oldAttrs: {
  mptcp-dev = super.linux_mptcp.override {
    src = super.lib.cleanSource /home/teto/mptcp;
    # patches are for security, makes dev harder
    kernelPatches = [];
    nativeKernelPatches = [];

    # in generic.nix

    # config = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };
    # prePatch
  };
}

