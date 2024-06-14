{
  # see https://nixos.org/nix-dev/2015-July/017657.html for problems 
  # with /run/user/1000 size
  extraConfig = ''
    RuntimeDirectorySize=3G
  '';
}
