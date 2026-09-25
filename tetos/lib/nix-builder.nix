{
  # lib,
  # flakeSelf,
  secretsFolder,
  ...
}:
let
  defaultBuilderAttrs =
    {
      # or ssh-ng ?
      protocol ? "ssh",
      # TODO set it to -1 to adapt to machine ?
      maxJobs ? 2,
      speedFactor ? 1,
      supportedFeatures ? [ ],
      mandatoryFeatures ? [ ],
      system ? "x86_64-linux",
    }@builderAttrs:
    builderAttrs
    // {
      inherit
        system
        protocol
        maxJobs
        speedFactor
        supportedFeatures
        mandatoryFeatures
        ;
    };
in
{
  # call with
  mk_builder_from_deployrs_node = nodes: [ ];

  deployrsNodeToBuilderAttr =
    node:
    # mcfg = node.config.
    {
      hostname = node.hostname;
      protocol = "ssh";
      sshUser = "teto";
    };

  # we should be able to remove the defaults after nixpkgs changes
  inherit defaultBuilderAttrs;

  nixosConfToBuilderAttr =
    # {
    #   # or ssh-ng ?
    #   protocol ? "ssh",
    #   # TODO set it to -1 to adapt to machine ?
    #   maxJobs ? 2,
    #   speedFactor ? 1,
    #   supportedFeatures ? [ ],
    #   mandatoryFeatures ? [ ],
    #   system ? "x86_64-linux",
    #   ...
    # }@
    builderAttrs: nixosConf:
    let

      cfg = nixosConf.config;
    in
    (defaultBuilderAttrs { })
    // builderAttrs
    // {
      hostName = cfg.networking.hostName;
      sshUser = "teto";
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;

    };
}
