{

  sane.enable = true;
  # nvidia-container-toolkit.enable = true;

  # for moonloader keyboard
  keyboard.zsa.enable = true;
  bluetooth = {
    enable = true;
    powerOnBoot = false;
    # hsphfpd.enable = false; # conflicts with pipewire
  };
}
