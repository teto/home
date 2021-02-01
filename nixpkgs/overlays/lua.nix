self: prev:
rec {

  lua = prev.lua.override {

  #     # TODO use my fork
  #     nvim-client  = luaprev.nvim-client.overrideAttrs (oa: {
  #       src = /home/teto/lua-client;
  #       # src = prev.fetchFromGitHub {
  #       #   repo = "lua-client";
  #       #   owner = "teto";
  #       #   rev = "ffe21016d4ac2de810cc89a4f686fd72065214c0";
  #       #   sha256= "";
  #       # };
  #     });

    packageOverrides = luaself: luaprev: {

      # luarocks = luaprev.luarocks.overrideAttrs(oa: {
      #   pname = "luarocks-local";
      #   src = /home/teto/luarocks;
      #   # src = builtins.fetchGit {
      #   #   url = https://github.com/teto/luarocks/;
      #   #   ref = "nix";
      #   # };
      # });

      # argparse = luaprev.argparse.overrideAttrs(oa: {
      #   pname = "argparse-local";
      #   # src = /home/teto/argparse;
      #   # src = builtins.fetchGit {
      #   #   url = https://github.com/teto/luarocks/;
      #   #   ref = "nix";
      #   # };
      #   doCheck = true;
      #   # self.busted #
      #   # checkInputs = [];
      #   # checkPhase = ''
      #     # busted spec/
      #   # '';
      #   shellHook = ''
      #     export PATH="/home/teto/busted/bin:$PATH"
      #     echo 'export LUA_PATH="/home/teto/busted/?.lua;$LUA_PATH"'
      #   '';
      # });

      # busted = luaprev.busted.overrideAttrs(oa: {
      #   pname = "busted-local";
      #   src = /home/teto/busted;
      # });

    #   # prev.lib.traceValSeq
    #   cqueues = ( luaprev.cqueues.override({
    #     # name = "matt";
    #     # pname = "matt";
    #     disabled = false;
    #   }));

    # mpack = ( luaprev.mpack.override({
    #   CFLAGS = "-ansi -g3 -Wall -Wextra -Werror -Wconversion -Wstrict-prototypes -Wno-unused-parameter -pedantic";
    # }));

    };

  };

  # lua51Packages = lua5_1.pkgs;
  luaPackages = lua.pkgs;
}
