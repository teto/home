{ lib, pkgs, flakeSelf, ... }:
{
  systemPackages =
    let
      # loop over those
      resticWrapper =
        flakeSelf.nixosConfigurations.neotokyo.config.services.restic.backups.nextcloud-to-backblaze.generatedWrapper;
    in
    [
      pkgs.noto-fonts-cjk-sans
      resticWrapper
      flakeSelf.nixosConfigurations.neotokyo.config.services.restic.backups.immich-db-to-backblaze.generatedWrapper
    ];

  pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  etc."codex/requirements.toml".text = ''
    check_for_update_on_startup = false
  '';

  # Keep authored skills editable outside the Nix store.
  etc."codex/skills".source = "/home/teto/cv/skills";

  etc."lemurs/wayland/sway-systemd" = {
    mode = "755";
    # sway creates systemd.user.targets.sway-session
    # for now we import everything
    # /nix/store/rxzvps8zldnz4sgphbw6893n6ikai6gn-dbus-1.14.10/bin/dbus-update-activation-environment --systemd  --all
    # is this the one ?
    text = ''
      #! /bin/sh
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all;
      systemctl start --user --wait sway-session.service
    '';
  };

  # service-name
  #              is the friendly name the service is known by and looked up
  #              under.  It is case sensitive.  Often, the client program is
  #              named after the service-name.
  #
  #       port   is the port number (in decimal) to use for this service.
  #
  #       protocol
  #              is the type of protocol to be used.  This field should
  #              match an entry in the protocols(5) file.  Typical values
  #              include tcp and udp.
  #
  #       aliases
  #              is an optional space or tab separated list of other names
  #              for this service.  Again, the names are case sensitive.
  #
  # sources
  #      services.source = pkgs.iana-etc + "/etc/services";
  #
  ## /etc/protocols: IP protocol numbers.
  # protocols.source = pkgs.iana-etc + "/etc/protocols";
  # nusrp            49001/tcp  # Nuance Unity Service Request Protocol
  etc.services.text = lib.mkForce ''
    piper   10200/tcp
    hass    8123/tcp
  '';

etc."security/limits.conf".text = ''
    #[domain]        [type]  [item]  [value]
    teto  soft  core  unlimited
    teto  soft  memlock 128
    *  hard  memlock  256
    @audio   -  nice     -20
  '';

  # systemd.services."systemd-coredump".serviceConfig.ProtectHome = false;
  # systemd.services."systemd-coredump@".serviceConfig.ProtectHome = false;
  # environment.etc."systemd/system/systemd-coredump@.service.d/override.conf".text = ''
  #   ProtectHome=no
  # '';
  # this is slow
  #   includeAllModules = true;
  # };

}
