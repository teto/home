self: prev:
rec {

  lua5_1 = prev.lua5_1.override {


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

      # luarocks-nix = luaprev.luarocks-nix.overrideAttrs(oa: {
      #   pname = "toto";
      #   src = /home/teto/luarocks2;
      # });

      # prev.lib.traceValSeq 
      cqueues = ( luaprev.cqueues.override({
        # name = "matt";
        # pname = "matt";
        disabled = false;
      }));
    };

  };

  lua51Packages = lua5_1.pkgs;
}
