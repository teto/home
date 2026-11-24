# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  pkgs,
  flakeSelf,
  config,
  withSecrets,
  secrets,
  ...
}:
{
  imports = [
    flakeSelf.inputs.flyline.nixosModules.default
    flakeSelf.inputs.nixos-wsl.nixosModules.default

    flakeSelf.nixosModules.default-hm

    flakeSelf.nixosProfiles.universal
    flakeSelf.nixosProfiles.docling-serve
    flakeSelf.nixosProfiles.nix-daemon
    flakeSelf.nixosProfiles.teto
    flakeSelf.nixosModules.tetos # to generate ssh config

    ../wsl/services/llamacpp.nix
    ../wsl/services/openssh.nix

    ./hardware.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  tetos.withSecrets = true;

  programs.flyline.enable = true;

  boot.kernelParams = [ 
	  "nomodeset"  # until we fix nvidia drivers
	  ];

  # Enable graphics & NVIDIA driver
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland and recommended overall
    modesetting.enable = true;

    # Enable power management (helps with suspend/resume)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use NVIDIA's open-source kernel modules for Turing (GTX 16xx / RTX 20xx) or newer GPUs
    open = true;

    # Optional: enable the nvidia-settings GUI tool
    nvidiaSettings = true;

    # Default driver package (stable branch)
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    # mount-nvidia-executables = false;
    # suppressNvidiaDriverAssertion = true;
    # disable-hooks = [];
  };

  # hardware.nvidia.modesetting.enable = true;
  environment.systemPackages =
    with pkgs;
    let
      myNeovim = neovim.overrideAttrs {
        waylandSupport = false;
      };
    in
    [
      git
      # pkgs.huggingface-cli # hf ...
      pkgs.claude-code
      myNeovim
      systemctl-tui
      wget
      btop-cuda # for jedha
      config.services.llama-cpp.package

      # vllm # broken on arm
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "p7"; # Define your hostname.
  networking.hostName = "p7"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  # was triggering suspends
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."teto" = {
    isNormalUser = true;
    description = "ixeal";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
