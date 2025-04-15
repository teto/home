{
  config,
  pkgs,
  lib,
  flakeSelf,
  ...
}:
let
  genBlockLua = title: content: ''
    -- ${title} {{{
    ${content}
    -- }}}
  '';

  luaPlugin =
    attrs:
    attrs
    // {
      type = "lua";
      config = lib.optionalString (attrs ? config && attrs.config != null) (
        genBlockLua attrs.plugin.pname attrs.config
      );
    };

  blinkPlugins = [
    pkgs.vimPlugins.blink-cmp # nixpkgs' one
    # pkgs.vimPlugins.blink-cmp-git # autocomplete github issues/PRs
  ];

  neotestPlugins = with pkgs.vimPlugins; [
    # neotest
    # neotest-haskell
  ];

  treesitterPlugins = [
    pkgs.vimPlugins.nvim-treesitter-pairs
    pkgs.vimPlugins.nvim-treesitter-textobjects
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.hurl
    pkgs.vimPlugins.nvim-treesitter-parsers.python
    # pkgs.vimPlugins.nvim-treesitter-parsers.orgmode
  ];

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = neomutt-vim; }
    { plugin = pkgs.vimPlugins.hurl; }
    { plugin = wmgraphviz-vim; }
    # { plugin = fennel-vim; }
    { plugin = vim-toml; } # TODO use treesitter
    # { plugin = dhall-vim; }
    # { plugin = kmonad-vim; }
    { plugin = vim-just; }
    # moonscript-vim
    # idris-vim
  ];

  luaPlugins = with pkgs.vimPlugins; [

    (luaPlugin {
      plugin = avante-nvim;
      #   .overrideAttrs({
      #
      #   src = flakeSelf.inputs.avante-nvim-src;
      # });
      # require("avante").setup()
      # config = ''
      # require("avante_lib").load()
      # '';

    })
    { plugin = nvim-colorizer-lua; }
    pkgs.vimPlugins.typescript-tools-nvim
    pkgs.vimPlugins.gitlab-vim

    # not upstreamed yet
    # (luaPlugin { plugin = nvim-lua-gf; })
    # (luaPlugin { plugin = luasnip; })
    # required by trouble
    # (luaPlugin { plugin = nvim-web-devicons; })
    # TODO it needs some extra care

    # TODO should be able to handle it via rocks ?
    # avante lets you use neovim as cursor IDE
    # (luaPlugin { plugin = avante-nvim; })

    # (luaPlugin { plugin = haskell-tools-nvim; })

    # I've not been using it so far
    # (luaPlugin { plugin = nvim-dap; })

    # disabling as long as it depends on nvim-treesitter
    # can now be installed via Rocks
    # (luaPlugin {
    #   # matches nvim-orgmode
    #   plugin = orgmode;
    #   # TODO autoload via lz.n instead
    #   # config = '' '';
    # })

    (luaPlugin {
      # for yaml lsp
      plugin = SchemaStore-nvim;
    })

    # this could be moved to my config
    (luaPlugin {
      plugin = nvimdev-nvim;
      optional = true;
      config = # lua
        ''
          -- nvimdev {{{
          -- call nvimdev#init(--path/to/neovim--)
          vim.g.nvimdev_auto_init = 1
          vim.g.nvimdev_auto_cd = 1
          -- vim.g.nvimdev_auto_ctags=1
          vim.g.nvimdev_auto_lint = 1
          vim.g.nvimdev_build_readonly = 1
          --}}}
        '';
    })
    (luaPlugin { plugin = sniprun; })
  ];

  extraPackages = with pkgs; [
    bash-language-server
    black
    editorconfig-checker # used in null-ls
    fswatch # better file watching starting with 0.10
    go # for gitlab.nvim, we can probably ditch it afterwards
    # gcc # this is sadly a workaround to be able to run :TSInstall
    luajitPackages.luacheck

    luaformatter
    # nvimLua.pkgs.luarocks # should be brought by rocks config

    # luaPackages.lua-lsp
    # lua53Packages.teal-language-server
    # codeium # ideally not needed and referenced by codeium-vim directly
    haskellPackages.hasktags
    haskellPackages.fast-tags

    manix # should be no need, telescope-manix should take care of it
    nodePackages.vscode-langservers-extracted # needed for jsonls aka "vscode-json-language-server"
    # prettier sadly can't use buildNpmPackage because no lockfile https://github.com/NixOS/nixpkgs/issues/229475
    nodePackages.dockerfile-language-server-nodejs

    # TODO map it to a plugin instead
    # nodePackages.typescript-language-server

    # pandoc # for markdown preview, should be in the package closure instead
    # pythonPackages.pdftotext  # should appear only in RC ? broken
    nil # a nix lsp, can be debugged with NIL_LOG_PATH and NIL_LOG=nil=debug
    nixd # another nix LSP
    # rnix-lsp
    rust-analyzer
    shellcheck
    sumneko-lua-language-server
    gopls # LSP for go
    marksman # markdown LSP server

    # for none-ls
    nixfmt-rfc-style # -rfc-style #
    # nodePackages.prettier # for none-ls json formatting ?
    nodePackages.prettier
    python3Packages.flake8 # for nvim-lint and some nixpkgs linters
    # soxWithMp3 = final.sox.override { llama-cpp = llama-cpp-matt; };

    pyright # python lsp

    yaml-language-server # ~100MB
    yamllint # for none-ls json formatting
    yamlfmt
  ];

  # TODO get lua interpreter to select the good lua packages
  nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
in
{
  enableBlink = true;
  enableMyDefaults = true;

  lsp.mapOnAttach = true;

  #
  # enableYazi = true;

  # local nix_deps = require('generated-by-nix')

  extraLuaConfig = # lua
    lib.mkAfter ''
      require('init-manual')
    '';

  # _imports = [
  #   flakeSelf.homeProfiles.neovim
  # ];
  #
  plugins =
    [
      # TODO hacking on this

      # TODO replaced with https://github.com/yutkat/git-rebase-auto-diff.nvim
      # {
      #   # display git diff while rebasing, pretty dope
      #   # my complaints: has issues with sync mode
      #   plugin = pkgs.vimPlugins.auto-git-diff;
      #   # config = ''
      #   # let g:auto_git_diff_disable_auto_update=1
      #   # '';
      # }

      (luaPlugin {
        plugin = pkgs.vimPlugins.unicode-vim;
        # ${pkgs.vimPlugins.unicode-vim.passthru.initLua}
        config = ''
          -- overrides ga
          vim.keymap.set ( "n", "ga",  "<Plug>(UnicodeGA)", { remap = true, } )
        '';
      })

    ]
    ++ luaPlugins
    ++ blinkPlugins
    ++ filetypePlugins
    ++ treesitterPlugins
    # ++ telescopePlugins
    ++ neotestPlugins;

  # plugins = with pkgs.vimPlugins; [
  #  tint-nvim
  # ];
  # -- vim.lsp.set_log_level("info")
  # -- require my own manual config
  # -- logs are written to /home/teto/.cache/vim-lsp.log

  # viml config, to test home-manager setup
  # extraConfig = ''
  #  '';

  withNodeJs = true; # for tests

  # HACK till we fix it
  # or else we need a vim.g.sqlite_clib_path
  extraLuaPackages = lp: [
    lp.sqlite
  ]
  # nvimLua.pkgs.rest-nvim.propagatedBuildInputs
  ;

  extraPython3Packages = p: [
    p.jupyter_client
    p.pyperclip # if you want to use molten_copy_output
    p.nbformat # to import/export notebooks
    p.pynvim
  ];
  extraPackages =
    extraPackages
    ++ pkgs.vimPlugins.llm-nvim.runtimeDeps # temporary workaround
    ++ [
      pkgs.gitlab-ci-ls # gitlab lsp
    ]

  ;
}
