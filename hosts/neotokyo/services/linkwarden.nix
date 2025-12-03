{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.linkwarden = {

    enable = false;
    # secretFiles.NEXTAUTH_SECRET = ;
    secretFiles = {
      NEXTAUTH_SECRET = "/path/to/secret_file";
      # MEILI_MASTER_KEY= "/path/to/secret_file";
      # POSTGRES_PASSWORD= "/path/to/secret_file";
    };
  };

}
