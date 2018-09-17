 # If the path is a directory, then we take the content of the directory, order it lexicographically, and attempt to interpret each as an overlay by:

 #    Importing the file, if it is a .nix file.

 #    Importing a top-level default.nix file, if it is a directory. 
final: prev:
{
  # imports = [
  #   # ./modules/services/gnome3.nix
  #   ./kernels.nix
  # ];
  # vdirsyncer = prev.vdirsyncer.overrideAttrs ( oa: {
  #   src = fetchGit {
      # url = https://github.com/pimutils/vdirsyncer.git;
    # };
  # });

  # astroid = prev.astroid;
  # astroid = prev.enableDebugging prev.astroid;

  # ebpfdropper = prev.callPackage ./ebpfdropper.nix {
  #   stdenv=prev.clangStdenv;
  #   llvm=prev.llvm_5;
  # };

  mptcpanalyzer = prev.python3Packages.callPackage ./mptcpanalyzer {
    # tshark = self.pkgs.tshark-reinject-stable; 
    # inherit (prev.pkgs) tshark;
    tshark = final.pkgs.tshark-dev-stable;
  };

  # http-getter = prev.python3Packages.callPackage ./http-getter { } ;

  mptcpnumerics = prev.python3Packages.callPackage ./mptcpnumerics.nix {};

  rt-tests = prev.callPackage ./rt-test.nix {};

  netbee = prev.callPackage ./netbee {};

  gImageReader = prev.libsForQt5.callPackage ./gImageReader {};

  i3-dispatch = prev.python3Packages.callPackage ./i3-dispatch {};
  # linux_mptcp_4_94 = prev.callPackage ./mptcp {};
}
