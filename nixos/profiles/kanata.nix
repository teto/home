{ config, lib, pkgs, ... }:
{

 environment.systemPackages = [

  # Layer arrows has 8 item(s), but requires 60 to match defsrc
   pkgs.kanata
 ];

 services.kanata =  {
  enable = true;
 
  keyboards =  {

	main = {
	 devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
     # (include other-file.kbd)
     # doesnt work because of permissions
     #       (include /home/teto/home/config/kanata/extra.kbd)
	 # config = builtins.readFile ../../config/kanata/main.kbd;
     config = ''
        (include /home/teto/home/config/kanata/main.kbd)
        '';
	 # extraArgs = [];
	 # extraDefCfg = ''
	 #  '';
	};
  };
 };
}
