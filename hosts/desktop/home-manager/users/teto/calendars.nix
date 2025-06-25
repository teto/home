{
  config,
  pkgs,
  lib,
  secrets,
  tetoLib,
  withSecrets,
  ...
}:
{

  imports = [
  ];

  programs.vdirsyncer = {
    enable = withSecrets;
    # Provide package from stable channel ?
    # package = pkgs.vdirsyncerStable;

  };

  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome-calendar
    calcure # pytthon calendar viewer
  ];

  # accounts.contact = {
  #   basePath = "$XDG_CONFIG_HOME/card";
  #   accounts = {
  #     testcontacts = {
  #       khal = {
  #         enable = true;
  #         # collections = [ "default" "automaticallyCollected" ];
  #       };
  #       local.type = "filesystem";
  #       local.fileExt = ".vcf";
  #       name = "testcontacts";
  #       remote = {
  #         type = "http";
  #         url = "https://example.com/contacts.vcf";
  #       };
  #     };
  #   };
  # };

  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/calendars";

    accounts = {
    };

  };

  # trick to create a directory with proper ownership
  # note that tmpfiles are not necesserarly temporary if you don't
  # set an expire time. Trick given on irc by someone I forgot the name..
  systemd.user.tmpfiles.rules = [
    # 
    # Type Path                      Mode User Group Age         Argument
    "d /home/teto/calendars/fastmail 0755 teto users" 
  ];

  systemd.user.services.vdirsyncer.Service = lib.mkIf config.programs.vdirsyncer.enable {
    Environment = [
      "PATH=$PATH:${
        pkgs.lib.makeBinPath [
          pkgs.pass-teto
          pkgs.bash
        ]
      }"
    ];
  };
}
