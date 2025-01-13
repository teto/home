{
  # # vim-markdown-composer
  xdotool,
  grip,
  nodejs,
  fetchzip,
  patchelf,
  glibc,
  autoPatchelfHook,
  pkgs,
}:

final: prev: {
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
  vim-markdown-preview = prev.vim-markdown-preview.overrideAttrs (oa: {
    propagatedBuildsInputs = (oa.propagatedBuildsInputs or [ ]) ++ [
      xdotool
      grip
    ];
  });

  pdf-scribe-nvim = final.buildVimPlugin {
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
    propagatedBuildInputs = [ final.poppler ];

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
}
