{ pkgs, ... }:
{

  home.packages = [
    pkgs.rmpc # rust mpd client with synced lyrics and cover display !
    pkgs.euphonica # nice looking mpd GUI
    # pkgs.ncmpcpp # outdated/ replaced by rmpc

  ];


}
