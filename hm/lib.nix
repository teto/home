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

  # TODO hopefully should get upstreamed
  mkRemoteBuilderDesc = machine:
    with lib;
    concatStringsSep " " ([
      "${optionalString (machine.sshUser != null) "${machine.sshUser}@"}${machine.hostName}"
      (if machine.system != null then machine.system else if machine.systems != [ ] then concatStringsSep "," machine.systems else "-")
      (if machine.sshKey != null then machine.sshKey else "-")
      (toString machine.maxJobs)
      (toString machine.speedFactor)
      (concatStringsSep "," (machine.supportedFeatures ++ machine.mandatoryFeatures))
      (concatStringsSep "," machine.mandatoryFeatures)
      # assume we r always > 2.4
	  (if machine.publicHostKey != null then machine.publicHostKey else "-")
    ]
    );

}
