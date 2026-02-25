{ pkgs, ... }:
let

  # found in comment from https://ankiweb.net/shared/info/2055492159
  # https://ankiweb.net/shared/info/734459859
  anki-connect-fixed =

    pkgs.ankiAddons.anki-connect.overrideAttrs (oa: {
      src = pkgs.fetchzip {
        url = "https://ankiweb.net/shared/info/734459859";
        sha256 = "03wi7hz0ffh1ailvs68lj3gnvpx38jqpc2aghapfmym90pmsx2cn";

      };
      sourceRoot = "source/plugin";
    });

  #   pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
  # pname = "anki-connect-fixed";
  # version = "25.11.9.0";
  #
  #   # src = pkgs.fetchFromSourcehut {
  #   #   owner = "~foosoft";
  #   #   repo = "anki-connect";
  #   #   tag = finalAttrs.version;
  #   #   hash = "sha256-cnAH4qIuxSJIM7vmSDU+eppnRi6Out9oSWHBHKCGLZI=";
  #   # };
  #   sourceRoot = "${finalAttrs.src.name}/plugin";
  #   # passthru.updateScript = gitUpdater { };
  #   meta = {
  #     description = ''
  #       Enable external applications such as Yomichan to communicate
  #       with Anki over a simple HTTP API
  #     '';
  #     homepage = "https://ankiweb.net/shared/info/734459859";
  #     # license = lib.licenses.gpl3Plus;
  #     # maintainers = with lib.maintainers; [ junestepp ];
  #   };
  # });

in
{

  enable = true;

  # seems to crash on laptop with vulkan
  videoDriver = "software";
  addons =
    let
      # anki-connect-fixed
      anki-connect-teto = pkgs.ankiAddons.anki-connect.withConfig (
        # as recommended at https://github.com/friedrich-de/mpv-subtitleminer
        {
          config = {
            # TODO I have to set those ?
            # "apiKey"= null,
            # "apiLogPath"= null,
            # "ignoreOriginList": [],
            # "webBindAddress": "127.0.0.1",
            # "webBindPort": 8765,
            "webCorsOriginList" = [
              "http://localhost"
              "null"
            ];
          };
        });

    in
    [
      # addons can be configured with .withConfig
      # pkgs.ankiAddons.anki-connect
      anki-connect-teto

      # fixed one is at 734459859

      # 1845663485
    ];

  answerKeys = [
    {
      ease = 1;
      key = "left";
    }
    {
      ease = 2;
      key = "up";
    }
  ];

}
