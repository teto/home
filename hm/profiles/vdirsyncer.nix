{ config, pkgs, lib, secrets, ... }:
{

  programs.khal = {
   enable = true;
   # need a locale to be set
  };

  # broken
  # xdg.configFile."khal/config".text = lib.mkBefore '' 
# highlight_event_days = True
# show_all_days = False
# # timedelta = "2d"

# [locale]
# # default_timezone = Asia/Tokyo
# # local_timezone= Asia/Tokyo
# unicode_symbols=True

  #  '';

  programs.vdirsyncer = {
    enable = true;
    # package = pkgs.vdirsyncerStable;  # can conflict

  };

  services.vdirsyncer = {
    enable = true;
  };
}
