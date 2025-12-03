{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  gtk4,
  libadwaita,
  webkitgtk_4_1,
  wrapGAppsHook4,
  pciutils,
  usbutils,
  acpi,
  brightnessctl,
  yad,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "power-options";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "TheAlexDev23";
    repo = "power-options";
    rev = "v${version}";
    hash = "sha256-wHQlo3bTM5IkVNNyqft40HnHYaz3f3OOmkIsSzh1A/U=";
  };

  cargoHash = "sha256-fLm9zewuQsgPc92YOM0i6eLwDB0efIcSe6kKbbk0P6E=";

  doCheck = false; # Skip tests as we're only building specific packages

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk3
    gtk4
    libadwaita
    webkitgtk_4_1
  ];

  # Build the GTK frontend and daemon manager
  buildAndTestSubdir = null;
  cargoBuildFlags = [
    "--package"
    "power-daemon-mgr"
    "--package"
    "frontend-gtk"
  ];

  postInstall = ''
    # Install the GTK frontend with the expected name
    mv $out/bin/frontend-gtk $out/bin/power-options-gtk

    # Install icon if it exists
    if [ -f crates/frontend-gtk/resources/power-options-gtk.png ]; then
      install -Dm644 crates/frontend-gtk/resources/power-options-gtk.png \
        $out/share/icons/hicolor/scalable/apps/power-options-gtk.png
    fi

    # Install desktop file if it exists
    if [ -f crates/frontend-gtk/resources/power-options-gtk.desktop ]; then
      install -Dm644 crates/frontend-gtk/resources/power-options-gtk.desktop \
        $out/share/applications/power-options-gtk.desktop
    fi
  '';

  # Runtime dependencies that need to be in PATH
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          pciutils # lspci
          usbutils # lsusb
          acpi # acpi
          brightnessctl # optional: brightness control
          yad # dialog utility
          xorg.xset # optional: display power management
          xorg.xrandr # optional: display configuration
        ]
      }
    )
  '';

  meta = with lib; {
    description = "Comprehensive Linux GUI application for power management";
    longDescription = ''
      Power Options is a drop-in replacement for tools like TLP and auto-cpufreq,
      offering more profile types than alternatives and intelligent system analysis
      capabilities. It provides both a daemon for power management and a GTK4
      frontend for configuration.
    '';
    homepage = "https://github.com/TheAlexDev23/power-options";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "power-options-gtk";
    platforms = platforms.linux;
  };
}
