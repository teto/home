{
  lib,
  # flakeSelf,
  secretsFolder
}:
final: prev:
{
  tetos = {
    # TODO pass icon
    muteAudio = prev.writeShellScript "mute-volume" ''

      ${final.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;
    ''
    # todo conditionalize it
    #    + ''
    # ${notify-send} --icon=speaker_no_sound -e -h boolean:audio-toggle:1 -h string:synchronous:audio-volume -u low 'Toggling audio';
    # ''
    ;
  };

  pass-import-high-password-length = final.passExtensions.pass-import.overrideAttrs {

    src = final.fetchFromGitHub {
      owner = "teto";
      repo = "pass-import";
      rev = "d903431e73e88406c32e58196a468662bca55055";
      hash = "sha256-95BJ5l0JNem8zHF6aJwA7TijORGOX2DK5rIw5DGJe+k=";
    };

  };

  backblaze-b2-tetos = final.backblaze-b2.override { execName = "b2"; };

  firefox-addons = import ./firefox/generated.nix {
    # inherit (lib.firefox)       buildFirefoxXpiAddon;
    inherit lib;
    # inherit (final)
    #   # fetchurl
    #   stdenv ;
  };

  # in the source code we have:
  # PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
  # EXTENSIONS="${PASSWORD_STORE_EXTENSIONS_DIR:-$PREFIX/.extensions}"
  # cant put into by-name because of secretsFolder
  pass-perso = final.writeShellApplication {
    name = "pass-perso";
    runtimeInputs = [
      # final.pass-teto
    ];
    text = ''
      export PASSWORD_STORE_DIR="${secretsFolder}/password-store-perso"
      ${final.pass-teto}/bin/pass $@
    '';
    checkPhase = ":";
  };

  protocol-local = prev.protocol.overrideAttrs (oldAttrs: {
    src = fetchGit { url = "https://github.com/teto/protocol"; };
  });

  termscp-matt = prev.termscp.overrideAttrs (oa: {
    cargoBuildFlags = "--no-default-features";
  });

  # xdg-utils = prev.xdg-utils.overrideAttrs(oa: {
  #   pname = "xdg-utils-custom";
  #   name = "xdg-utils-custom-matt";
  #   # version = "matt";
  #   patches = [
  #     ./patches/xdg_utils_symlink.diff
  #   ];
  # });

}
