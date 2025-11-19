{
  lib,
  flakeSelf,
  ...
}:
rec {
  # call with 
  mk_builder_from_deployrs_node = nodes:

       

      [];
      # lib.mkRemote
    

  # lib.mkRemoteBuilderDesc nixVersion machine;
  deployrsNodeToBuilderAttr = node: 
    # mcfg = node.config.
    {

      hostname =  node.hostname;
    };
  builder0 = lib.mkRemoteBuilderDesc "3.0" 
      (deployrsNodeToBuilderAttr flakeSelf.deploy.nodes.jedha);
}
