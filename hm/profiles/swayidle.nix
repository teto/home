{ lib, pkgs, ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
  };
}
