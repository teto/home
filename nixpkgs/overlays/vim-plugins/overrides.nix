{
# # vim-markdown-composer
xdotool, grip, nodejs
, fetchzip
, patchelf
, glibc
, autoPatchelfHook
, pkgs
}:

self: prev:
{
  # in super.vim-markdown-composer.overrideAttrs(oa: {

  #   propagatedBuildsInputs = (oa.propagatedBuildsInputs or []) ++ [
  #     vim-markdown-composer-bin xdotool grip
  #   ];

  #   postInstall = ''
  #     mkdir -p $out/share/vim-plugins/vim-markdown-composer/target/release
  #     ln -s ${vim-markdown-composer-bin}/bin/markdown-composer $out/share/vim-plugins/vim-markdown-composer/target/release/markdown-composer
  #     '';
  # });

  # https://github.com/JamshedVesuna/vim-markdown-preview#installation
  # yet another contender: https://github.com/MikeCoder/markdown-preview.vim
  vim-markdown-preview = prev.vim-markdown-preview.overrideAttrs(oa: {
    propagatedBuildsInputs = (oa.propagatedBuildsInputs or []) ++ [ xdotool grip ];
  });

  pdf-scribe-nvim = self.buildVimPluginFrom2Nix {
    pname = "pdf-scribe";
    version = "unstable";
    src = builtins.fetchGit "https://github.com/wbthomason/pdf-scribe.nvim.git";
    # src = fetchFromGitHub {
    #   owner="wbthomason";
    #   version = "";
    #   repo = "pdf-scribe.nvim";
    #   # sha256 = "1ccq6akkm8n612ni5g7w7v5gv73g7p1d9i92k0bnsy33fvi3pmnh";
    # };
    # libpoppler-glib.so
    propagatedBuildInputs = [ self.poppler ];

    # concat with ;
    # LUA_CPATH = "${pkgs.poppler}/ rg";
  };

  # nvim-markdown-preview = prev.nvim-markdown-preview.overrideAttrs(old: {
  #   buildInputs = [ pkgs.nodePackages.live-server pkgs.pandoc ];
  #   preFixup = ''
  #     substituteInPlace $out/share/vim-plugins/nvim-markdown-preview/ftplugin/markdown.vim --replace "executable('live-server')" \
  #         "executable('${pkgs.nodePackages.live-server}/bin/live-server')"

  #     substituteInPlace $out/share/vim-plugins/nvim-markdown-preview/autoload/markdown.vim --replace "live-server" \
  #         "${pkgs.nodePackages.live-server}/bin/live-server"
  #     '';
  # });

  # markdown-preview-nvim = let
  #   version = "0.0.9";
  #   index_js = fetchzip {
  #       # TODO fix linux/macos
  #       url = "https://github.com/iamcco/markdown-preview.nvim/releases/download/v${version}/markdown-preview-linux.tar.gz";
  #       sha256 = "0lxk8h4q64g21ywgnfq2hl431ap14kq4hxlacfyhz860jll3qf0j";
  #     };
  #   nodePackages = import ./nodepkgs.nix {
  #     inherit (prev) pkgs;
  #   #   inherit (prev.stdenv.hostPlatform) system;
  #   };
  #     # node2nix ./package.json
  # in prev.markdown-preview-nvim.overrideAttrs(old: {
  #   # you still need to enable the node js provider in your nvim config
  #   # TODO fix folder
  #   buildInputs = (old.buildInputs or []) ++ [ autoPatchelfHook glibc pkgs.gcc-unwrapped.lib ] ++ (with nodePackages; [

  #   ]);

  #   # first it checks if file is
  #   # TODO use install -D
  #     # mkdir -p $out/share/vim-plugins/coc-nvim/app
  #     # ${glibc.out}/lib/ld-linux-x86-64.so.2
  #     # --set-interpreter $NIX_CC/nix-support/dynamic-linker
  #   #       patchelf  $out/share/vim-plugins/markdown-preview-nvim/app/bin/markdown-preview-linux
  #   postInstall = ''
  #     set -x

  #     mkdir -p $out/share/vim-plugins/markdown-preview-nvim/app/bin
  #     cp ${index_js}/markdown-preview-linux $out/share/vim-plugins/markdown-preview-nvim/app/bin

  #   '';

  # });
}
