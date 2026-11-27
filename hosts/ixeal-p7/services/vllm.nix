/*
Depends on https://github.com/NixOS/nixpkgs/pull/578206/commits
*/
{ lib, pkgs, ... }:
{
  system.services.vllm = {
    imports = [ pkgs.vllm.services.default ];
    vllm = {
      # package = lib.mkForce (fakeVllm pkgs);
      settings = {
        listen = "127.0.0.1";
        # invert of llama default
        port = 1339;
      };
    };
  };
}
