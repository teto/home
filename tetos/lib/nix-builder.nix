{
  lib,
  flakeSelf,
  secretsFolder,
  ...
}:
{
  # call with 
  mk_builder_from_deployrs_node = nodes:

       

      [];
      # lib.mkRemote
    

  # lib.mkRemoteBuilderDesc nixVersion machine;
  deployrsNodeToBuilderAttr = node: 
    # mcfg = node.config.
    {
      hostname =  node.hostname;
      protocol = "ssh";
      sshUser = "teto";
    };

    # we should be able to remove the defaults after nixpkgs changes
    nixosConfToBuilderAttr = 
      { 
        protocol ? "ssh",
        maxJobs ? 2,
        speedFactor ? 1,
        supportedFeatures ? [],
        mandatoryFeatures ? [],
        system ?  "x86_64-linux",
        ...
      }@builderAttrs:
      nixosConf:
    let

    cfg = nixosConf.config;
  in
    builderAttrs // {
      hostName =  cfg.networking.hostName;
      inherit system protocol maxJobs speedFactor supportedFeatures mandatoryFeatures;
      sshUser = "teto";
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;

    };

  # builder0 = lib.mkRemoteBuilderDesc "3.0" 
  #     (deployrsNodeToBuilderAttr flakeSelf.deploy.nodes.jedha);
}
