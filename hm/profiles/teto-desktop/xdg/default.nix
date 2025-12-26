{
  pkgs,
  lib,
  config,
  dotfilesPath,
  # secretsFolder,
  # secrets,
  # withSecrets,
  flakeSelf,
  ...
}:
{

  desktopEntries = {

    firefox-router = {

      type = "Application";
      exec = "${dotfilesPath}/firefox-router";
      icon = "firefox";
      comment = "Firefox (nova)";
      terminal = false;
      name = "Firefox router";
      genericName = "Web Browser";
      mimeType = [
        "text/html"
        "text/xml"
      ];
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = false;

    };
  };

  portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      # big but might be necessary for flameshot ? and nextcloud-client
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gnome # necessary for flameshot
    ];

    # config.hyprland.default = [ "wlr" "gtk" ];
    config.sway.default = [
      "wlr"
      "gtk"
    ];
  };

  configFile = {

    # "bash/lib.sh".text = lib.optionalString withSecrets ''
    #   TETO_PERSONAL_EMAIL=${secrets.accounts.mail.fastmail_perso.login}
    # '';

    "nvim/lua/generated-by-nix.lua" =
      let
        # hitting this limit https://github.com/luarocks/luarocks/issues/1797
        # luaInterpreter = config.programs.neovim.package.lua;
        luaInterpreter = pkgs.lua51Packages.lua;
        # -- vim.g.sqlite_clib_path" 'path = vim.g.sqlite_clib_path or  "${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}"'

      in
      {
        enable = true;
        # TODO add sqlite_clib_path to the wrapper ?
        text =
          let
            ghcEnv4Tidal = (pkgs.ghc.withPackages (hs: [ hs.tidal ]));
          in
          ''
            local M = {}
            M.gcc_path = "${pkgs.gcc}/bin/gcc"
            M.lua_interpreter = "${luaInterpreter}"
            M.luarocks_executable = "${luaInterpreter.pkgs.luarocks_bootstrap}/bin/luarocks"
            M.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"
            M.edict_kanjidb = "${flakeSelf.inputs.edict-kanji-db}/kanji.db"
            M.edict_expressiondb = "${flakeSelf.inputs.edict-expression-db}/expression.db"
            M.tidal_boot = "${ghcEnv4Tidal}/tidal-1.10.1/BootTidal.hs"
            return M
          '';
      };

    # "nvim/lua/generated-by-nix.lua" =
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
              # TODO reference xdg
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
