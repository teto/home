{ pkgs, ... }:
{
  enable = true;
  on-branch-advance-cmd = pkgs.writeShellScript "notify-advancement" ''
    title="hello";
    message="nixpkgs advanced";
    notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
  '';
}
