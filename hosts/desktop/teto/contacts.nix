{ config, pkgs, lib, secrets, ... }:

let 
  tetoLib = pkgs.callPackage ../../../hm/lib.nix {};
in
{
  home.packages = with pkgs; [
    # need gnome-accounts to make it work
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
