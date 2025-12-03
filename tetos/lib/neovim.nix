{ lib, ... }:
let
  genBlockLua = title: content: ''
    -- ${title} {{{
    ${content}
    -- }}}
  '';
in
{
  inherit genBlockLua;

  luaPlugin =
    attrs:
    attrs
    // {
      type = "lua";
      config = lib.optionalString (attrs ? config && attrs.config != null) (
        genBlockLua attrs.plugin.pname attrs.config
      );
    };

}
