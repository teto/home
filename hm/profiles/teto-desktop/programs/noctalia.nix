# Additionally, since ~/.config/noctalia/settings.json is now a read-only symlink, you can get the latest (or GUI-modified) settings via:
# Open Settings Panel -> General -> Copy Settings or by running
# noctalia-shell ipc call state all | jq .settings
# , then use them to update your Nix config for a permanent change.
{ flakeSelf, pkgs, ... }:
{
  enable = true;

  package = flakeSelf.inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # configured differnetly on each host
}
