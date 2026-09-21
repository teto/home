{
  lib,
  pkgs,
  config,
  ...
}:
{
  includes = [

    { path = config.xdg.configHome + "/git/manual.gitconfig"; }
  ];

  package = pkgs.gitFull; # to get send-email



  settings = {
    # user = {
    #   email = lib.mkForce "886074+teto@users.noreply.github.com";
    # };
    user = {
      # mkForce due to nova
      name = "Matthieu C.";
      email = lib.mkForce "886074+teto@users.noreply.github.com";
    };

    # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
    credential.helper = "store";
  };

  signing = {
    allowedSigners = ''
      teto@tatooine namespaces=git ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC/+rkPJvHRlXBuOI7NSQTAXBBsFjjcKchNm+hIs1kpwrpwNvEQUg1U2xuLvS5AEBdFdqUn6V67uGB6sfSDwS7dUakV5E9Cvmadw0cenZ7DSMaUAqMqAhVtY2Rzx3iNfD2sDBItdU9lyXrg6rwl0nPy+EfJPItV/wvJnI7a8dxdNf0PbbdZTQLDPpGlRec4+tvPQNvwRl5x5Y39jWqtTUrRDF11d/b99lcIaihnPvlRi53FfvypwdMuFf81Ufc/4klAP80GTYIDlWh1juMCF0tIp0rb5iE4+ABbTVAczE2iO8lYYGtqOPe/YGJ+7RwrGnDVdwhsq3A9iT76T2mvLtn 
      '';
    signByDefault = false;

    # key = "64BB6787"; # old key
    key = "88A4D2369454E51E"; # new key
  };

}
