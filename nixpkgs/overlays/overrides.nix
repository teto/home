final: prev:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: prev.lib.cleanSourceFilter p t && baseNameOf p != "build");

in
rec {

  protocol-local = prev.protocol.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = https://github.com/teto/protocol;
    };
  });

  neovide = prev.neovide.overrideAttrs(oa:
    let
      rpathLibs = with final.pkgs; [
        libglvnd
        freeglut
        freeglut.dev
        freetype

        vulkan-loader
        xorg.libXcursor
        xorg.libXext
        xorg.libXrandr
        xorg.libXi
        fontconfig
      ];
    in {
    # shellHook = ''echo "hello world"'';
      buildInputs = with final.pkgs; oa.buildInputs ++ [
        libglvnd
        freeglut
        freeglut.dev
        freetype

        vulkan-loader
        xorg.libXcursor
        xorg.libXext
        xorg.libXrandr
        xorg.libXi
        fontconfig


      ];

      src = final.fetchFromGitHub {
        owner = "Kethku";
        repo = "neovide";
        rev = "580558f39e1494b377385ea109176ebe7ccc357f"; # opengl branch
        sha256 = "sha256-aElIufOVKKAN8MKxHpzO50DgHyjU49Qwtf5wBGzVDV0=";

      };

      cargoSha256 = "0000000000000000000000000000000000000000000000000000";

      shellHook = ''
        echo "hello world"
        echo 'patchelf --set-rpath "${final.lib.makeLibraryPath rpathLibs}" target/debug/neovide'
      '';
  });

  # visidata = prev.visidata.overrideAttrs(oa: {
  #   name = "visidata-matt";
  #   src = builtins.fetchGit {
  #     ref = "develop";
  #     url = "https://github.com/saulpw/visidata.git";
  #     rev = "e65c076c644a9577022c985dee5b447650cddd72";
  #   };
  # });

  # xdg_utils = prev.xdg_utils.overrideAttrs(oa: {
  #   pname = "xdg-utils-custom";
  #   name = "xdg-utils-custom-matt";
  #   # version = "matt";
  #   patches = [
  #     ./patches/xdg_utils_symlink.diff
  #   ];
  # });

}
