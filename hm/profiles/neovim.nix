{
  pkgs,
  lib,
  config
, flakeSelf
, ...
}:

let

  inherit (pkgs.tetoLib) 
    luaPlugin
    genBlockLua;

  pluginsMap = pkgs.callPackage ./neovim/plugins.nix { inherit flakeSelf; };

  myNeovimUnwrapped = flakeSelf.inputs.neovim-nightly-overlay.packages."${pkgs.system}".neovim;

  rawPlugins =
    # add grepper
       pluginsMap.basePlugins
    ++ pluginsMap.luaPlugins
    ++ pluginsMap.colorschemePlugins
    # ++ pluginsMap.filetypePlugins
    ;

  vimPlugins = pkgs.vimPlugins;
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    enableMyDefaults = true;
    highlightOnYank = true;

    # custom options
    # fennel.enable = false;
    # teal.enable = false;
    # orgmode.enable = false;
    # autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    package = myNeovimUnwrapped;

    treesitter = {
      enable = true;

      plugins = [
        vimPlugins.nvim-surround
      ];
    };

    extraLuaConfig = lib.mkBefore (
      ''
      vim.g.mapleader = ' '

      vim.opt.hidden = true -- you can open a new buffer even if current is unsaved (error E37) =
      ''
      +
      (lib.strings.concatStrings (
        lib.mapAttrsToList genBlockLua (import ./neovim/options.nix).luaRcBlocks
      ))
      + ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      ''
      )
      ;

    # TODO this should disappear in the future
    extraLuaPackages = ps: [
      ps.nvim-nio
      ps.fzy
    ];

    extraPackages = with pkgs; [
      # emacs # for orgmode-babel
      shellcheck
    ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };

  # workarounds:
  # - for treesitter (provide compiler such that nvim-treesitter can install grammars
  # - for rocks.nvim: give him a tree to luarocks
  xdg.configFile = {
    "nvim/lua/generated-by-nix.lua" =
      let
        luaInterpreter = config.programs.neovim.package.lua;
        # -- vim.g.sqlite_clib_path" 'path = vim.g.sqlite_clib_path or  "${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}"'

      in
      {
        enable = true;
        # TODO add sqlite_clib_path to the wrapper ?
        text = ''
          local M = {}
          M.gcc_path = "${pkgs.gcc}/bin/gcc"
          M.lua_interpreter = "${luaInterpreter}"
          M.luarocks_executable = "${luaInterpreter.pkgs.luarocks_bootstrap}/bin/luarocks"
          M.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"
          return M
          '';
      };

    # could use toLua or buildLuarocksConfig
    # pkgs.lua.pkgs.luaLib.generateLuarocksConfig
    "nvim/luarocks-config-generated.lua" =
      let
        luaInterpreter = config.programs.neovim.package.lua;
        luarocksStore = luaInterpreter.pkgs.luarocks;
        luacurlPkg = luaInterpreter.pkgs.lua-curl;

        luarocksConfigAttr =
          pkgs.lua.pkgs.luaLib.generateLuarocksConfig ({ externalDeps = [ pkgs.curl.dev ]; })
          // {
            lua_version = "5.1";
          };

        luarocksConfigAttr2 = lib.recursiveUpdate luarocksConfigAttr {
          rocks_trees = [
            ({
              name = "rocks.nvim";
              root = "/home/teto/.local/share/nvim/rocks";
            })
            ({
              name = "rocks-generated.nvim";
              root = "${luarocksStore}";
            })
            ({
              name = "lua-curl";
              root = "${luacurlPkg}";
            })
            # ${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}
            ({
              name = "sqlite.lua";
              root = "${luaInterpreter.pkgs.sqlite}";
            })
          ];

          # we need variables for lib-curl.lua to be installable
          variables = {

          };

        };

        luarocksConfigStr = (lib.generators.toLua { asBindings = false; } luarocksConfigAttr2);

      in
      {
        enable = true;
        text = "return ${luarocksConfigStr}";
      };
  };
}
