final: prev:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (
    p: t: prev.lib.cleanSourceFilter p t && baseNameOf p != "build"
  );

in
rec {

  protocol-local = prev.protocol.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit { url = "https://github.com/teto/protocol"; };
  });

  # xdg-utils = prev.xdg-utils.overrideAttrs(oa: {
  #   pname = "xdg-utils-custom";
  #   name = "xdg-utils-custom-matt";
  #   # version = "matt";
  #   patches = [
  #     ./patches/xdg_utils_symlink.diff
  #   ];
  # });

}
