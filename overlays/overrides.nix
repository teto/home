final: prev:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (
    p: t: prev.lib.cleanSourceFilter p t && baseNameOf p != "build"
  );

in
{
  protocol-local = prev.protocol.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit { url = "https://github.com/teto/protocol"; };
  });

  llama-cpp-with-curl = prev.llama-cpp.overrideAttrs (oa: {

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      final.curl.dev
    ];

    cmakeFlags = oa.cmakeFlags ++ [

      (prev.lib.cmakeBool "LLAMA_CURL" true)
    ];
  });

  termscp-matt = prev.termscp.overrideAttrs (oa: {
    cargoBuildFlags = "--no-default-features";
  });

  flameshotGrim = final.flameshot.override ({
    enableWlrSupport = true;
  });
  # overrideAttrs (oldAttrs: {
  #   src = prev.fetchFromGitHub {
  #     owner = "flameshot-org";
  #     repo = "flameshot";
  #     rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
  #     sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
  #   };
  #   cmakeFlags = [
  #     "-DUSE_WAYLAND_CLIPBOARD=1"
  #     "-DUSE_WAYLAND_GRIM=1"
  #   ];
  #   buildInputs = oldAttrs.buildInputs ++ [ final.libsForQt5.kguiaddons ];
  # });

  # xdg-utils = prev.xdg-utils.overrideAttrs(oa: {
  #   pname = "xdg-utils-custom";
  #   name = "xdg-utils-custom-matt";
  #   # version = "matt";
  #   patches = [
  #     ./patches/xdg_utils_symlink.diff
  #   ];
  # });

}
