{ config, pkgs, lib, secrets, ... }:

let 
  hmUtils = pkgs.callPackage ../../../hm/lib.nix {};
in
{
  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    # gnome3.gnome-calendar
  ];

  accounts.contact = {
   # XDG_DATA instead ?
    basePath = ".contacts";

    # basePath = ".contacts";
    accounts = {

     fastmail = {
       khard = {
         enable = true;
        };
      };
    };
  };


  programs.khard = {
   enable = false;

   settings = {
      general = {
        default_action = "list";
        editor = ["nvim" "-i" "NONE"];
        merge_editor = "nvim -d";
      };

   };
  };
}
