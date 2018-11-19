self: prev:
rec {

  # lua = prev.lua.override {

  #   packageOverrides = luaself: luaprev: {

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

  #   };
  # };
}
