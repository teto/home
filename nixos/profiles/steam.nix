{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;

    # https://www.reddit.com/r/NixOS/comments/1ri2dvk/psa_you_can_set_global_environment_variables_for/
    # package = pkgs.steam.override({
    #   extraEnv = {
    #   MANGOHUD="1";
    #
    #   };
    # });
  };
}
