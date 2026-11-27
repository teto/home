{
  lib,
  buildGoModule,
  rustPlatform,
  fetchFromGitHub,
  symlinkJoin,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  wayland,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  dbus,
}:

let
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "dimonomid";
    repo = "montray";
    tag = "v${version}";
    hash = "sha256-zdSOBpJKWGYUobmU0i1zShe5+LJYk0Bq1TG9upucIj8=";
  };

  meta = {
    description = "Tray icon and desktop alerts for systemd services and custom health checks";
    homepage = "https://github.com/dimonomid/montray";
    changelog = "https://github.com/dimonomid/montray/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };

  server = buildGoModule {
    pname = "montray-server";
    inherit version src;

    vendorHash = "sha256-+J40PAPXF2KzDASNxMC532pqRg6ffgZGPqpXuBYKRZM=";

    subPackages = [ "cmd/montray-server" ];

    env.CGO_ENABLED = 0;
    tags = [ "packaged" ];

    # these assert on the default (non-ldflags) version string
    checkFlags = [
      "-skip=^(TestVersionFlagPrintsBuildInformation|TestPackagedVersionShowsBuildMode)$"
    ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/dimonomid/montray/v2/version.version=${version}"
      "-X github.com/dimonomid/montray/v2/version.builtBy=nix"
    ];

    postInstall = ''
      install -Dm644 packaging/montray-server/montray-server.service \
        $out/lib/systemd/system/montray-server.service
      substituteInPlace $out/lib/systemd/system/montray-server.service \
        --replace-fail /usr/bin/montray-server $out/bin/montray-server
      install -Dm644 packaging/montray-server/montray-server.sysusers \
        $out/lib/sysusers.d/montray.conf
      install -Dm644 packaging/montray-server/montray-server.yml \
        $out/share/montray/montray-server.yml
    '';

    meta = meta // {
      mainProgram = "montray-server";
    };
  };

  runtimeLibs = [
    fontconfig
    freetype
    libxkbcommon
    wayland
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
  ];

  ui = rustPlatform.buildRustPackage {
    pname = "montray-ui";
    inherit version src;

    sourceRoot = "${src.name}/cmd/montray-ui";

    cargoHash = "sha256-W+QAQtkyujJogXEsxS3xjbNtEUBNUaTtRD1OtFqxqcA=";

    buildFeatures = [ "packaged" ];

    env = {
      MONTRAY_BUILD_VERSION = version;
      MONTRAY_BUILT_BY = "nix";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = runtimeLibs ++ [ dbus ];

    # tests need a display / network
    doCheck = false;

    postInstall = ''
      install -Dm644 ../../packaging/montray-ui/montray-ui.desktop \
        $out/share/applications/montray-ui.desktop
      substituteInPlace $out/share/applications/montray-ui.desktop \
        --replace-fail /usr/bin/montray-ui montray-ui
      install -Dm644 ../../packaging/montray-ui/montray-ui.svg \
        $out/share/icons/hicolor/scalable/apps/montray-ui.svg
    '';

    # winit / slint dlopen these at runtime
    postFixup = ''
      patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/montray-ui
    '';

    meta = meta // {
      mainProgram = "montray-ui";
    };
  };
in
symlinkJoin {
  pname = "montray";
  inherit version;
  paths = [
    server
    ui
  ];
  passthru = {
    inherit server ui;
  };
  meta = meta // {
    mainProgram = "montray-ui";
  };
}
