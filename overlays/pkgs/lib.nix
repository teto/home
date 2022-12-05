{ lib }:
{
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
    ]
    ++ optional (isNixAtLeast "2.4pre") (if machine.publicHostKey != null then machine.publicHostKey else "-"));

}
