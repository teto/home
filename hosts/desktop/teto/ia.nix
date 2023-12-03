{ config, lib, pkgs, ... }:
{
   home.packages = with pkgs; [

    # from overlay
    ollamagpu # st config.withCuda to enable 
   ];
}
