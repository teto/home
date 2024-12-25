{
  pkgs,
  lib,
  config,
  flakeInputs,
  ...
}:

let

  inherit (pkgs.tetoLib) luaPlugin genBlockLua;

  pluginsMap = pkgs.callPackage ./neovim/plugins.nix { };
  # taken from the official flake
  # must be an unwrapped version
  # myNeovimUnwrapped = pkgs.neovim-unwrapped.override({ libuv = libuv_147;});
  myNeovimUnwrapped = flakeInputs.neovim.packages."${pkgs.system}".neovim;
  # .overrideAttrs(oa: {
  #   patches = builtins.head oa.patches;
  # });
  # lua = myNeovimUnwrapped.lua;

  rawPlugins =
    pluginsMap.basePlugins
    ++ pluginsMap.luaPlugins
    ++ pluginsMap.colorschemePlugins
    ++ pluginsMap.filetypePlugins;

in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # custom options
    # fennel.enable = false;
    # teal.enable = false;
    # orgmode.enable = false;
    # autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    package = myNeovimUnwrapped;

    extraLuaConfig = lib.mkBefore (
      (lib.strings.concatStrings (
        lib.mapAttrsToList genBlockLua (import ./neovim/options.nix).luaRcBlocks
      ))
      # + ''
      #   vim.opt.number = true
      #   vim.opt.relativenumber = true
      # ''
    );

    # TODO this should disappear in the future
    extraLuaPackages = ps: 
    [
      ps.nvim-nio
      ps.fzy
    ];

    extraPackages = with pkgs; [
      # emacs # for orgmode-babel
      shellcheck
      gitlab-ci-ls # gitlab lsp
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

        # this is a backup
        # luarocksConfigStrDefault = ''
        #
        #     lua_version = "5.1"
        #     rocks_trees = {
        #         {
        #           name = "rocks.nvim",
        #           root = "/home/teto/.local/share/nvim/rocks",
        #         },
        #         {
        #           name = "rocks-generated.nvim",
        #           root = "${luarocksStore}"
        #         },
        #         {
        #           name = "lua-curl",
        #           root = "${luacurlPkg}"
        #         }
        #     }
        #     '';

      in
      {
        enable = true;
        text = "return ${luarocksConfigStr}";
      };
  };
}
