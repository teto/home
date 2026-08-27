{ config, pkgs, ... }:
{
  fonts.enableDefaultPackages = true;

  console = {
    # seems like a kernel bug resets it https://github.com/NixOS/nixpkgs/issues/413128
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i28b.psf.gz";
    # font = "ter-v32n"; # Terminus font, larger size
    packages = [ pkgs.terminus_font ];
    useXkbConfig = true;
  };

}
