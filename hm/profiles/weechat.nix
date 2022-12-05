{ config, pkgs, lib, ... }:
let
  myWeechat = pkgs.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with pkgs.weechatScripts; [
        # weechat-xmpp
        weechat-matrix-bridge
        # wee-slack
      ];
      # /set plugins.var.python.jabber.key "val"
      init = ''
        /mouse enable
      '';
    };
  };
in
{

  home.packages = [
    myWeechat
  ];


  # there is no such module
  # programs.weechat = {
  #   enable = true;
  #   # plugins = 
  #   init = ''
  #   '';
  # };
}
