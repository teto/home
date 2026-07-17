{
  flakeSelf
, pkgs
, secrets
, ...
}:
{

  home.stateVersion = "26.05";

  programs.ssh.enable = true;

  programs.ssh.enableDefaultConfig = false;

  imports = [
    flakeSelf.homeModules.nixpkgs-monitor
  ];

  services.nixpkgs-monitor = {
    enable = true;
    # TODO send a mail
  on-branch-advance-cmd = pkgs.writeShellScript "notify-advancement" ''

    message="nixpkgs advanced";
    branch_name="$1"
    old_revision="$2"
    new_revision="$3"
    timestamp="$4"

    title="$branch_name advanced";

    message=<<<EOF
      New revision: $new_revision
      Previous revision: $old_revision

      Timestamp: $timestamp
    EOF

    echo "$message" | msmtp --read-envelope-from --read-recipients -afastmail ${secrets.users.teto.email}
  '';

    # on-branch-advance-cmd
  };

}
