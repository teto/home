final: prev:
{

  # lib = final.callPackage ./lib.nix {};
  # inherit (final.callPackage ./lib.nix { }) mkRemoteBuilderDesc;

  # copy/pasted from 
  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix?ref_type=heads
  # prev.lib.makeOverridable (
  buildFirefoxXpiAddon = ({ stdenv ? final.stdenv 
    , fetchurl ? final.fetchurl, pname, version, addonId, url, sha256, meta, ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });

  Rdebug = final.lib.enableDebugging (prev.R);

  # see https://github.com/NixOS/nixpkgs/pull/156974
  # i3lock = let
  #   patchedPkgs = import (builtins.fetchTarball {
  #     url = "https://github.com/nixos/nixpkgs/archive/ffdadd3ef9167657657d60daf3fe0f1b3176402d.tar.gz";
  #     sha256 = "1nrz4vzjsf3n8wlnxskgcgcvpwaymrlff690f5njm4nl0rv22hkh";
  #   }) {
  #     inherit (prev) system config;
  #     # inherit (prev) overlays;  # not sure
  #   };
  #   patchedPam = patchedPkgs.pam;
  # in 
  #   prev.i3lock.override { pam = patchedPam; };
  # apply the same patch to other packages

  # gufw = prev.callPackage ./gufw {};
  # upstreamed already
  # myHelm = final.wrapHelm final.kubernetes-helm {
  #   plugins = with final.kubernetes-helmPlugins; [ helm-s3 helm-secrets helm-diff ];
  # };
  buku_run = prev.stdenv.mkDerivation rec {
    pname = "buku_run";
    version = "0.1.1";

    src = prev.fetchFromGitHub {
      owner = "teto";
      repo = "buku_run";
      rev = "50aac85f8e42618cfd636f5040ba690a7e365d6f";
      sha256 = "1r90zpg5m717rnj29lngd6sqdq5214y0v96b7f05xh42ysbdr2gd";
    };
    # src = prev.fetchFromGitHub {
    #   owner = "carnager";
    #   repo = "buku_run";
    #   rev =  version;
    #   sha256 = "1zyjjf3b8g3dnymcrg683rbnc6qrvx8ravfm833n7kjrqky3bczn";
    # };
    buildPhase = ":";

    postUnpack = ''
      patchShebangs .
    '';

    installFlags = [ "PREFIX=$(out)" ];

    buildInputs = with prev.pkgs; [ rofi gawk gnused buku bash ];
    # propagatedBuildInputs = [ rofi ];

  };

  # qtgo = prev.callPackage ./qtgo {};

  # haskell-docs-cli = prev.haskellPackages.callCabal2nix "haskell-docs-cli" (prev.fetchzip {
  #       url = "https://github.com/lazamar/haskell-docs-cli/archive/e7f1a60db8696fc96987a3447d402c4d0d54b5e0.tar.gz";
  #       sha256 = "sha256-/9VjXFgbBz/OXjxu8/N7enNdVs1sQZmUiKhjSTIl6Fg=";
  #     }) {};

  menutray = prev.callPackage ./menutray { };

  colr = prev.callPackage ./colr { };

  # mda-lite = prev.pythonPackages.callPackage ./mda-lite {};

  # rustNightlyPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform rust-nightly);
  # rt-tests = prev.callPackage ./rt-test.nix {};
}
