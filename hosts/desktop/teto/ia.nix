{ config, lib, pkgs, flakeInputs, ... }:
{
   home.packages = with pkgs; [

    # from overlay
    ollamagpu # st config.withCuda to enable 

    flakeInputs.localai.packages.${pkgs.system}.local-ai-cublas #cublas is the cuda version
   ];
}
