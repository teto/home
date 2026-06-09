{
  pkgs,
  ...
}:
{
  imports = [
  ];

  users.users.teto = {

    # shell = pkgs.fish;

    extraGroups = [
      "dialout" # to access serial devices like the conbee II
      "docker" # to access docker socket
      "input" # for libinput-gestures
      "keys"
      "podman"
      # "postgres" # useful for testing but maybe not the default ?
      "wheel" # for sudo
      "www" # for zola
      # config.users.groups.keys.name
    ];
  };

  environment.systemPackages = with pkgs; [
    pkgs.btop
    host.dnsutils
    tmux # let it be installed via hm module ?
  ];
}
