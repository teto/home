# { config, lib, pkgs, ... }:
# let
# cfg = config.programs.neovim;
# in
# {
#   options = {
#
#
# programs.neovim = {
#     config = mkOption {
# type = types.nullOr types.lines;
# description = "Script to configure this plugin. The scripting language should match type.";
# default = null;
# }
# # Each user has a unique string representing them.
# programs.toto = 
# }
