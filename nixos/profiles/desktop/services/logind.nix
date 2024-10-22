{
  # see https://nixos.org/nix-dev/2015-July/017657.html for problems
  # with /run/user/1000 size
  # size of tmpfs used by nix builds
  # usually
  extraConfig = ''
    RuntimeDirectorySize=5G
  '';
}
