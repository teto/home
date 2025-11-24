{
  # config,
  pkgs,
  # options,
  # lib,
  # , secrets
  # secretsFolder,
  ...
}:
{
  programs.zsh.enable = true;

  users.users.teto = {

    # name = "Matt"; # This fucks up everything

    shell = pkgs.zsh;

    isNormalUser = true; # creates home/ sets default shell
    uid = 1000;
    extraGroups = [
      "audio" # for pulseaudio/pipewire
      "dialout" # to access serial devices like the conbee II
      "docker" # to access docker socket
      "input" # for libinput-gestures
      "i2c" # to control brightness of the screen
      "keys"
      "kvm" # needed when using runAsRoot when building dockerImage
      "networkmanager" # not necessary for nixpos
      "pipewire" # for pipewire
      "plugdev" # for udiskie
      "podman"
      "postgres"
      "rtkit" # for pipewire
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
