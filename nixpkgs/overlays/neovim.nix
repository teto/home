final: prev:
rec {

  # makeNeovimConfig = {}:
  neovimTreesitterConfig = prev.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    plugins = with prev.vimPlugins; [
      {
        plugin = nvim-treesitter;
        # luaConfig = ''
        # local nvim_lsp = require 'nvim_lsp'
        # '';
      }
    ];
  };

  neovimHaskellConfig = prev.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    plugins = with prev.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        # luaConfig = ''
        # local nvim_lsp = require 'nvim_lsp'
        # '';
      }
    ];
  #   haskellPackages = [
  #     haskellPackages.haskdogs # seems to build on hasktags/ recursively import things
  #     haskellPackages.hasktags
  #     haskellPackages.nvim-hs
  #     haskellPackages.nvim-hs-ghcid
  #   ];
    customRC = ''
    '';

    # ajouter une config lua
    luaRC = ''
      '';
  };

  # TODO add withHaskell + the limited code
  # add a package to haskell function
  neovimDefaultConfig = {
        withPython3 = true;
        withPython = false;
        # withHaskell = false;
        withRuby = false; # for vim-rfc/GhDashboard etc.
        withNodeJs = true; # used by coc.vim

        # for pdf2text
        # addToPath = [ poppler_utils ];

        # TODO use them only if
        # todo override

        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden
        autocmd BufReadPost *.pdf silent %!${prev.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        ''
        # autocmd BufReadPost *.pdf silent %!${prev.pkgs.poppler_utils}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        ;

    extraPython3Packages = ps: with ps; [
      jedi
      # urllib3
      mypy
      pycodestyle
    ];
  };
}
