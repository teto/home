{
  # temporary workaround
  # error: The option `home-manager.users.teto.sshAuthSock.initialization.bash' has conflicting definition values:
  # - In `/nix/store/0g38m1p4dn1s6sdy2vlq84fiwjivl6gs-source/modules/services/gpg-agent.nix':
  #     ''
  #       unset SSH_AGENT_PID
  #       if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  #         export SSH_AUTH_SOCK="$(/nix/store/k4d44dcjlqp3xr849x985myp0slfhp9n-gnupg-2.4.9/bin/gpgconf --list-dirs agent-ssh-socket)"
  #       fi
  #     ...
  # - In `/nix/store/0g38m1p4dn1s6sdy2vlq84fiwjivl6gs-source/modules/services/ssh-agent.nix': "export SSH_AUTH_SOCK=\"$XDG_RUNTIME_DIR/ssh-agent\""
  # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.

  enable = false;
}
