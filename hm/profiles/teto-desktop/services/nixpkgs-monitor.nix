{
  pkgs,
  secrets,
  lib,
  ...
}:
let
  tetoEmail = secrets.users.teto.email;
in
{
  enable = true;
  # on-branch-advance-cmd = pkgs.writeShellScript "notify-advancement" ''
  #   title="hello";
  #   message="nixpkgs advanced";
  #   notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
  # '';
  on-branch-advance-cmd = lib.nixpkgsMonitorEmailNotifier tetoEmail;
  #   pkgs.writeShellScript "notify-advancement" ''
  #
  #   message="nixpkgs advanced";
  #   branch_name="$1"
  #   old_revision="$2"
  #   new_revision="$3"
  #   timestamp="$4"
  #
  #   title="$branch_name advanced";
  #
  #   message=<<<EOF
  #     New revision: $new_revision
  #     Previous revision: $old_revision
  #
  #     Timestamp: $timestamp
  #   EOF
  #
  #   echo "$message" | msmtp --read-envelope-from --read-recipients -afastmail ${secrets.users.teto.email}
  # '';
}
