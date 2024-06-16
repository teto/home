{
  config,
  pkgs,
  options,
  lib,
  # , secrets
  ...
}:
{

  users.users.teto = {

    shell = pkgs.zsh;

    isNormalUser = true; # creates home/ sets default shell
    uid = 1000;
    extraGroups =
      [
        "adbusers" # for android tools
        "audio" # for pulseaudio/pipewire
        "dialout" # to access serial devices like the conbee II
        "docker" # to access docker socket
        "hass" # home-assistant
        "input" # for libinput-gestures
        "jupyter"
        "keys"
        "kvm" # needed when using runAsRoot when building dockerImage
        "libvirtd" # for nixops
        "networkmanager" # not necessary for nixpos
        "pgadmin" # pgadmin is such a mess
        "pipewire" # for pipewire
        "plugdev" # for udiskie
        "podman"
        "postgres"
        "rtkit" # for pipewire
        "vboxusers" # to avoid Kernel driver not accessible
        "video" # to control brightness
        "wheel" # for sudo
        "wireshark"
        # config.users.groups.keys.name
      ]
      ++ lib.optional (config.services.kanata.enable)

        "uinput" # required for kanata it seems
    ;
    # once can set initialHashedPassword too
    # initialPassword
    # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
    # hashedPassword = secrets.users.teto.hashedPassword;
    hashedPassword = "$6$UcKAXNGR1brGF9S4$Xk.U9oCTMCnEnN5FoLni1BwxcfwkmVeyddzdyyHAR/EVXOGEDbzm/bTV4F6mWJxYa.Im85rHQsU8I3FhsHJie1";

    openssh.authorizedKeys.keyFiles = [ ../../../perso/keys/id_rsa.pub ];

  };

  nix.settings.trusted-users = [ "teto" ];
}
