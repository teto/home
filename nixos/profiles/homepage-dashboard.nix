{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  services.homepage-dashboard = {
    enable = true;

    # https://pictogrammers.com/library/mdi/
    services = [

      {
        "Self-hosted services" = [
          {
            "Blog" = {
              description = "Blog";
              href = "http://${secrets.jakku.hostname}/";
              siteMonitor = "http://blog.${secrets.jakku.hostname}/";
              icon = "sonarr.png";
            };
            "Immich" = {
              description = "Immich";
              href = "http://immich.${secrets.jakku.hostname}/";
              siteMonitor = "http://immich.${secrets.jakku.hostname}/";
            };
          }
        ];
      }
      {
        "My Second Group" = [
          {
            "My Second Service" = {
              description = "Homepage is the best";
              href = "http://localhost/";
            };
          }
        ];
      }
    ];

    settings = {
      # startUrl: https://custom.url
      title = "hello world";
    };

    # listenPort=
    # oopenFirewall
    bookmarks = [
      {
        Developer = [
          {
            Github = [
              {
                abbr = "GH";
                href = "https://github.com/";
              }
            ];
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = [
              {
                abbr = "YT";
                href = "https://youtube.com/";
              }
            ];
          }
        ];
      }
    ];

  };
}
