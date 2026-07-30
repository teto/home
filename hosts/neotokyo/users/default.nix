{
  config,
  pkgs,
  lib,
  ...
}:
{
  groups.media = {
    members = [
      # doesnt have a user ?
      # config.users.users.${config.services.jellyfin.user}.name
      config.users.users.teto.name
    ]
    ++
      lib.optional config.services.transmission.enable
        config.users.users.${config.services.transmission.user}.name

    ;
  };
  groups.backup = { };
  groups.www = { };

  users.nginx.extraGroups = [ "acme" ];
  # that's where we
  # users.jellyfin = {
  #   # that's where we gonna store our libraries
  #   createHome = true;
  # };
  # users.media = {
  #   # that's where we gonna store our libraries
  #   # todo create some directories like movies/music with tmpfiles.d ?
  #   createHome = true;
  # };

  users.teto = {
    # name = "Matt";
    extraGroups = [
      "nextcloud" # to be able to list files
      "backup" # to read
      "www" # to be able to write into the nginx read folder /var/www

      "media"
      # "jellyfin"
    ];
  };
  users.postgres = {
    extraGroups = [
      "backup"
      config.users.groups.backup.name
    ];
  };

  users.gitolite.extraGroups = [
    "www"
    "nginx"
  ];

  # might not be needed anymore ? for gitolite ?
  users.git = {
    isSystemUser = true;
    group = "www";
    home = "/home/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = config.users.users.teto.openssh.authorizedKeys.keys ++ [
      # your ssh key here
      # ../../perso/keys/id_rsa.pub
    ];
  };

  users.immich.extraGroups = [
    "video"
    "render"
  ];

}
