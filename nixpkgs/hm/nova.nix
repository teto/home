{ config, lib, pkgs,  ... }:
let
in
{

  home.packages =  [
    pkgs.aws-sam-cli  # for sam lambda
  ];
}
