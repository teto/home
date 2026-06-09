{
  pkgs,
  ...
}:
{
  # necessary else nixpkgs complains teto wont be able to login
  programs.zsh.enable = true;

  users.users.teto = {

    # name = "Matt"; # This fucks up everything

    # use fish at some point ?
    # shell = pkgs.zsh;

    isNormalUser = true; # creates home/ sets default shell
    uid = 1000;
    extraGroups = [
      "docker" # to access docker socket
      "input" # for libinput-gestures
      "keys"
      "podman"
      # "postgres" # useful for testing but maybe not the default ?
      "wheel" # for sudo
      "www" # for zola
      # config.users.groups.keys.name
    ];
    # once can set initialHashedPassword too
    # initialPassword
    # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
    # hashedPassword = secrets.users.teto.hashedPassword;
    hashedPassword = "$6$UcKAXNGR1brGF9S4$Xk.U9oCTMCnEnN5FoLni1BwxcfwkmVeyddzdyyHAR/EVXOGEDbzm/bTV4F6mWJxYa.Im85rHQsU8I3FhsHJie1";

    openssh.authorizedKeys.keyFiles = [
      ../../../perso/keys/id_rsa.pub
      # cant read if not in repo so
      # "${secretsFolder}/ssh/id_rsa.pub"
    ];
  };

  nix.settings.trusted-users = [ "teto" ];
}
