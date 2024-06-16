{
  config,
  lib,
  pkgs,
  ...
}:
let
  mainConfig = "/home/teto/home/config/kanata/main.kbd";
in
{

  environment.systemPackages = [

    # Layer arrows has 8 item(s), but requires 60 to match defsrc
    pkgs.kanata
  ];

  services.kanata = {
    enable = false;

    keyboards = {

      main = {
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
        # (include other-file.kbd)
        # doesnt work because of permissions
        #       (include /home/teto/home/config/kanata/extra.kbd)
        # config = builtins.readFile ../../config/kanata/main.kbd;
        config = ''
          (include ${mainConfig})
        '';
        # extraArgs = [];
        # extraDefCfg = ''
        #  '';
      };
    };
  };

  systemd.services.kanata-foo.serviceConfig = {
    ProtectHome = lib.mkForce "tmpfs";
    BindReadOnlyPaths = mainConfig;
  };

}
