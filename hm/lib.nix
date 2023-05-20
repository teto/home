{ pkgs, lib, config, ... }:
{

  # temporary solution since it's not portable
  getPassword = accountName:
    let
      # https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
      # 	  export PASSWORD_STORE_GPG_OPTS=" --default-cache-ttl 34560000"
      script = pkgs.writeShellScriptBin "pass-show" ''
        ${pkgs.pass}/bin/pass show "$@" | ${pkgs.coreutils}/bin/head -n 1
      '';
    in
    ["${script}/bin/pass-show" accountName];

}
