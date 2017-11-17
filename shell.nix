# { pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
# inherit pkgs;
let
  filter-src = builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build");

  # pkg = pkgs.linux_mptcp;
  pkg = pkgs.mptcp-local;  # defined from overlay
  # .overrideAttrs (oldAttrs: {
  # });
in
  pkg
  # (pkg.override ({
  #   modDirVersion="4.9.60+";
  #   # modDirVersion="4.9.44+";
  #   src=pkgs.lib.cleanSource /home/teto/mptcp;
  # }))
  # .overrideAttrs(old: {
  #   shellHook=''
  #     echo "SHELLHOOK hello world"

  #   '';
  # })
# with pkgs;

# stdenv.mkDerivation {
#   name = "commands-nix";

#   buildInputs = [ libvirt simpleBuildTool ];

#   shellHook = ''
#     export NIX_PATH="nixpkgs=${toString <nixpkgs>}"
#     export LD_LIBRARY_PATH="${libvirt}/lib:$LD_LIBRARY_PATH"
#   '';
# }
