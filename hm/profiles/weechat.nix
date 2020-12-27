{ config, pkgs, lib,  ... }:
{
  customWeechat = weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with pkgs.weechatScripts; [
        # weechat-xmpp weechat-matrix-bridge
        wee-slack
      ];
      init = ''
        /set plugins.var.python.jabber.key "val"
      '';
    };
  };

  # there is no such module
  # programs.weechat = {
  #   enable = true;
  #   # plugins = 
  #   init = ''
  #   '';
  # };
}
