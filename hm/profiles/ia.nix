{ config, lib, pkgs, ... }:
{
   home.packages = with pkgs; [

    ollama
   ];

}
