{ config, pkgs, lib,  ... }:
let
  myWeechat = pkgs.weechat.override {
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
in
{

  home.packages = [
    myWeechat
  ];

  home.sessionVariables = {
    WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
  };

  # there is no such module
  # programs.weechat = {
  #   enable = true;
  #   # plugins = 
  #   init = ''
  #   '';
  # };
}
